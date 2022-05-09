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

  )
}

#' Server Function
#' @rdname

mod_home_server <- function(input, output, session){

  ns <- session$ns

}



