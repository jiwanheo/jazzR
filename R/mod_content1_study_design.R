#' content1_study_design UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom gt gt_output
mod_content1_study_design_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h2("1. Trial design & study demographics"),

    gt_output(ns("table"))
  )
}

#' content1_study_design Server Functions
#'
#' @noRd
#' @importFrom gt gt render_gt fmt_markdown cols_width cols_label
mod_content1_study_design_server <- function(id, r6){
  moduleServer( id, function(input, output, session){
    ns <- session$ns



    observeEvent(watch("r6_update"), {
      req(!is.null(r6$drug_name))
      tbl <- generate_study_design_table(r6$trial_name)

      output$table <- render_gt({
        tbl %>%
          gt() %>%
          cols_width(
            study_design ~ px(160)
          ) %>%
          fmt_markdown(columns = c("drug_name", "sex")) %>%
          cols_label(
            study_id = "Study ID",
            study_design = "Study Design",
            drug_name = "Study Subjects (n)",
            mean_age = "Mean age (Range)",
            sex = "Sex"
          )
      })
    })
  })
}

## To be copied in the UI
# mod_content1_study_design_ui("content1_study_design_1")

## To be copied in the server
# mod_content1_study_design_server("content1_study_design_1")
