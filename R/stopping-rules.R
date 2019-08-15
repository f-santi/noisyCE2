
#' Geweke's test stopping rule
#' 
#' `geweke` tests the convergence of `x` through the Geweke's test.
#'
#' @param x `numeric` vector of last \eqn{\gamma_n} values, as selected by the
#'   function passed to [noisyCE2()] through the argument `stopwindow`.
#' @param frac1,frac2 fraction arguments of the Geweke's test according to
#'   [coda::geweke.diag()].
#' @param pvalue threshold of the \eqn{p}-value which triggers the stop of the
#'   algorithm.
#'
#' @return
#' A `numeric` indicating whether the algorithm has converged:
#' \item{0}{the algorithm has converged.}
#' \item{1}{the algorithm has not converged.}
#'
#' @family stopping rules
#'
#' @export
geweke <- function(x, frac1 = 0.3, frac2 = 0.4, pvalue = 0.05) {
  x %>%
    coda::as.mcmc() %>%
    coda::geweke.diag(frac1 = frac1, frac2 = frac2) %>%
    use_series('z') %>%
    abs %>%
    pnorm(lower.tail = FALSE) %>%
    is_greater_than(pvalue) %>%
    not %>%
    as.numeric -> out
    
  attr(out, 'convMess') <- 'converged'
  if(out != 0) {
  	attr(out, 'convMess') <- 'not converged'
  }
  
  return(out)
}



#' Time series change stopping rule
#' 
#' Deterministic stopping rule based on the last change in the value of
#' \eqn{\gamma_n}. Changes smaller than `tol`, or relative changes
#' smaller than `reltol` stop the algorithm. This criterion is suitable
#' only in case of deterministic objective functions.
#'
#' @inheritParams geweke
#' @param reltol relative changes smaller than `tol` stop the algorithm.
#' @param tol changes smaller than `tol` stop the algorithm.
#'
#' @inherit geweke return
#'
#' @family stopping rules
#'
#' @export
ts_change <- function(x, reltol = 1e-4, tol = 1e-12) {
  out <- 1
  
  if (length(x) > 1) {
    x %<>% tail(n = 2)
    dx <- abs(diff(x))
    rdx <- min(dx / abs(x[1]), reltol + 1, na.rm = TRUE)
    if ((dx < tol) | (rdx < reltol)) { out <- 0 }
  }
    
  attr(out, 'convMess') <- 'converged'
  if(out != 0) {
  	attr(out, 'convMess') %<>% paste('not', .)
  }
  
  return(out)
}


