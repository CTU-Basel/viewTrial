#' Retention
#'
#' In development
#' @rdname mod_retention
#' @param id standard shiny id argument
#' @param label standard shiny label argument

mod_retention_ui <- function(id, label){
  ns <- NS(id)
  tabItem(tabName = label,
          
          fluidRow(
            ## TODO: Choose styling option for value boxes
            tags$style(".small-box.bg-yellow { background-color: #a5d7d2 !important; color: #333333 !important; }"),
            ## TODO: Enter ids for value boxes. Ids should correspond to output in server function below.
            valueBoxOutput(ns("nopriActive"), width = 6),
            valueBoxOutput(ns("nopriEnd"), width = 6)
          ),
          
          fluidRow(
            tabBox(
              width = 12,
              title = "",
              id = "nopri_end", height = "850px",
              selected = "Proportion of patients who have ended the study",
              tabPanel("Proportion of patients who have ended the study", plotOutput(ns('endplot'), height = "750"))
            )
          )
          
  )
}

#' @rdname mod_retention
#' @param input standard shiny input argument
#' @param output standard shiny output argument
#' @param session standard shiny session argument
#' @param data data for use in calculations
mod_retention_server <- function(input, output, session, data){
  
  ns <- session$ns
  
  ## No active (before 24M)
  output$nopriActive <- renderValueBox({
    
    ## TODO: Input value
    value <- data() %>% filter(ended.study == FALSE & Visit == "Baseline") %>% nrow()
    
    ## TODO: Input subtitle
    valueBox(value = value, subtitle = "Retained in the study", color = "yellow")
  })
  
  ## No end (before 24M)
  output$nopriEnd <- renderValueBox({
    
    no <- data() %>% filter(ended.study == TRUE & Visit == "Baseline") %>% nrow()
    valueBox(value = no, subtitle = "Premature end of study", color = "red")
  })
  
  ## Plot of proportion of randomized patients in main study (before 24M) who ended study
  output$endplot <- renderPlot({
    
    df <- data()  %>%
      filter(Visit == "Baseline") %>% 
      select(centre.short, "Randomized" = total.randomized, "Ended" = total.ended) %>%
      distinct(centre.short, .keep_all = TRUE) %>%
      mutate(perc = round(Ended/Randomized*100, digits = 2)) %>%
      gather(Randomized:Ended, key = "cat", value = "n") %>%
      mutate(label = case_when(cat == "Ended" & n > 0 ~ paste0("n = ", n, "\n(",perc,"%)"),
                               cat == "Randomized" ~ paste0("All = ",n),
                               TRUE ~ ""))
    
    ggpubr::ggbarplot(df, x = "centre.short", y = "n", fill = "cat",
                      xlab = "Center",
                      ylab = "n",
                      width = 1.4,
                      lab.size = 4,
                      label = df$label,
                      palette = c("Randomized" = "#a5d7d2","Ended" =  "#1ea5a5"),
                      alpha = 0.5,
                      ggtheme = theme_pubclean(base_size = 16),
                      position = position_dodge(width = 0)) %>%
      ggpubr::ggpar(legend = c("top"),
                    x.text.angle = 30,
                    legend.title = "Category")
    
  })
  
  
}
