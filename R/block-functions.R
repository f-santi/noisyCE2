
# domain
generate_block <- function(domain, ...) {
  domain %>%
    as.list %>%
    lapply(function(x) {
      if (inherits(x, 'typevar')) {
      	depo <- list(...)
      	if (!is.null(depo[['smooth']])) { x[['smooth']] <- NULL }
      	x %<>%
      	  modifyList(depo) %>%
      	  do.call('type_custom', args = .)
      } else {
      	if (is.character(x)) {
      	  x <- do.call(paste0('type_', x), args = list(...))
      	} else {
      	  stop('domain not defined')
      	}
      }
      
      return(x)
    }) %>%
    structure(class = 'blockvar') %>%
    return
}


# smooth
smooth_block <- function(block, vt, vhist) {
  mapply(
    FUN = function(varj, vtj, vhistj) {
      mapply(
        function(fsm, x, xt) { eval(fsm, list(x = x, xt = xt)) },
      	varj$smooth, as.list(vtj), vhistj
      )
    },
    block, vt, vhist, SIMPLIFY = FALSE
  )
}



# concatenate
concat_block_vect <- function(xhist, xnew) {
  mapply(
    FUN = function(x, y) { as.data.frame(rbind(x, y)) },
    xhist, xnew, SIMPLIFY = FALSE)
}




