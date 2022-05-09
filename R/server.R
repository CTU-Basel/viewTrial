#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd

app_server <- function(input, output, session) {
  ## Get all module names
  mod <- get_modules()

  ## To get reactive data
  data <- get_data()
  rx.data <- get_reactive_data(input = input, data = data)
  
  callModule(mod_home_server, mod$home)
  callModule(mod_recruitment_server, mod$recruit, data = rx.data$rx_random)
  callModule(mod_retention_server, mod$retention, data = rx.data$rx_random)
  callModule(mod_completeness_server, mod$completeness, data = rx.data$rx_random)
  callModule(mod_consistency_server, mod$consistency, data)
  callModule(mod_timeliness_server, mod$timeliness, data = rx.data$rx_random)
  callModule(mod_queries_server, mod$queries, data = rx.data$rx_random)
  callModule(mod_visits_server, mod$visits, data = rx.data$rx_random)
  callModule(mod_sae_server, mod$sae, data = rx.data$rx_random)


}


