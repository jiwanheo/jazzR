#' R6
#'
#' R6 class to help with data processing
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#' @importFrom R6 R6Class

JazzR6 <- R6Class(
  "JazzR6",
  public = list(
    drug_name = NULL,
    trial_name = NULL
  )
)
