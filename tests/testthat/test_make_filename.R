context("Make filename")

test_that("year is a 4 digit integer",
          expect_equal(nchar(year), 4),
          expect_is(year, "numeric"))
