#' completeness UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_completeness_ui <- function(id, label){
  
  ns <- NS(id)
  
  tabItem(tabName = label,
          
          fluidRow(
            box(
              width = 3
              , selectInput(ns("visit"), "Visit", choices = c("Baseline", "FU1", "FU2"), selected = "Baseline"))
            
            , valueBoxOutput(ns("visitsdone"), width = 3))
          
          , fluidRow(
            tabBox(
              width = 12
              , title = ""
              , id = "tabset1", height = "850px"
              , selected = "Proportion of visits with QOL done"
              , tabPanel("Proportion of visits with QOL done", plotOutput(ns('qolplot'), height = "750"))
              , tabPanel("Proportion of QOL assessments with complete forms", plotOutput(ns('qolcomplplot'), height = "750"))
            )
          )
          
  )
}

#' completeness Server Function
#'
#' @noRd 
mod_completeness_server <- function(input, output, session, data){
  
  # data.visits <- get_visits(data())
  
  output$visitsdone <- renderValueBox({
  
    df <- data() %>% 
      filter(Visit == input$visit) %>% 
      adorn_totals("row") %>% 
      filter(pat_id == "Total") 
    
    no <- df %>% pull(nr.visits.done)
    valueBox(value = no, 
             subtitle = "Visits done", color = "yellow")
  })
  
  output$qolplot <- renderPlot({

    df <- data() %>%
      distinct(centre.short, Visit, .keep_all = TRUE) %>% 
      filter(Visit == input$visit) %>%
      ## Create label for each entry
      mutate(perc.qol.done = round(nr.qol.done/nr.visits.done*100, digits = 2),
             label = paste0(nr.qol.done,"/", nr.visits.done, " \n(", perc.qol.done, "%)"))

    ggpubr::ggbarplot(df, x = "centre.short", y = "perc.qol.done", fill = "#a5d7d2",
                      xlab = "Center",
                      ylab = "n",
                      width = 0.6,
                      lab.size = 3,
                      lab.pos = "out",
                      label = df$label,
                      alpha = 0.5,
                      ggtheme = theme_pubclean(base_size = 12),
                      position = position_dodge(),
                      caption = "") %>%
      ggpubr::ggpar(legend = c("top"),
                    x.text.angle = 30,
                    legend.title = "")

  })

  output$qolcomplplot <- renderPlot({

    df <- data() %>%
      distinct(centre.short, Visit, .keep_all = TRUE) %>% 
      filter(Visit == input$visit) %>%
      ## Create label for each entry
      mutate(perc.qol.compl = round(nr.qol.compl/nr.visits.done*100, digits = 2),
             label = paste0(nr.qol.compl,"/", nr.qol.done, " \n(", perc.qol.compl, "%)"))

    ggpubr::ggbarplot(df, x = "centre.short", y = "perc.qol.compl", fill = "#a5d7d2",
                      xlab = "Center",
                      ylab = "n",
                      width = 0.6,
                      lab.size = 3,
                      lab.pos = "out",
                      label = df$label,
                      alpha = 0.5,
                      ggtheme = theme_pubclean(base_size = 12),
                      position = position_dodge(),
                      caption = " ") %>%
      ggpubr::ggpar(legend = c("top"),
                    x.text.angle = 30,
                    legend.title = "")

  })
  
}

## To be copied in the UI
# mod_completeness_ui("completeness_ui_1")

## To be copied in the server
# callModule(mod_completeness_server, "completeness_ui_1")


