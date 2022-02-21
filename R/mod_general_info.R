#' general_info UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom magrittr %>%
#'
mod_general_info_ui <- function(id){
  ns <- NS(id)

  tagList(

    imageOutput(ns("img"), height = "auto"),

    textOutput(ns("drug_name")),
    textOutput(ns("trial_name"))


  )
}

#' general_info Server Functions
#'
#' @noRd
mod_general_info_server <- function(id, r6){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(watch("r6_update"), {

      output$img <- renderImage({
        req(!is.null(r6$drug_name))

        list(src = "inst/app/img/sunosi.jpg",
             contentType = 'image/png',
             width = 170,
             height = 104,
             alt = "Drug Image")
      }, deleteFile = FALSE)

      output$drug_name <- renderText({
        req(!is.null(r6$drug_name))
        paste("Drug name:", r6$drug_name)
      })

      output$trial_name <- renderText({
        req(!is.null(r6$drug_name))
        paste("Trial name:", r6$trial_name)
      })

    })

  })
}

## To be copied in the UI
# mod_general_info_ui("general_info_1")

## To be copied in the server
# mod_general_info_server("general_info_1")
