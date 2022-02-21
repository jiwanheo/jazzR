#' side_bar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
mod_side_bar_ui <- function(id){
  ns <- NS(id)
  tagList(
    selectInput(ns("choose_drug"), "Choose drug", c("SUNOSI", "Other drug")),
    selectInput(ns("choose_trial"), "Choose trial", c("14-002", "Other trial")),
    actionButton(ns("generate_outputs"), "Generate outputs!"),
    actionButton(ns("export_outputs"), "Export outputs!"),
    div(
      class = "bottom-image",
      tags$img(src='www/jazz.png', height = '100%', width = '100%')
    )
  )
}

#' side_bar Server Functions
#'
#' @noRd
mod_side_bar_server <- function(id, r6){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$generate_outputs, {
      r6$drug_name <- input$choose_drug
      r6$trial_name <- input$choose_trial

      trigger("r6_update")
    })

  })
}

## To be copied in the UI
# mod_side_bar_ui("side_bar_1")

## To be copied in the server
# mod_side_bar_server("side_bar_1")
