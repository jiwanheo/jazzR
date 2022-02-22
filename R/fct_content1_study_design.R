#' Summarize Drug Usage by subjects
#'
#' Given a study_id, this function returns a count summary of drugs assigned to test subjects.
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#'
#' @importFrom DBI dbConnect dbGetQuery dbDisconnect
#' @importFrom RSQLite SQLite
#' @importFrom dplyr inner_join select group_by summarize arrange
#' @importFrom tidyr unite
#'
get_study_subjects <- function(study_id, db_path) {
  con <- dbConnect(SQLite(), db_path)

  drug_counts <- dbGetQuery(con, sprintf(
    "SELECT
       distinct study_id, drug_id,
       count(*) d_count
     FROM trial_subject_table
     WHERE study_id = '%s'
     GROUP BY drug_id;",
    study_id
  ))

  drug_names <- dbGetQuery(con, "SELECT
                                   distinct drug_id, drug_name
                                 FROM drug_table;")

  dbDisconnect(con)

  study_subjects <- drug_counts %>%
    inner_join(drug_names, "drug_id") %>%
    select(study_id, drug_name, d_count)

  study_subjects %>%
    unite("drug_name", c(drug_name, d_count), sep = " n=") %>%
    arrange(drug_name) %>%
    group_by(study_id) %>%
    summarize(drug_name = paste(drug_name, collapse = "<br>"), .groups = "drop")
}

#' Summarize study subjects age summary
#'
#' Given a study_id, this function returns a min/max/avg summary of age.
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#'
#' @importFrom tibble tibble
#'
get_age_summary <- function(study_id, db_path) {
  con <- dbConnect(SQLite(), db_path)

  mean_age <- dbGetQuery(con, sprintf(
    "SELECT AVG(person_age) mean_age
     FROM person_table
     WHERE person_id IN (
       SELECT distinct person_id
       FROM trial_subject_table
       WHERE study_id = '%s'
     );",
    study_id
  ))

  min_age <- dbGetQuery(con, sprintf(
    "SELECT MIN(person_age) min_age
     FROM person_table
     WHERE person_id IN (
       SELECT distinct person_id
       FROM trial_subject_table
       WHERE study_id = '%s'
     );",
    study_id
  ))

  max_age <- dbGetQuery(con, sprintf(
    "SELECT MAX(person_age) max_age
     FROM person_table
     WHERE person_id IN (
       SELECT distinct person_id
       FROM trial_subject_table
       WHERE study_id = '%s'
     );",
    study_id
  ))

  dbDisconnect(con)

  tibble(
    study_id = "14-002",
    mean_age = paste0(round(mean_age, digits = 1), " years (", min_age, " to ", max_age, ")")
  )
}

#' Summarize study subjects sex summary
#'
#' Given a study_id, this function returns a % summary of sex.
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#'
#' @importFrom dplyr mutate
#'
get_sex_summary <- function(study_id, db_path) {
  con <- dbConnect(SQLite(), db_path)

  sex_count <- dbGetQuery(con, sprintf(
    "SELECT person_sex, count(*) as n
     FROM person_table
     WHERE person_id IN (
                   SELECT distinct person_id
                   FROM trial_subject_table
                   WHERE study_id = '%s'
                 )
     GROUP BY person_sex;",
    study_id
  ))

  dbDisconnect(con)

  sex_count %>%
    mutate(n = paste0(round(n / sum(n), digits = 3) * 100, "%")) %>%
    unite("sex", c(person_sex, n), sep = ": ") %>%
    summarize(sex = paste(sex, collapse = "<br>")) %>%
    mutate(study_id = study_id)
}

#' Generate gt table of patient demographics summary
#'
#' This function calls other content1 functions to calculate sub-tables, joins them, and outputs a gt table.
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#'
generate_study_design_table <- function(study_id, db_path = system.file("extdata/jazz.sqlite", package = "jazzR")) {
  con <- dbConnect(SQLite(), db_path)
  study_description <-dbGetQuery(con, "SELECT study_id, study_design FROM study_table;")
  dbDisconnect(con)

  study_subject_tbl <- get_study_subjects(study_id, db_path)
  age_tbl <- get_age_summary(study_id, db_path)
  sex_tbl <- get_sex_summary(study_id, db_path)

  res_tbl <- study_description %>%
    inner_join(study_subject_tbl, "study_id") %>%
    inner_join(age_tbl, "study_id") %>%
    inner_join(sex_tbl, "study_id")

  res_tbl
}
