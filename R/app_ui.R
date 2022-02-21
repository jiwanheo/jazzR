#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
#' @import shiny
#' @import shinydashboard
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),

    dashboardPage(
      dashboardHeader(title = "Trial Explorer"),

      dashboardSidebar(sidebarMenu(
        mod_side_bar_ui("side_bar_1")
      )),

      dashboardBody(

        tags$h1("Trial result") %>%
          tagAppendAttributes(class = "text-center"),

        mod_general_info_ui("general_info_1"),
        mod_content1_study_design_ui("content1_study_design_1"),
        mod_content2_efficacy_table_ui("content2_efficacy_table_1"),
        mod_content3_efficacy_viz_ui("content3_efficacy_viz_1")

      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'jazzR'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

