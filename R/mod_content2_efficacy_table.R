#' content2_efficacy_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shinipsum random_table
mod_content2_efficacy_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h2("2. Efficacy results at week 12"),

    tableOutput(ns("table"))

  )
}

#' content2_efficacy_table Server Functions
#'
#' @noRd
mod_content2_efficacy_table_server <- function(id, r6){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(watch("r6_update"), {
      req(!is.null(r6$drug_name))

      output$table <- renderTable({
        random_table(ncol = 5, nrow = 3)
      })
    })

  })
}

## To be copied in the UI
# mod_content2_efficacy_table_ui("content2_efficacy_table_1")

## To be copied in the server
# mod_content2_efficacy_table_server("content2_efficacy_table_1")
