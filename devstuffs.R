# create news.md
ad <- autonewsmd::autonewsmd$new("Authors-block")
ad$generate()
ad$write(force = TRUE)


# run tests
testthat::test_dir(path = here::here("tests", "testthat"))
