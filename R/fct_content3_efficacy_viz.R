#' Create Efficacy Viz
#'
#' This function returns a ggplot object
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#' @rdname efficay_viz
#' @import ggplot2
#'
ess_viz <- function(study_id, db_path = system.file("extdata/jazz.sqlite", package = "jazzR")) {

  con <- dbConnect(SQLite(), db_path)

  ess <- dbGetQuery(con, "SELECT * FROM ess_table;")

  subject_drug <- dbGetQuery(con, sprintf(
    "SELECT distinct t.trial_subject_id, d.drug_name
   FROM trial_subject_table t

   INNER JOIN drug_table d
   ON t.drug_id = d.drug_id
   WHERE t.study_id = '%s';",
   study_id)
  )
  dbDisconnect(con)

  tbl <- subject_drug %>%
    inner_join(ess, "trial_subject_id") %>%
    group_by(drug_name, week) %>%
    summarize(m_ess = round(mean(ess_score), digits = 2),
              sd = round(sd(ess_score), digits = 2),
              .groups = "drop") %>%
    mutate(lo = m_ess - sd,
           hi = m_ess + sd)

  tbl %>%
    ggplot() +
    geom_point(aes(x = week, y = m_ess, color = drug_name)) +
    geom_line(aes(x = week, y = m_ess, color = drug_name)) +
    geom_errorbar(aes(x = week, ymin = lo, ymax = hi, color = drug_name)) +
    theme_light() +
    theme(
      legend.position = "bottom"
    ) +
    labs(title = "ESS: Change from Baseline by Study Visit",
         x = "Week",
         y = "ESS Score",
         color = "")
}

#' Create Efficacy Viz
#'
#' This function returns a ggplot object
#'
#' @param study_id study_id to look up on study_table
#' @param db_path sqlite path
#' @rdname efficay_viz
#' @import ggplot2
#'
mwt_viz <- function(study_id, db_path = system.file("extdata/jazz.sqlite", package = "jazzR")) {
  con <- dbConnect(SQLite(), db_path)

  mwt <- dbGetQuery(con, "SELECT * FROM mwt_table;")

  subject_drug <- dbGetQuery(con, sprintf(
    "SELECT distinct t.trial_subject_id, d.drug_name
   FROM trial_subject_table t

   INNER JOIN drug_table d
   ON t.drug_id = d.drug_id
   WHERE t.study_id = '%s';",
   study_id)
  )

  dbDisconnect(con)

  tbl <- subject_drug %>%
    inner_join(mwt, "trial_subject_id") %>%
    group_by(drug_name, week) %>%
    summarize(sd = round(sd(sleep_latency), digits = 2),
              sleep_latency = round(mean(sleep_latency), digits = 2),
              .groups = "drop") %>%
    mutate(lo = sleep_latency - sd,
           hi = sleep_latency + sd)

  tbl %>%
    ggplot() +
    geom_point(aes(x = week, y = sleep_latency, color = drug_name)) +
    geom_line(aes(x = week, y = sleep_latency, color = drug_name)) +
    geom_errorbar(aes(x = week, ymin = lo, ymax = hi, color = drug_name)) +
    theme_light() +
    theme(
      legend.position = "bottom"
    ) +
    labs(title = "MWT: Change from Baseline by Study Visit",
         x = "Week",
         y = "Mean Sleep Latency",
         color = "")
}
