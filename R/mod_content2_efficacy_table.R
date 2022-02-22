#' content2_efficacy_table UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
mod_content2_efficacy_table_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$h2("2. Efficacy results at Week 12"),

    gt_output(ns("table"))

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
      tbl <- generate_efficacy_table(r6$trial_name)

      output$table <- render_gt({
        tbl %>%
          gt() %>%
          cols_width(
            measure ~ px(100),
            drug_name ~ px(200)
          ) %>%
          fmt_markdown(columns = c("drug_name", "baseline_value",
                                   "diff_baseline", "diff_placebo")) %>%
          cols_label(
            measure = "",
            drug_name = "Treatment Groups",
            baseline_value = "Mean Baseline Value(SD)",
            diff_baseline = "Mean Change from Baseline",
            diff_placebo = "Difference from Placebo"
          )
      })
    })

  })
}

## To be copied in the UI
# mod_content2_efficacy_table_ui("content2_efficacy_table_1")

## To be copied in the server
# mod_content2_efficacy_table_server("content2_efficacy_table_1")
