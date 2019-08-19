

#' Linear first-order smoothing rule
#' 
#' Linear smoothing rule
#' \deqn{x_{t+1}:=a\,x_t + (1-a)\,x_{t-1}}
#' for some \eqn{a\in[0,1]}.
#'
#' @param x `numeric` value of the last value of the parameter.
#' @param xt `numeric` vector of past values of the parameter (time series).
#' @param a smoothing parameter \eqn{a}.
#'
#' @return
#' A `numeric` vector of updated parameters.
#'
#' @family smoothing rules
#'
#' @export
smooth_lin <- function(x, xt, a) {
  a * x + (1 - a) * tail(xt, n = 1)
}



#' Decreasing first-order smoothing rule
#' 
#' Decreasing smoothing rule
#' \deqn{x_{t+1}:=a_t\,x_t + (1-a_t)\,x_{t-1}}
#' where
#' \deqn{a_t:= b\,\left(1-\left(1-\frac{1}{t}\right)^q\right)}
#' for some \eqn{0.7\leq b\leq1} and some \eqn{5\leq q\leq10}.
#'
#' @inheritParams smooth_lin
#' @param b smoothing parameter \eqn{b}.
#' @param qu smoothing parameter \eqn{q}.
#'
#' @inherit smooth_lin return
#'
#' @family smoothing rules
#'
#' @export
smooth_dec <- function(x, xt, b, qu) {
  depo <- b * (1 - (1 - 1 / length(xt))^qu)
  smooth_lin(x, xt, depo)
}


  






