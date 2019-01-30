context("Make filename")

test_that("year is a 4 digit integer", {
          expect_equal(nchar(2014), 4)
          expect_is(2014, "numeric")
  })
