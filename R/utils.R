
vmessage<- function(verbose, pri = 1, ...) {
  if (verbose %in% c('v', 'vv', 'vvv')[pri:3]) {
    message(...)
    flush.console()
  }
}



statmob<- function(x, k = 10, f = mean, ...) {
  n <- length(x)
  out <- rep(NA, min(k, n))
  if (n >= k) {
    lapply(k:n, function(w) f(x[(w-k+1):w], ...)) %>%
      unlist %>%
      c(out[-1], .) ->out
  }
  out
}



cumstat<- function(x, f, ...) {
  lapply(seq_along(x), function(j) f(x[1:j], ...)) %>%
    unlist %>%
    return()
}


vnorm <- function(x, p = 1) {
  if(p == Inf) {
  	x %>% abs %>% max -> out
  } else {
  	x %>% { sum(abs(.)^p)^(1 / p) } -> out
  }
  out
}



