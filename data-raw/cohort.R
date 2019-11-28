## code to prepare `cohort` dataset goes here

cohort = read.table("data-raw/cohort.txt", header = TRUE)
usethis::use_data(cohort)
