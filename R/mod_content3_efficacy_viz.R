#' content3_efficacy_viz UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shinipsum random_ggplot
#' @import ggplot2
mod_content3_efficacy_viz_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h2("3. Co-Primary Efficacy endpoints"),

    plotOutput(ns("plot"))
  )
}

#' content3_efficacy_viz Server Functions
#'
#' @noRd
mod_content3_efficacy_viz_server <- function(id, r6){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(watch("r6_update"), {
      req(!is.null(r6$drug_name))

      output$plot <- renderPlot({
        random_ggplot(type = "line")
      })
    })
  })
}

## To be copied in the UI
# mod_content3_efficacy_viz_ui("content3_efficacy_viz_1")

## To be copied in the server
# mod_content3_efficacy_viz_server("content3_efficacy_viz_1")
