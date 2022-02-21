#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @noRd
app_server <- function( input, output, session ) {

  r6 <- JazzR6$new()
  init("r6_update")

  mod_general_info_server("general_info_1", r6)
  mod_side_bar_server("side_bar_1", r6)
  mod_content1_study_design_server("content1_study_design_1", r6)
  mod_content2_efficacy_table_server("content2_efficacy_table_1", r6)
  mod_content3_efficacy_viz_server("content3_efficacy_viz_1", r6)
}
