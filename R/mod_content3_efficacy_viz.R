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
    tags$h2("3. Co-Primary Efficacy Endpoints"),

    div(class = "flex",
      plotOutput(ns("plot1")),
      plotOutput(ns("plot2"))
    )
  )
}

#' content3_efficacy_viz Server Functions
#'
#' @noRd
#' @import ggplot2
mod_content3_efficacy_viz_server <- function(id, r6){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(watch("r6_update"), {
      req(!is.null(r6$drug_name))

      output$plot1 <- renderPlot({
        ess_viz(r6$trial_name)
      })

      output$plot2 <- renderPlot({
        mwt_viz(r6$trial_name)
      })

    })
  })
}

## To be copied in the UI
# mod_content3_efficacy_viz_ui("content3_efficacy_viz_1")

## To be copied in the server
# mod_content3_efficacy_viz_server("content3_efficacy_viz_1")
