
#' Functions for defining the types of variables
#' 
#' All functions permit fully-customised types of variable to be defined.
#' Functions other than `type_custom` already include standard default values
#' which make the definition of standard variable types easier and quicker.
#'
#' @param type label for identifying the type of variable. The name is not
#'   used internally in any case.
#' @param init `numeric` vector of starting values of parameters of the
#'   sampling distribution.
#' @param randomXj function for randomly generating variable values according
#'   to the sampling distribution. The function should take the number of
#'   observations to be generated as a first argument, and the vector of
#'   parameters as a second argument; a vector of random values should be
#'   returned.
#' @param x2v function for updating the parameters of the sampling distribution.
#'   *No smoothing is needed.* The function should take a single argument to be
#'   used for updating the parameters.
#' @param v2x function for obtaining point values of variable from the
#'   parameters of the sampling distribution.
#' @param smooth list of unevaluated expressions of smoothing functions for each
#'   parameter of the sampling distribution.
#' @param ... further arguments to be included into the `typevar` object. In
#'   case of function for predefined types, it is possible to use ellipsis for
#'   overwriting default values (see § Examples).
#'
#' @return
#' An object of class `type` and `typevar`, where `type` is the value of the
#' argument `type` passed to `type_custom`, or predefined lables (if not
#' overwritten) in case of other functions.
#'
#' @examples
#' # Define a new type of real variable where the first parameter of the
#' # sampling distribution is updated through the median (instead of the
#' # mean):
#' type_real(
#'   type = 'real2', 
#'   x2v = function(x) { c(median(x), sd(x)) }
#' )
#'
#' # Define a new type of real variable whith different smoothing
#' # parameters:
#' type_real(
#'   type = 'real3', 
#'   smooth = list(
#'     quote(smooth_lin(x, xt, 0.8)),
#'     quote(smooth_dec(x, xt, 0.99, 15))
#'   )
#' )
#'
#' @name type_variable
#'
#' @export
type_custom <- function(type = 'custom', init = c(0, 10),
  randomXj = function(n, v) { rnorm(n, v[1], v[2]) },
  x2v = function(x) { c(mean(x), sd(x)) }, v2x = function(v) { v[1] },
  smooth = list(quote(smooth_lin(x, xt, 1)), quote(smooth_dec(x, xt, 0.9, 10))), ...) {
  	
  # Set explicit arguments
  list(
    type = type,
    init = init,
    randomXj = randomXj,
    x2v = x2v,
    v2x = v2x
  ) %>%
    # Include user's changes
    modifyList(list(...)) -> out
     
  if (is.null(out[['smooth']])) { out$smooth <- smooth }
  
  # Set classes
  structure(out, class = c(out$type, 'typevar'))
}



#' @rdname type_variable
#' @export
type_real <- function(...) {
  # Set default values
  list(
    type = 'real',
    init = c(0, 10),
    randomXj = function(n, v) { rnorm(n, v[1], v[2]) },
    x2v = function(x) { c(mean(x), sd(x)) },
    v2x = function(v) { v[1] }
  ) %>%
    # Include user's changes
    modifyList(list(...)) -> out
    
  if (is.null(out[['smooth']])) {
  	out$smooth <- list(
      quote(smooth_lin(x, xt, 1)),
      quote(smooth_dec(x, xt, 0.9, 10))
    )
  }
  
  # Set classes
  structure(out, class = c(out$type, 'typevar'))
}



#' @rdname type_variable
#' @export
type_positive <- function(...) {
  # Set default values
  list(
    type = 'positive',
    init = c(0, 10),
    randomXj = function(n, v) { rlnorm(n, v[1], v[2]) },
    x2v = function(x) { log(x) %>% { c(mean(.), sd(.)) } %>% return() },
    v2x = function(v) { exp(v[1] + 0.5 * v[2]^2) }
  ) %>%
    # Include user's changes
    modifyList(list(...)) -> out
    
  if (is.null(out[['smooth']])) {
  	out$smooth <- list(
      quote(smooth_lin(x, xt, 1)),
      quote(smooth_dec(x, xt, 0.9, 10))
    )
  }
  
  # Set classes
  structure(out, class = c(out$type, 'typevar'))}



#' @rdname type_variable
#' @export
type_negative <- function(...) {
  # Set default values
  list(
    type = 'negative',
    init = c(0, 10),
    randomXj = function(n, v) { -rlnorm(n, v[1], v[2]) },
    x2v = function(x) { log(-x) %>% { c(mean(.), sd(.)) } %>% return() },
    v2x = function(v) { -exp(v[1] + 0.5 * v[2]^2) }
  ) %>%
    # Include user's changes
    modifyList(list(...)) -> out
    
  if (is.null(out[['smooth']])) {
  	out$smooth <- list(
      quote(smooth_lin(x, xt, 1)),
      quote(smooth_dec(x, xt, 0.9, 10))
    )
  }
  
  # Set classes
  structure(out, class = c(out$type, 'typevar'))
}


