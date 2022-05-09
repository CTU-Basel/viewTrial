#' The application User-Interface
#'
#' @import lubridate
#' @import shiny
#' @import shinydashboard
#'
#' @noRd

app_ui <- function() {



    data <- get_data()
    ## Import module label ids
    mod <- get_modules()

    ## List the first level UI elements here
    fluidPage(

      dashboardPage(skin = "blue"

                    ## Header
                    , dashboardHeader(title = paste0("Study as of ",
                                                   data$data.extraction.date
                                                   ), titleWidth = 300)

                    ## Sidebar
                    , dashboardSidebar(

                      tags$head(tags$style(HTML('.logo {
                              background-color: #1ea5a5 !important;

                              }
                              .navbar {
                              background-color: #1ea5a5  !important;

                              }

                              .navbar-custom .navbar-text {
                                color: black;
                              }
                              ')))

                      , sidebarMenu(
                        ## Home
                        menuItem("Home", tabName = mod$home, icon = icon("home"))

                        ## Overview tab
                        , menuItem("Performance measures", startExpanded = TRUE
                                 ## 1st SIDEBAR TAB: Recruitment and retention
                                 , menuItem("Recruitment", tabName = mod$recruit, icon = icon("chart-line"))
                                 , menuItem("Retention", tabName = mod$retention, startExpanded = TRUE, icon = icon("door-open"))
                                 , menuItem("Data quality", startExpanded = TRUE, icon = icon("database")
                                          , menuItem("Completeness", tabName = mod$completeness)
                                          , menuItem("Consistency", tabName = mod$consistency, badgeLabel = "Upcoming", badgeColor = "green")
                                          , menuItem("Timeliness", tabName = mod$timeliness)
                                          , menuItem("Queries", tabName = mod$queries)))
                        , menuItem("Study management", startExpanded = TRUE
                                 ## 1st SIDEBAR TAB: Recruitment and retention
                                 , menuItem("Follow-up visits", tabName = mod$visits, icon = icon("clinic-medical"))
                                 , menuItem("Safety management", startExpanded = TRUE, icon = icon("notes-medical")
                                          , menuItem("Serious adverse events", tabName = mod$sae)))
                        
                        , menuItem("Contacts", tabName = mod$contacts, icon = icon("home"))

                        ## Date range filter
                        , dateRangeInput("period", "Randomization date:"
                                       , start = as.POSIXct("2017-07-01")
                                       , end   = as.POSIXct(today()))
                        ## Center filter
                        , selectInput("center", "Acute center", choices = c("All", "A", "B", "C", "D", "E"), selected = "All")
                        
                        , width = "350")),

                    ## Body
                    dashboardBody(

                      tabItems(

                        ## Recruitment tab
                          mod_home_ui(mod$home, label = mod$home)
                        , mod_recruitment_ui(mod$recruit, label = mod$recruit)
                        , mod_retention_ui(mod$retention, label = mod$retention)
                        , mod_completeness_ui(mod$completeness, label = mod$completeness)
                        , mod_consistency_ui(mod$consistency, label = mod$consistency)
                        , mod_timeliness_ui(mod$timeliness, label = mod$timeliness)
                        , mod_queries_ui(mod$queries, label = mod$queries)
                        , mod_visits_ui(mod$visits, label = mod$visits)
                        , mod_sae_ui(mod$sae, label = mod$sae)
                      )
                    ) ## dashboardBody
      ) ## dashboardPage
    )



}


