#' recruitment UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @import plotly
#'
#' @noRd
#'
#' @importFrom shiny NS tagList

mod_recruitment_ui <- function(id, label){

  ns <- NS(id)

  tabItem(tabName = label,

          ##
          tags$style(HTML("


      .box.box-solid.box-primary>.box-header {
      color:#fff;
      background:#1ea5a5
                    }

      .box.box-solid.box-primary{
      border-bottom-color:#1ea5a5;
      border-left-color:#1ea5a5;
      border-right-color:#1ea5a5;
      border-top-color:#1ea5a5;
                    }

                  ")),


          fluidRow(
            tags$style(".small-box.bg-yellow { background-color: #a5d7d2 !important; color: #333333 !important; }"),
            tags$style(".small-box.bg-red { background-color: #d20537 !important; color: #333333 !important; }"),
            valueBoxOutput(ns("randomized"), width = 6),
            valueBoxOutput(ns("estimated"), width = 6)
          ),

          fluidRow(
            tabBox(
              width = 12,
              title = "",
              id = "tabset1", height = "850px",
              selected = "Recruitment over time by center",
              tabPanel("Recruitment over time by center",plotlyOutput(ns('recruitplot'), height = "750"))

            )
          )
  )
}

#' recruitment Server Function
#'
#' @noRd
mod_recruitment_server <- function(input, output, session, data){

  ns <- session$ns

 
  
  output$randomized <- renderValueBox({

    df <- data() %>% filter(Visit == "Baseline")
    perc <- round(nrow(df)/150*100, digits = 1)
    valueBox(value = paste0(nrow(df), " out of ", "150", " (", perc, "%)" ),
             subtitle = "Randomized from pre-registered patients (those with inadequate skin flaps are not randomized)",
             icon = icon("user-plus"), color = "yellow")
  })

  output$estimated <- renderValueBox({
    df <- data() %>% filter(Visit == "Baseline")
    perc <- round(nrow(df)/300*100, digits = 1)
    valueBox(value = paste0(nrow(df), " out of ", 300, " (", perc, "%)" ),
             subtitle = "actual out of estimated recruitment", icon = icon("user-plus"), color = "yellow")
  })


    ## Recruitment plot
    output$recruitplot <- renderPlotly({
      df <- data() %>% filter(Visit == "Baseline")
      plot.df <- get_recruitment_plot_df(df)
      max.val <- nrow(df)
      p <- ggplot2::ggplot() + geom_line(mapping = aes(x = Baseline, y = n, color = Center), data = plot.df) +
        labs(x = "Date of randomization", y = "Patients included") +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
              axis.text.y = element_text(size = 10),
              axis.title.x = element_text(size=12, face="bold"),
              axis.title.y = element_text(size=12, face="bold")) +
        scale_y_continuous(breaks=seq(0, max.val, by = 20))

      plotly::ggplotly(p) %>% layout(legend = list(y = 0.5))
    })

}

## To be copied in the UI
# mod_recruitment_ui("recruitment_ui_1")

## To be copied in the server
# callModule(mod_recruitment_server, "recruitment_ui_1")

