#' Alcohol and risk of CVD
#'
#' A small synthetic cohort recording alcohol consumption
#' at baseline and cardiovascular disease over follow-up
#'
#' @format A data frame with 1000 rows and five columns:
#' \describe{
#'    \item{sex}{sex of participant (0 = male, 1 = female)}
#'    \item{alc}{average daily alcohol intake as g/d}
#'    \item{alc.binary}{acohol intake as binary variable
#'           (0 = none, 1 = any)}
#'    \item{time}{follow-up time in days}
#'    \item{cvd}{Indicator of cardiovascular disease at
#'           end of follow-up (0 = no CVD, 1 = CVD)}
#' }
#' @references A synthetic data set, generated and graciously
#'             shared by Arvid Sjölander
"cohort"

#' A small longitudinal cohort
#'
#' A minimal cohort with follow-up time for testing
#'
#' @format A data frame with six rows and three columns:
#' \describe{
#'   \item{time}{follow-up time}
#'   \item{event}{status at end of follow-up (0 = no event, 1 = event)}
#'   \item{sex}{sex of subjects (f = female, m = male)}
#' }
#' @references Hand-crafted data
"cohort_test"
