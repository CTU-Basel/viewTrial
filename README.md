
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shinytemplate/template\_shiny

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

`template_shiny` provides a template shiny app, and a library of
modules, that can be used for clinical trials and research. When
installed in R, the package is then called `shinytemplate`
(`template_shiny` is not a valid R package name).

## How to use this package in your own application

The code in this repository can be used as the basis for an app. Copy
the code to your computer using whichever approach you like (e.g. clone
this repository to your computer and push it into a new repository of
your own - [info
here](https://zhannina.github.io/Git-create-from-existing/)). Try out
the different modules on the data already included in the package to
decide which you prefer/need. This is easiest with
`devtools::load_all()` and then `run_app()` to launch the application.
Remove the modules you do not need (commenting out the relevant lines in
`ui.R` and `server.R` may be sufficient). Modify the remaining code to
use your own data.

The application is organised as an R package. Code is stored in the R
folder. We encourage you to also use a package format in your own app.

### List of modules

In some cases we have prepared multiple modules with the same
overarching goal. In a productive setting, we would recommend choosing
one, or combining elements of each. Each module is briefly described
below (additional info on each can be found in the relevant R file).
Bold text is how the modules are currently labelled in the app.

#### Performance measures

Performance measures allow an overview of study progress and data
quality.

-   **Recruitment** `mod_recruitment` provides a recruitment plot
    together with two information boxes.

-   **Recruitment (accrualPlot)** `mod_recruitment2` is as above, but
    using the `accrualPlot` package. It also includes a table of
    recruitment information per site.

-   **Recruitment map** `mod_recruitment_map` shows a leaflet map,
    showing site locations, linked to a recruitment plot (based on
    `accrualPlot`)

-   **Recruitment completion** `mod_recruitment_prediction` shows an
    estimate of that date at which the recruitment target might be
    expected to be achieved (based on `accrualPlot`)

-   **Retention** `mod_retention` details loss to follow up.

-   **Data quality**

    -   **Completeness** `mod_completeness` provides an example of how
        data completeness might be shown
    -   **Consistency** `mod_consistency` provides an example of how
        data consistency might be shown
    -   **Timeliness** `mod_timeliness` provides an example of how time
        between events and their entry into the database might be shown
    -   **Queries** `mod_queries` provides an example of how queries
        might be shown

#### Study management

Aspects of study management can also be depicted via Shiny.

-   **Follow-up visits** `mod_fup` provides an example of how tracking
    of participant progress through a trial might be shown

-   **Flow chart** `mod_flow` provides an example of a study flow chart

-   **Participant characteristics** `mod_characteristics` provides an
    example of depicting participant information (e.g. baseline
    characteristics)

-   **Safety management**

    -   **Serious adverse events** `mod_sae` counts of SAEs
    -   **Adverse events** `mod_ae` counts of AEs
    -   **Annual safety report** `mod_asr` provides a module with an
        example of how the annual safety report can be produced (via the
        `SwissASR` package)

### Extending the app

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


### Using data

***THIS SECTION IS UNDER DEVELOPMENT***

There are a range of methods to use data in your app. Depending on your
setting (database, method of deployment, etc), one or the other might be
more suitable.

#### Data stored on a network drive

E.g. data is regularly exported from a database and stored in a fixed
location Points to consider

-   loading the data multiple times may slow your app down

One possibility is to use a `.onLoad` function to read the data as the
package is loaded into the R session. This has the advantage that the
loading is only done once.

Another option might be a `get_data` function to load the data as the
application loads.

#### Data accessed through an API

E.g. data is stored in a REDCap database.  
Points to consider

-   downloading large amounts of data multiple times will slow your app
    down
-   authentication may be an issue (supply an authentication token?)

Using `.onLoad` would be possible here too, although the token would
need to be embedded into the app somehow (via a system keychain in a
docker container? reading the token from a file on a drive?)

Access tokens could also be used as a form of authentication - the app
would only show data if the token is valid.

#### Data uploaded directly into the app

E.g. an excel file is uploaded into the app.  
Points to consider

-   the app may need to be flexibe enough to use multiple formats,
    changing variable names etc, or incorporate checks that variables
    needed by the app are present and of the correct class.

### Deploying apps

***THIS SECTION IS UNDER DEVELOPMENT***

There are multiple methods to deploy a shiny app. Here are a few
pointers.

#### Deployment via docker/shinyproxy

docker and shinyproxy (which uses docker) requires a server to host the
app, and people to maintain the server and installations.

Points to consider

-   where is the data? see the points above
-   container size. We have experienced issues with large containers.
    Use as few packages as possible. If only using one function from a
    package, consider copying that single function into your
    app-package, rather than the whole package.

Using docker alone, multiple users can connect to the same container.
This is probably OK for apps that are not very resource intensive.
shinyproxy allocates each user their own container. It is a very
flexible system and can manage user access.

Apps can generally be run via `R: package_name::run_app()` in the
dockerfile used to setup the container.

#### Deployment via shinyapps.io

shinyapps.io provides an easy to use system for deploying shiny apps
directly from RStudio. The basic account level is free to use, but allow
only a small number of apps, run time and resources (resulting in
relatively slow app loading).

#### Deployment via RStudio Connect

We have no experience with RStudio Connect, but want to point out that
this is another approach to deploying apps. Apps can also be deployed
directly from RStudio.

## Contributing to this template

If you have a module and want to include it in this package, fork the
repository to your own github account. Clone the repository to your own
computer. Add your module, ensuring that it works with the demo data
(add new data if none currently exists that is suitable for your
module). Commit your changes and push them to your github fork. Make a
pull request (PR) to have your changes incorporated in to the package.
Your changes may be reviewed and modifications requested prior to
merging into the main code.
