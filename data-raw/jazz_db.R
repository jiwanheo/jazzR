## code to prepare `jazz_db` dataset goes here

library(tibble)
library(dplyr)
library(tidyr)
library(DT)
set.seed(22)

study_table <- tibble(
  study_id = "14-002",
  study_design = "Randomized, double-blind, placebo-controlled, parallel-group study conducted in adults with narcolepsy (with or without cataplexy)",
  n_participants = 240,
  testing_drugs = "SUNOSI 75mg, SUNOSI 150mg, SUNOSI 300mg, Placebo"
)

person_table <- tibble(
  person_id = paste0("person", 1:500),
  person_age = sample(18:70, size = 500, replace = TRUE),
  person_sex = sample(c("M", "F"), size = 500, replace = TRUE)
)

drug_table <- tibble(
  drug_id = paste0("drug", 1:4),
  drug_name = c("SUNOSI 75mg", "SUNOSI 150mg", "SUNOSI 300mg", "Placebo")
)

trial_subject_table <- tibble(
  trial_subject_id = paste0("trial_subject", 1:240),
  study_id = "14-002",
  person_id = person_table[1:240, ]$person_id,
  drug_id = sample(rep(unique(drug_table$drug_id), 60), size = 240)
)

ess_table <- crossing(
  unique(trial_subject_table[, "trial_subject_id"]),
  week = c(0, 1, 4, 8, 12)
) %>%
  mutate(
    ess_score = sample(0:24, size = 1200, replace = TRUE)
  )

pgic_table <- crossing(
  unique(trial_subject_table[, "trial_subject_id"]),
  week = c(0, 12)
) %>%
  mutate(
    pgic_score = sample(1:7, size = 480, replace = TRUE)
  )

mwt_table <- crossing(
  unique(trial_subject_table[, "trial_subject_id"]),
  week = c(0, 1, 4, 12),
  session = c(1, 2, 3, 4, 5)
) %>%
  mutate(
    sleep_latency = sample(1:25, size = 4800, replace = TRUE)
  )

library(DBI)
library(RSQLite)

jazz_db <- dbConnect(SQLite(), "data-raw/jazz.sqlite")

dbWriteTable(jazz_db, "study_table", study_table)
dbWriteTable(jazz_db, "person_table", person_table)
dbWriteTable(jazz_db, "drug_table", drug_table)
dbWriteTable(jazz_db, "trial_subject_table", trial_subject_table)
dbWriteTable(jazz_db, "ess_table", ess_table)
dbWriteTable(jazz_db, "pgic_table", pgic_table)
dbWriteTable(jazz_db, "mwt_table", mwt_table)

# use_data(jazz_db, internal = FALSE, overwrite = TRUE)

dbDisconnect(jazz_db)
