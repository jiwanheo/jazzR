con <- DBI::dbConnect(RSQLite::SQLite(),
                      system.file("extdata/jazz.sqlite", package = "jazzR"))

test_that("db connection works", {
  expect_s4_class(con, "SQLiteConnection")
  expect_equal(length(DBI::dbListTables(con)), 7)
})

## Study Table----

test_that("Study table has 1 row per study", {
  study_row <- DBI::dbGetQuery(con,
                               "SELECT count(*)
                               FROM study_table
                               WHERE study_id = '14-002'") %>% as.numeric()

  expect_equal(study_row, 1)
})

## Person Table----

test_that("Person table has correct age range", {
  age_range <- DBI::dbGetQuery(con,
                               "SELECT
                                  min(person_age) min_age,
                                  max(person_age) max_age
                                FROM person_table") %>% as.list()

  expect_true(age_range$min_age >= 18)
  expect_true(age_range$max_age <= 70)
})

## Drug Table----

test_that("Drug table mapped id to name correctly", {
  drug <- DBI::dbGetQuery(con,
                          "SELECT drug_name
                           FROM drug_table
                           WHERE drug_id = 'drug1'") %>% as.list()

  expect_equal(drug$drug_name, "SUNOSI 75mg")
})

## Trial Subject Table----

test_that("Trial subject table maps one person to one drug", {
  trial_subjects <- DBI::dbGetQuery(con,
                                    "SELECT distinct d_count
                                     FROM (
                                       SELECT
                                         distinct person_id person,
                                         count(distinct drug_id) d_count
                                       FROM trial_subject_table
                                       GROUP BY person
                                     )") %>% as.list()

  expect_equal(length(trial_subjects$d_count), 1)
  expect_equal(trial_subjects$d_count, 1)
})

test_that("Trial subject table assigned 4 drugs at equal ratio (60 each)", {
  trial_subjects <- DBI::dbGetQuery(con,
                                    "SELECT distinct d_count
                                     FROM (
                                       SELECT
                                         distinct drug_id,
                                         count(*) d_count
                                       FROM trial_subject_table
                                       GROUP BY drug_id
                                     )") %>% as.list()

  expect_equal(trial_subjects$d_count, 60)
})

## ESS Table----

test_that("ESS scores are between 0 and 24", {
  ess_scores <- DBI::dbGetQuery(con,
                                "SELECT
                                   min(ess_score) min_ess,
                                   max(ess_score) max_ess
                                 FROM ess_table") %>% as.list()

  expect_true(ess_scores$min_ess >= 0)
  expect_true(ess_scores$max_ess <= 24)
})

## PGIc Table----

test_that("PGIc scores are between 1 and 7", {

  pgic_scores <- DBI::dbGetQuery(con,
                                 "SELECT
                                    min(pgic_score) min_pgic,
                                    max(pgic_score) max_pgic
                                  FROM pgic_table") %>% as.list()

  expect_true(pgic_scores$min_pgic >= 1)
  expect_true(pgic_scores$max_pgic <= 7)
})

## MWT Table----

test_that("Sleep latency is between 1 and 25 mins", {

  sleep_latency <- DBI::dbGetQuery(con,
                                   "SELECT
                                      min(sleep_latency) min_sleep_latency,
                                      max(sleep_latency) max_sleep_latency
                                    FROM mwt_table") %>% as.list()

  expect_true(sleep_latency$min_sleep_latency >= 1)
  expect_true(sleep_latency$max_sleep_latency <= 25)
})

DBI::dbDisconnect(con)
