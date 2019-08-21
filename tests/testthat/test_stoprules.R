library(testthat)
library(noisyCE2)



test_that('ts_change works for tol argument', {
  expect_identical(as.numeric(ts_change(rnorm(1))), 1)
  expect_identical(as.numeric(ts_change(c( 100,  104), tol = 3)), 1)
  expect_identical(as.numeric(ts_change(c(-100, -104), tol = 3)), 1)
  expect_identical(as.numeric(ts_change(c( 100,  103), tol = 3)), 1)
  expect_identical(as.numeric(ts_change(c( 100, -103), tol = 3)), 1)
  expect_identical(as.numeric(ts_change(c( 100,  102), tol = 3)), 0)
  expect_identical(as.numeric(ts_change(c( 100, -102), tol = 3)), 1)
})


test_that('ts_change works for reltol argument', {
  expect_identical(as.numeric(ts_change(rnorm(1))), 1)
  expect_identical(as.numeric(ts_change(c( 100,  104), reltol = 0.03)), 1)
  expect_identical(as.numeric(ts_change(c(-100, -104), reltol = 0.03)), 1)
  expect_identical(as.numeric(ts_change(c( 100,  103), reltol = 0.03)), 1)
  expect_identical(as.numeric(ts_change(c( 100, -103), reltol = 0.03)), 1)
  expect_identical(as.numeric(ts_change(c( 100,  102), reltol = 0.03)), 0)
  expect_identical(as.numeric(ts_change(c( 100, -102), reltol = 0.03)), 1)
})


test_that('ts_change works for arguments tol and reltol', {
  expect_identical(as.numeric(ts_change(c(   0,    2), tol = 3)), 0)
  expect_identical(as.numeric(ts_change(c(   0,   -3), tol = 3)), 1)
  expect_identical(as.numeric(ts_change(c( 100,  101), tol = 2, reltol = 0.03)), 0)
  expect_identical(as.numeric(ts_change(c( 100,  102), tol = 2, reltol = 0.03)), 0)
  expect_identical(as.numeric(ts_change(c( 100,  102), tol = 4, reltol = 0.01)), 0)
  expect_identical(as.numeric(ts_change(c( 100,  104), tol = 2, reltol = 0.03)), 1)
})


