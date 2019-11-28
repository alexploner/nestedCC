## code to prepare `cohort_test` dataset goes here

cohort_test = data.frame(time  = c(1, 2, 3, 4, 5, 6),
                         event = c(0, 1, 0, 1, 0, 1),
                         sex   = c("f", "f", "m", "m", "m", "f" ))

usethis::use_data(cohort_test)
