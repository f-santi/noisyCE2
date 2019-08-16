
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Cross-Entropy Optimisation of Noisy Functions

## Presentation

The package `noisyCE2` implements the cross-entropy algorithm
(Rubinstein and Kroese, 2004) for the optimisation of unconstrained
deterministic and noisy functions through a highly flexible and
customisable function which allows user to define custom variable
domains, sampling distributions, updating and smoothing rules, and
stopping criteria. Several built-in methods and settings make the
package very easy-to-use under standard optimisation problems.

## Three examples

### Negative paraboloid

The negative 4-dimensional paraboloid can be maximised as follows:

``` r
negparaboloid <- function(x) { -sum((x - (1:4))^2) }

sol <- noisyCE2(negparaboloid, domain = rep('real', 4))
```

### Rosenbrock’s function

The 10-dimensional Rosenbrock’s function can be minimised as follows:

``` r
rosenbrock <- function(x) {
  sum(100 * (tail(x, -1) - head(x, -1)^2)^2 + (head(x, -1) - 1)^2)
}

newvar <- type_real(
  init = c(0, 2),
  smooth = list(
    quote(smooth_lin(x, xt, 1)),
    quote(smooth_dec(x, xt, 0.7, 5))
  )
)

sol <- noisyCE2(
  rosenbrock, domain = rep(list(newvar), 10),
  maximise = FALSE, N = 2000, maxiter = 10000
)
```

### Noisy negative paraboloid

The negative 4-dimensional paraboloid with additive Gaussian noise can
be maximised as follows:

``` r
noisyparaboloid <- function(x) { -sum((x - (1:4))^2) + rnorm(1) }

sol <- noisyCE2(noisyparaboloid, domain = rep('real', 4), stoprule = geweke(x))
```

where the stopping criterion based on the Geweke’s test has been adopted
according to Bee et al. (2017).

## References

Bee M., G. Espa, D. Giuliani, F. Santi (2017) “A cross-entropy approach
to the estimation of generalised linear multilevel models”, *Journal of
Computational and Graphical Statistics*, **26** (3), pp. 695-708.
<https://doi.org/10.1080/10618600.2016.1278003>

Rubinstein, R. Y., and Kroese, D. P. (2004), *The Cross-Entropy Method*,
Springer, New York.
