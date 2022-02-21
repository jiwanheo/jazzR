#' content1_study_design UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shinipsum random_table
mod_content1_study_design_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h2("1. Trial design & study demographics"),

    tableOutput(ns("table"))
  )
}

#' content1_study_design Server Functions
#'
#' @noRd
mod_content1_study_design_server <- function(id, r6){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(watch("r6_update"), {
      req(!is.null(r6$drug_name))

      output$table <- renderTable({
        random_table(ncol = 5, nrow = 1)
      })
    })
  })
}

## To be copied in the UI
# mod_content1_study_design_ui("content1_study_design_1")

## To be copied in the server
# mod_content1_study_design_server("content1_study_design_1")
