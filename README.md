
<!-- README.md is generated from README.Rmd. Please edit that file -->

# viewTrial

`viewTrial` provides a template R shiny web application that can be used for centralized monitoring in clinical trials and research. 

[![](https://img.shields.io/badge/DOI-10.1186/s12874--023--01902--y-blue.svg)](https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-023-01902-y)

## To use the template
You could clone this repository to your local machine to copy the template code. 

## Structure of the app

The app has been developed in a modular fashion as an R-package in which each module represents a tab in the sidemenu. 

### List of modules

The tabs are categorised under two major sections, "Performance measures" and "Study management". 

#### Performance measures

-   **Recruitment** `mod_recruitment` provides a recruitment plot
    together with two information boxes.

-   **Retention** `mod_retention` details loss to follow up.

-   **Data quality**

    -   **Completeness** `mod_completeness` provides an example of how
        data completeness might be shown
    -   **Timeliness** `mod_timeliness` provides an example of how time
        between events and their entry into the database might be shown
    -   **Queries** `mod_queries` provides an example of how queries
        might be shown

#### Study management

Aspects of study management can also be depicted via Shiny.

-   **Follow-up visits** `mod_fup` provides an example of how tracking
    of participant progress through a trial might be shown

-   **Safety management**

    -   **Serious adverse events** `mod_sae` counts of SAEs

## Extending the app

For example, let's add a module called "Home" to the app. 

1. Copy and rename the file mod_skeleton.R. 

```r
file.copy("R/mod_skeleton.R", "R/mod_home.R")
```

2. Adapt the file "R/mod_home.R" by renaming the UI and server functions and adding content.

3. Create a module alias by adding the line `home = "mod_home",` to R/get_modules.R. 

4. Add the line `menuItem("Home", tabName = mod$home, icon = icon("home")),` to R/ui.R within sidebarMenu().                                          Icons of choice can be selected from https://fontawesome.com/icons and https://getbootstrap.com/docs/3.3/components/#glyphicons.

5. Add the line `mod_home_ui(mod$home, label = mod$home),` to R/ui.R within dashboardBody().

6. Add the line `callModule(mod_home_server, mod$home)` to R/server.R within app_server().


