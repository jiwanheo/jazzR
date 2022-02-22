test_that("get_study_subjects works", {

  expected_text <- "Placebo n=60<br>SUNOSI 150mg n=60<br>SUNOSI 300mg n=60<br>SUNOSI 75mg n=60"
  output_text <- get_study_subjects("14-002", system.file("extdata/jazz.sqlite", package = "jazzR"))$drug_name[[1]]

  expect_equal(expected_text, output_text)
})

test_that("get_age_summary works", {

  expected_text <- "45.3 years (18 to 70)"
  output_text <- get_age_summary("14-002", system.file("extdata/jazz.sqlite", package = "jazzR"))$mean_age[[1]]

  expect_equal(expected_text, output_text)
})

test_that("get_age_summary works", {

  expected_text <- "F: 51.7%<br>M: 48.3%"
  output_text <- get_sex_summary("14-002", system.file("extdata/jazz.sqlite", package = "jazzR"))$sex[[1]]

  expect_equal(expected_text, output_text)
})
