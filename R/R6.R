#' R6 class of drug process
#'
#' R6 object to encapsulate the parameters passing around modules.
#'
#' @importFrom R6 R6Class

JazzR6 <- R6Class(
  "JazzR6",
  public = list(
    #' @field drug_name Name of the drug to be analyzed. This is subject to
    #' change, every time a new drug is entered.
    drug_name = NULL,
    #' @field trial_name Name of the trial to be analyzed. This is subject to
    #' change, every time a new trial is entered.
    trial_name = NULL
  )
)
