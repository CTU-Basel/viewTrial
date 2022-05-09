#' visits UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 


mod_visits_ui <- function(id, label){
  ns <- NS(id)
  
  tabItem(tabName = label,
          
          fluidRow(
            ## No.of participants randomized
            valueBoxOutput(ns("randomized"), width = 3),
            box(
              width = 3,
              selectInput(ns("visit"), "Visit", choices = c("Baseline", "FU1", "FU2"), selected = "Baseline")
              )
          )
          
          , fluidRow(
            box(
              width = 12,
              height = "700",
              title = "Number of visits done in study by center",
              status = "primary",
              plotOutput(ns('visitsplot'), height = "600"),
              solidHeader = TRUE,
              collapsible = FALSE
              )
            )
  )
  
}

#' visits Server Function
#'
#' @noRd 
mod_visits_server <- function(input, output, session, data){
  ns <- session$ns

  output$randomized <- renderValueBox({
    no <- data() %>% filter(Visit == input$visit) %>%  nrow()
    valueBox(value = no, subtitle = "visits", color = "yellow")
  })
  
  output$visitsplot <- renderPlot({

    df <- data() %>%
      group_by(centre.short) %>% 
      add_count(name = "n_all") %>% 
      group_by(centre.short, Visit) %>% 
      add_count(name = "n_by_visits") %>% 
      mutate(perc.visits.done = round(n_by_visits/n_all*100, digits = 1),
             label = paste0(perc.visits.done, "% (",n_by_visits," of ", n_all, ")")) %>% 
      distinct(centre.short, Visit, .keep_all = TRUE) %>% 
      filter(Visit == input$visit) 
      
    ggpubr::ggbarplot(df, x = "centre.short", y = "perc.visits.done", fill = "#a5d7d2",
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
  
}

## To be copied in the UI
# mod_visits_ui("visits_ui_1")

## To be copied in the server
# callModule(mod_visits_server, "visits_ui_1")

