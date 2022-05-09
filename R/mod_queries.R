#' queries UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_queries_ui <- function(id, label){
  
  ns <- NS(id)
  
  tabItem(tabName = label,
          
          fluidRow(
              box(width = 3
                ## Select input menu for visits 
                , selectInput(ns("visit"), "Visit", choices = c("Baseline", "FU1", "FU2"), selected = "Baseline")
              )
              ## Valueboxes for number of queries
              , valueBoxOutput(ns("nrtotalqr"), width = 2)
              , valueBoxOutput(ns("nransqr"), width = 2)
              , valueBoxOutput(ns("nrresqr"), width = 2)
              , valueBoxOutput(ns("nropenqr"), width = 2)
          ),
          
          fluidRow(
            tabBox(
              width = 12,
              title = "",
              id = "status_queries", height = "600px",
              selected = "Status of all queries",
              tabPanel("Status of all queries", plotOutput(ns('querystatusplot'), height = "550"))
            )
          )
  )
}

#' queries Server Function
#'
#' @noRd 
mod_queries_server <- function(input, output, session, data){
 
  ## Generate list of queries
  ls.queries <- reactive({
  
    nr.rows <- data() %>% nrow()
    df <- purrr::map_dfr(1:nr.rows, get_queries, df = data())
    no <- df %>% nrow()
    set.seed(12481498)
    df %<>% mutate(querystatus = sample(c("answered", "open", "closed"), no, replace = TRUE, prob = c(0.5, 0.2, 0.3)))
    return(df)
    
  })
  
  ## No.of total queries
  output$nrtotalqr <- renderValueBox({
    no <- ls.queries() %>% filter(Visit == input$visit) %>% nrow()
    valueBox(value = tags$p(no, style = "font-size: 80%;"), subtitle = "total queries", color = "yellow")
  })

  # No.of answered queries
  output$nransqr <- renderValueBox({

    no <- ls.queries() %>% filter(querystatus == "answered" & Visit == input$visit) %>% nrow()
    all <- ls.queries() %>% filter(Visit == input$visit) %>% nrow()
    perc <- round(no/all*100, digits = 2)
    valueBox(value = tags$p(paste0(no, " (", perc, "%)"), style = "font-size: 80%;"), subtitle = "answered", color = "yellow")
  })

  ## No.of resolved queries
  output$nrresqr <- renderValueBox({

    no <- ls.queries() %>% filter(querystatus == "closed" & Visit == input$visit) %>% nrow()
    all <- ls.queries() %>% filter(Visit == input$visit) %>% nrow()
    perc <- round(no/all*100, digits = 2)
    valueBox(value = tags$p(paste0(no, " (", perc, "%)"), style = "font-size: 80%;"), subtitle = "closed", color = "yellow")
  })

  ## No.of open queries
  output$nropenqr <- renderValueBox({

    no <- ls.queries() %>% filter(querystatus == "open" & Visit == input$visit) %>% nrow()
    all <- ls.queries() %>% filter(Visit == input$visit) %>% nrow()
    perc <- round(no/all*100, digits = 2)
    valueBox(value = tags$p(paste0(no, " (", perc, "%)"), style = "font-size: 80%;"), subtitle = "open", color = "red")
  })

  output$querystatusplot <- renderPlot({

    df <- ls.queries() %>% filter(Visit == input$visit) %>% 
      group_by(centre.short) %>% 
      add_count(name = "n_all") %>% 
      group_by(centre.short, Visit) %>% 
      add_count(name = "n_by_visit") %>% 
      group_by(centre.short, Visit, querystatus) %>% 
      add_count(name = "n_by_status") %>% 
      mutate(query.rate.status = round(n_by_status/n_by_visit*100, digits = 1),
             querystatus = factor(querystatus)) %>% 
      distinct(centre.short, Visit, querystatus, .keep_all = TRUE) 
    

    ggpubr::ggbarplot(df, x = "centre.short", y = "query.rate.status", fill = "querystatus", color = "#a5d7d2",
                      xlab = "Center",
                      ylab = "Percentage",
                      width = 1,
                      label = paste0(df$query.rate.status,"%", "\n(", df$n_by_status, " of ", df$n_by_visit, ")"),
                      lab.size = 3,
                      alpha = 0.5,
                      palette = c("open" = "#d20537", "answered" = "#bec3c8", "closed" = "#a5d7d2"),
                      ggtheme = theme_pubclean(base_size = 16),
                      position = position_dodge2(preserve = "single")) %>%
      ggpubr::ggpar(legend = c("top"),
                    legend.title = "Query status",
                    x.text.angle = 30,
                    ylim = c(0,110))

  })

}


## To be copied in the UI
# mod_queries_ui("queries_ui_1")

## To be copied in the server
# callModule(mod_queries_server, "queries_ui_1")

