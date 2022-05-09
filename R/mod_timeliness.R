#' timeliness UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_timeliness_ui <- function(id, label){
  ns <- NS(id)
  
  tabItem(tabName = label,
          
          fluidRow(
            box(
              width = 3
              , selectInput(ns("visit"), "Visit", choices = c("Baseline", "FU1", "FU2"), selected = "Baseline")
              )
            
            , valueBoxOutput(ns("qoldone"), width = 3))
          
          , fluidRow(
            tabBox(
              width = 12
              , title = ""
              , id = "tabset1", height = "850px"
              , selected = "Average time taken to first enter QOL data"
              , tabPanel("Average time taken to first enter QOL data", plotOutput(ns('qolfirstplot'), height = "750"))
              , tabPanel("Average time taken to completely enter QOL data", plotOutput(ns('qolcomplplot'), height = "750"))
            )
          )
  )
  
}

#' timeliness Server Function
#'
#' @noRd 
mod_timeliness_server <- function(input, output, session, data){

  
  output$qoldone <- renderValueBox({
    
    df <- data() %>% 
      distinct(centre.short, Visit, .keep_all = TRUE) %>% 
      filter(Visit == input$visit) %>% 
      adorn_totals("row") %>% 
      filter(pat_id == "Total") 
    
    no <- df %>% pull(nr.qol.done)
    valueBox(value = no, 
             subtitle = "QOL done", color = "yellow")
  })
  
  output$qolfirstplot <- renderPlot({
    
    df <- data() %>% 
      distinct(centre.short, Visit, .keep_all = TRUE) %>% 
      filter(Visit == input$visit) %>% 
      ## Create label for each entry
      mutate(label = paste0(mean.first.entry, " (n=", nr.qol.done,")"))
    
    ggpubr::ggbarplot(df, x = "centre.short", y = "mean.first.entry", fill = "#a5d7d2",
                      xlab = "Center",
                      ylab = "Mean time for first entry (days)",
                      width = 0.6,
                      lab.size = 3,
                      lab.pos = "out",
                      label = df$label,
                      alpha = 0.5,
                      ggtheme = theme_pubclean(base_size = 12),
                      caption = "") %>% 
      ggpubr::ggpar(legend = c("top"), 
                    x.text.angle = 30,
                    legend.title = "")
  })
  
  output$qolcomplplot <- renderPlot({
    
    df <- data() %>% 
      distinct(centre.short, Visit, .keep_all = TRUE) %>% 
      filter(Visit == input$visit) %>% 
      mutate(label = paste0(mean.compl.entry, " (n=", nr.qol.compl,")"))
    
    ggpubr::ggbarplot(df, x = "centre.short", y = "mean.compl.entry", fill = "#a5d7d2",
                      xlab = "Center",
                      ylab = "Mean time for complete entry (days)",
                      width = 0.6,
                      lab.size = 3,
                      lab.pos = "out",
                      label = df$label,
                      alpha = 0.5,
                      ggtheme = theme_pubclean(base_size = 12),
                      caption = "") %>% 
      ggpubr::ggpar(legend = c("top"), 
                    x.text.angle = 30,
                    legend.title = "")
  })

  
}

## To be copied in the UI
# mod_timeliness_ui("timeliness_ui_1")

## To be copied in the server
# callModule(mod_timeliness_server, "timeliness_ui_1")

