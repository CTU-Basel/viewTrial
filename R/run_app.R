#' Run the shiny app
#'
#' @return
#' @export
#'
#' @examples
#' # shinytemplate::run_app()
run_app <- function(){
  ## make resources available globally from non standard location
  # addResourcePath("www", system.file("www", package = "secuTrialRshiny"))
  shiny_app <- shiny::shinyApp(ui = app_ui, server = app_server)
  return(shiny_app)
}
