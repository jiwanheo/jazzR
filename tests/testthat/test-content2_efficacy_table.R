test_that("get_baseline_mwt works", {

  expected_text <- "12.98 (2.81)<br>12.59 (2.99)<br>12.89 (3.45)<br>13.08 (3.46)"
  output_text <- get_baseline_mwt("14-002", system.file("extdata/jazz.sqlite", package = "jazzR"))$output$baseline_value[[1]]

  expect_equal(expected_text, output_text)
})

test_that("get_change_baseline_placebo_mwt works", {

  expected_text_baseline <- "-0.01<br>0.15<br>-0.68<br>-0.67"
  expected_text_placebo <- "0<br>0.16<br>-0.67<br>-0.66"

  output <- get_change_baseline_placebo_mwt("14-002", system.file("extdata/jazz.sqlite", package = "jazzR"))

  expect_equal(expected_text_baseline, output$diff_baseline[[1]])
  expect_equal(expected_text_placebo, output$diff_placebo[[1]])
})

test_that("get_baseline_ess works", {

  expected_text <- "13.33 (7.49)<br>11.65 (7.44)<br>12.8 (6.89)<br>12.47 (7.68)"
  output_text <- get_baseline_ess("14-002", system.file("extdata/jazz.sqlite", package = "jazzR"))$output$baseline_value[[1]]

  expect_equal(expected_text, output_text)
})

test_that("get_change_baseline_placebo_ess works", {

  expected_text_baseline <- "-1.05<br>0.27<br>-2.2<br>-1.12"
  expected_text_placebo <- "0<br>1.32<br>-1.15<br>-0.07"

  output <- get_change_baseline_placebo_ess("14-002", system.file("extdata/jazz.sqlite", package = "jazzR"))

  expect_equal(expected_text_baseline, output$diff_baseline[[1]])
  expect_equal(expected_text_placebo, output$diff_placebo[[1]])
})
