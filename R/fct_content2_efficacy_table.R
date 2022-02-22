# MWT----

#' Summarize Baseline Mean Sleep Latency
#'
#' Given a study_id, this function returns mean sleep latency and
#' standard deviation by drug. Returns a list of two dataframes, 1 with
#' re-usable values, 1 with gt-format.
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#'
#' @importFrom stats sd
get_baseline_mwt <- function(study_id, db_path) {

  con <- dbConnect(SQLite(), db_path)

  baseline_person <-
    dbGetQuery(con, "SELECT trial_subject_id, AVG(sleep_latency) mean_sleep_latency
                     FROM mwt_table
                     WHERE week = 0
                     GROUP BY trial_subject_id;")

  subject_drug <- dbGetQuery(con, sprintf(
    "SELECT distinct t.trial_subject_id, d.drug_name
     FROM trial_subject_table t

     INNER JOIN drug_table d
     ON t.drug_id = d.drug_id
     WHERE t.study_id = '%s';",
    study_id)
  )

  dbDisconnect(con)

  baseline_facts <- subject_drug %>%
    inner_join(baseline_person, "trial_subject_id") %>%
    group_by(drug_name) %>%
    summarize(msl = round(mean(mean_sleep_latency), digits = 2), # mean sleep latency
              sd = round(sd(mean_sleep_latency), digits = 2), # standard deviation
              .groups = "drop")

  baseline_output <- baseline_facts %>%
    unite("baseline_value", c(msl, sd), sep = " (") %>%
    mutate(baseline_value = paste0(baseline_value, ")")) %>%
    summarize(baseline_value = paste0(baseline_value, collapse = "<br>"))

  list(facts = baseline_facts, output = baseline_output)
}

#' Summarize Mean Sleep Latency Change from Baseline and Placebo
#'
#' Given a study_id, this function returns the change in mean sleep latency
#' between baseline and week 12, as well as week 12 results differences between
#' drugs and Placebo
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path

get_change_baseline_placebo_mwt <- function(study_id, db_path) {
  con <- dbConnect(SQLite(), db_path)

  week12_person <-
    dbGetQuery(con, "SELECT trial_subject_id, AVG(sleep_latency) mean_sleep_latency
                   FROM mwt_table
                   WHERE week = 12
                   GROUP BY trial_subject_id;")

  subject_drug <- dbGetQuery(con, sprintf(
    "SELECT distinct t.trial_subject_id, d.drug_name
     FROM trial_subject_table t

     INNER JOIN drug_table d
     ON t.drug_id = d.drug_id
     WHERE t.study_id = '%s';",
    study_id)
  )

  week12_facts <- subject_drug %>%
    inner_join(week12_person, "trial_subject_id") %>%
    group_by(drug_name) %>%
    summarize(msl_end = round(mean(mean_sleep_latency), digits = 2),
              sd_end = round(sd(mean_sleep_latency), digits = 2),
              .groups = "drop")

  dbDisconnect(con)

  # Change from Baseline

  baseline <- get_baseline_mwt(study_id, db_path)[[1]]

  change_baseline_tbl <- baseline %>%
    inner_join(week12_facts, "drug_name") %>%
    mutate(diff_baseline = round(msl_end - msl, digits = 2)) %>%
    select(drug_name, diff_baseline)

  # Change from Placebo

  placebo <- change_baseline_tbl[change_baseline_tbl$drug_name == "Placebo", "diff_baseline"][[1]]

  change_baseline_placebo_output <- change_baseline_tbl %>%
    mutate(diff_placebo = round(diff_baseline - placebo, digits = 2)) %>%
    summarize(diff_baseline = paste0(diff_baseline, collapse = "<br>"),
              diff_placebo = paste0(diff_placebo, collapse = "<br>"))

  change_baseline_placebo_output
}

# ESS----
#' Summarize Baseline Mean ESS
#'
#' Given a study_id, this function returns mean ESS and
#' standard deviation by drug. Returns a list of two dataframes, 1 with
#' re-usable values, 1 with gt-format.
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#'
get_baseline_ess <- function(study_id, db_path) {

  con <- dbConnect(SQLite(), db_path)

  baseline_person <-
    dbGetQuery(con, "SELECT trial_subject_id, AVG(ess_score) mean_ess
                     FROM ess_table
                     WHERE week = 0
                     GROUP BY trial_subject_id;")

  subject_drug <- dbGetQuery(con, sprintf(
    "SELECT distinct t.trial_subject_id, d.drug_name
     FROM trial_subject_table t

     INNER JOIN drug_table d
     ON t.drug_id = d.drug_id
     WHERE t.study_id = '%s';",
    study_id)
  )

  dbDisconnect(con)

  baseline_facts <- subject_drug %>%
    inner_join(baseline_person, "trial_subject_id") %>%
    group_by(drug_name) %>%
    summarize(m_ess = round(mean(mean_ess), digits = 2), #mean ess
              sd = round(sd(mean_ess), digits = 2),
              .groups = "drop")

  baseline_output <- baseline_facts %>%
    unite("baseline_value", c(m_ess, sd), sep = " (") %>%
    mutate(baseline_value = paste0(baseline_value, ")")) %>%
    summarize(baseline_value = paste0(baseline_value, collapse = "<br>"))

  list(facts = baseline_facts, output = baseline_output)
}

#' Summarize Mean ESS Change from Baseline and Placebo
#'
#' Given a study_id, this function returns the change in mean ESS between
#' baseline and week 12, as well as week 12 results differences between
#' drugs and Placebo
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path

get_change_baseline_placebo_ess <- function(study_id, db_path) {
  con <- dbConnect(SQLite(), db_path)

  week12_person <-
    dbGetQuery(con, "SELECT trial_subject_id, AVG(ess_score) mean_ess
                   FROM ess_table
                   WHERE week = 12
                   GROUP BY trial_subject_id;")

  subject_drug <- dbGetQuery(con, sprintf(
    "SELECT distinct t.trial_subject_id, d.drug_name
     FROM trial_subject_table t

     INNER JOIN drug_table d
     ON t.drug_id = d.drug_id
     WHERE t.study_id = '%s';",
    study_id)
  )

  week12_facts <- subject_drug %>%
    inner_join(week12_person, "trial_subject_id") %>%
    group_by(drug_name) %>%
    summarize(m_ess_end = round(mean(mean_ess), digits = 2),
              sd_end = round(sd(mean_ess), digits = 2),
              .groups = "drop")

  dbDisconnect(con)

  # Change from Baseline

  baseline <- get_baseline_ess(study_id, db_path)[[1]]

  change_baseline_tbl <- baseline %>%
    inner_join(week12_facts, "drug_name") %>%
    mutate(diff_baseline = round(m_ess_end - m_ess, digits = 2)) %>%
    select(drug_name, diff_baseline)

  # Change from Placebo

  placebo <- change_baseline_tbl[change_baseline_tbl$drug_name == "Placebo", "diff_baseline"][[1]]

  change_baseline_placebo_output <- change_baseline_tbl %>%
    mutate(diff_placebo = round(diff_baseline - placebo, digits = 2)) %>%
    summarize(diff_baseline = paste0(diff_baseline, collapse = "<br>"),
              diff_placebo = paste0(diff_placebo, collapse = "<br>"))

  change_baseline_placebo_output
}

# Summary----

#' Generate gt table of Efficacy Summary
#'
#' This function calls other content2 functions to calculate sub-tables, joins them, and outputs a gt table.
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#'
generate_efficacy_table <- function(study_id, db_path = system.file("extdata/jazz.sqlite", package = "jazzR")) {
  treatment_group <- get_study_subjects(study_id, db_path) %>%
    select(-study_id)

  baseline_mwt <- get_baseline_mwt(study_id, db_path)
  change_baseline_placebo_mwt <- get_change_baseline_placebo_mwt(study_id, db_path)

  mwt <- cbind(
    tibble(measure = "MWT Mean Sleep Latency"),
    treatment_group,
    baseline_mwt$output,
    change_baseline_placebo_mwt
  )

  baseline_ess <- get_baseline_ess(study_id, db_path)
  change_baseline_placebo_ess <- get_change_baseline_placebo_ess(study_id, db_path)

  ess <- cbind(
    tibble(measure = "ESS Total Score"),
    treatment_group,
    baseline_ess$output,
    change_baseline_placebo_ess
  )

  res_tbl <- rbind(mwt, ess)
  res_tbl
}
