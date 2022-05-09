#' UI Function
#'
#' @description
#' @rdname
#' @param id,input,output,session,label Internal parameters for {shiny}.
#'
#' @importFrom shiny NS tagList

mod_home_ui <- function(id, label){

  ns <- NS(id)

  tabItem(tabName = label,
          h2("About viewTrial"),
          h4("viewTrial provides a template shiny app and a library of modules that can be adapted for clinical trials and research."),
          ## Logo
          plotOutput("image1")
  )
}

#' Server Function
#' @rdname

mod_home_server <- function(input, output, session){

  ns <- session$ns

  output$image1 <- renderImage({

   file <- "dkf.png"
   list(src = file)
    
  }, deleteFile = FALSE)
  

}



