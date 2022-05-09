#' safetymgm UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 

library(DT)

mod_sae_ui <- function(id, label){
  
  ns <- NS(id)
  
  tabItem(tabName = label,
          
          
          fluidRow(
            ## No.of participants randomized  
            valueBoxOutput(ns("sae"), width = 4),
            valueBoxOutput(ns("saenr"), width = 4),
            valueBoxOutput(ns("saept"), width = 4)
            
          ),
          
          tabBox(
            width = 12,
            title = "",
            id = "tabset1", height = "650px",
            selected = "SAE severity",
            tabPanel("SAE severity",plotlyOutput(ns('severityplot'), height = "600")),
            tabPanel("SAE causality",plotlyOutput(ns('causalityplot'), height = "600")),
            tabPanel("SAE outcome",plotlyOutput(ns('outcomeplot'), height = "600"))
            
          ),
        
          DT::dataTableOutput(ns("saetable"))
          
  )
  
}

#' safetymgm Server Function
#'
#' @noRd 

mod_sae_server <- function(input, output, session, data){
  
  ls.sae <- reactive({
    
    nr.rows <- data() %>% nrow()
    df <- purrr::map_dfr(1:nr.rows, get_sae, df = data())  
    no <- df %>% nrow()
    set.seed(12481498)
    df %<>% mutate(sae.description = sample(c("bleeding", "embolism", "swelling", "inflammation", "hernia"), no, replace = TRUE),
                   sae_severity = sample(c("mild", "moderate", "severe", "life-threatening"), no, replace = TRUE),
                   sae_causality = sample(c("Not related", "Possibly", "Probably", "Unlikely"), no, replace = TRUE),
                   sae_outcome = sample(c("continuing", "resolved with sequel", "resolved without sequel", "others"), no, replace = TRUE))
    return(df)
    
  })
  
  output$sae <- renderValueBox({
    no <- ls.sae() %>% nrow()
    valueBox(value = no, subtitle = "Serious Adverse Events", color = "red")
  })

  output$saenr <- renderValueBox({
    no <- ls.sae() %>% distinct(pat_id) %>%
      pull(pat_id) %>% length()
    valueBox(value = no , subtitle = "Patients with SAEs", color = "red")
  })

  output$saept <- renderValueBox({
    sae <- ls.sae() %>% nrow()
    pt <- ls.sae() %>% distinct(pat_id) %>%
      pull(pat_id) %>% length()
    no <- round(sae/pt, digits = 1)
    valueBox(value = no , subtitle = "Serious Adverse Events per patient", color = "red")
  })



  output$severityplot <- renderPlotly({

    df <- ls.sae() %>%
      group_by(sae_severity) %>%
      summarise(n = n()) %>%
      mutate(total = sum(n),
             freq = round(n/sum(n)*100, digits = 2))

    ggpubr::ggbarplot(df, x = "sae_severity", y = "freq", fill = "#1ea5a5", color = "#a5d7d2",
                      xlab = "",
                      ylab = "Percentage",
                      label = paste0(df$freq,"%", "\n(", df$n, " of ", df$total, ")"),
                      lab.size = 3,
                      lab.vjust = -0.2,
                      alpha = 0.5,
                      ggtheme = theme_pubclean(base_size = 10)) %>%
      ggpubr::ggpar(legend = "none", x.text.angle = 30)

  })

  output$outcomeplot <- renderPlotly({

    df <- ls.sae() %>%
      group_by(sae_outcome) %>%
      summarise(n = n()) %>%
      mutate(total = sum(n),
             freq = round(n/sum(n)*100, digits = 2))

    ggpubr::ggbarplot(df, x = "sae_outcome", y = "freq", fill = "#1ea5a5", color = "#a5d7d2",
                      xlab = "",
                      ylab = "Percentage",
                      label = paste0(df$freq,"%", "\n(", df$n, " of ", df$total, ")"),
                      lab.size = 3,
                      lab.vjust = -0.2,
                      alpha = 0.5,
                      ggtheme = theme_pubclean(base_size = 10)) %>%
      ggpubr::ggpar(legend = "none", x.text.angle = 30)

  })

  output$causalityplot <- renderPlotly({

    df <- ls.sae() %>%
      group_by(sae_causality) %>%
      summarise(n = n()) %>%
      mutate(total = sum(n),
             freq = round(n/sum(n)*100, digits = 2))

    ggpubr::ggbarplot(df, x = "sae_causality", y = "freq", fill = "#1ea5a5", color = "#a5d7d2",
                      xlab = "",
                      ylab = "Percentage",
                      label = paste0(df$freq,"%", "\n(", df$n, " of ", df$total, ")"),
                      lab.size = 3,
                      lab.vjust = -0.2,
                      alpha = 0.5,
                      ggtheme = theme_pubclean(base_size = 10)) %>%
      ggpubr::ggpar(legend = "none", x.text.angle = 30)

  })


  # output$saetable <- renderDataTable({
  #   
  #   df <- data.sae() %>%
  #     dplyr::select( "Patient ID" = pat_id, "Center" = centre.short, "Description" = sae_discription,
  #                    "Date of sae" = sae_onset_date.date, "Ongoing" = sae_ongoing, "Severity" = sae_severity, "Causality" = sae_drug_relation)
  #   
  # }, escape = FALSE)
  
  
  
}

## To be copied in the UI
# mod_safetymgm_ui("safetymgm_ui_1")

## To be copied in the server
# callModule(mod_safetymgm_server, "safetymgm_ui_1")

