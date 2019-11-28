#' Generate a nested case-control design
#'
#' Given a data frame with cohort data, this function will
#' return a a randomly sampled nested case-control design
#'
#' @param cohort Data frame with cohort data
#' @param exit Variable in data frame with event/censoring times,
#'             specified as position (integer) or name (character)
#' @param event Integer variable in cohort indicating censoring (0)
#'              or event (>0)
#' @param match Optional vector of variables in cohort that cases
#'              and controls will be matched on
#' @param k Number of controls per case; default 1
#' @param seed Optional seed for random number generation
#'
#' @return A data frame with rows from the input data (possibly
#'         sampled repeatedly) and an extra column `matchSet`
#'         indicating matched sets of cases and controls.
#'
#' @examples
#' ex1 = nestedCC(cohort, exit = "time", event = "cvd", match = "sex", k = 1, seed = 43)
#' str(ex1)
#' head(ex1$data)
#' @export
nestedCC = function(cohort, exit, event, match, k=1, seed)
{
  ## Generate vector with row numbers of cases in cohort,
  ## extract number of cases in data
  ndx_case = which(cohort[, event] == 1)
  ncase = length(ndx_case)

  ## Set up matrix for storing the matched sets of cases
  ## and controls: 2 controls/case, matrix has cases as
  ## columns and case/control row indices as rows
  sets = matrix(NA, nrow = k+1, ncol = ncase)
  ## Save case numbers as first row
  sets[1, ] = ndx_case

  ## Define a matching variable: match can be a vector of
  ## variable names or positions
  ## If not specified, set a dummy variable that always matches
  if (!missing(match)) {
    grp = interaction(cohort[, match])
  } else {
    grp = rep(TRUE, nrow(cohort))
  }

  ## If specified: set the random seed; otherwise set to NA
  if (!missing(seed)) {
    set.seed(seed)
  } else {
    seed = NA
  }

  ## Loop over cases
  for (i in 1:ncase)
  {
    ## Find row numbers of subjects that are still at risk when current case
    ## happens, and have the same sex as the current case
    tmp = which( ( cohort[, exit] > cohort[ndx_case[i], exit, drop =TRUE] ) &
                   ( grp == grp[ndx_case[i]] ) )
    ## I have to deal with the special case of only one eligible
    ## control because the UI for sample is CRAP; see ?sample
    n_match_control = length(tmp)
    nsamp = min(k, n_match_control)
    ## Note: we skip the case where no matching control was found, see below
    if (nsamp > 0) {
      sets[2:(1+nsamp), i] = sample(tmp, size = nsamp)
    }
  }

  ## Calculate number of missing values per column (matched set)
  ## If all control indices are NA, no match was found, and we
  ## dump the case
  n_controls = colSums(!is.na(sets)) - 1
  sets = sets[, n_controls > 0, drop = FALSE]
  ## We can use the same information to define the match indicator
  matchSet = rep(1:ncol(sets), n_controls[n_controls > 0] + 1)

  ## Use the row numbers in matrix sets to extract the rows from
  ## the cohort data, dropping unmatched cells
  match_ndx = as.vector(sets)
  match_ndx = match_ndx[!is.na(match_ndx)]
  ## Join  the sample data and the matched set indicator
  ret = cbind(cohort[match_ndx, ], matchSet = matchSet)

  ## Add some extra information
  list(data = ret, seed = seed, k = k,
       ndx_unmatched    = ndx_case[n_controls == 0],
       ndx_undermatched = ndx_case[n_controls < k & n_controls > 0])
}
