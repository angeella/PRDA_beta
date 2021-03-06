########################
####    my tests    ####
########################


#----    my_t_test    ----

#' my_t_test
#'
#' @param x numeric value
#' @param y numeric value
#' @param test_method a character string
#' @param alternative character value
#' @param mu numeric value
#' @param paired logic value
#' @param var.equal logic value
#' @param conf.level numeric value
#' @param ... other options
#'
#' @return list with p.values and Cohen's d estimate
#' @importFrom stats pt sd var
#'
#

alternative_set <- c("two.sided", "greater", "less")

my_t_test <-function(x, y = NULL, test_method, alternative = "two.sided",
                     mu = 0, paired = FALSE, var.equal = FALSE, conf.level = 0.95,
                     ...){
  if (test_method == "one_sample") {
    nx <- length(x)
    df <- nx-1
    mx <- mean(x)
    vx <- var(x)
    stderr <- sqrt(vx/nx)
    tstat <- (mx-mu)/stderr
    estimate <- (mx-mu)/sd(x)
  } else if (test_method == "paired"){
    nx <- length(x)
    df <- nx-1
    mx <- mean(x)
    vx <- var(x)
    stderr <- sqrt(vx/nx)
    tstat <- (mx-mu)/stderr
    estimate <- (nx-2)/(nx-1.25) * mx/sd(x)
  } else if (test_method == "two_samples") {
    nx <- length(x)
    mx <- mean(x)
    vx <- var(x)
    ny <- length(y)
    df <- nx+ny-2
    my <- mean(y)
    vy <- var(y)
    v <- (nx-1)*vx + (ny-1)*vy
    v <- v/df
    stderr <- sqrt(v*(1/nx+1/ny))
    tstat <- (mx - my - mu)/stderr
    estimate <- (1 - (3/((4*df)-1))) * (mx-my)/sqrt(v)
  } else {
    nx <- length(x)
    mx <- mean(x)
    vx <- var(x)
    ny <- length(y)
    my <- mean(y)
    vy <- var(y)
    stderrx_2 <- vx/nx
    stderry_2 <- vy/ny
    stderr <- sqrt(stderrx_2 + stderry_2)
    df <- stderr^4/(stderrx_2^2/(nx-1) + stderry_2^2/(ny-1))
    tstat <- (mx - my - mu)/stderr
    estimate <- (mx-my)/sqrt((vx + vy)/2)
  }
  alternative <- match.arg(tolower(alternative), alternative_set)
  pval <- switch(alternative,
               "two.sided" = 2*(pt(abs(tstat), df, lower.tail=FALSE)),
               "greater" = pt(tstat, df, lower.tail=FALSE),
               "less" = 1-pt(tstat, df, lower.tail=FALSE))

  rval <- list(p.value = pval,
               estimate = estimate)
  return(rval)
}

#----    my_pearson_cor    ----

# my_pearson_cor <- function(x, y = NULL){
#     .Call(C_my_cor, x, y, 4, FALSE)
# }
# C_my_cor=get("C_cor", asNamespace("stats"))

#----    my_cor_test    ----

#' Title
#'
#' @param x numeric vector
#' @param y numeric vector
#' @param alternative character value
#' @param ... other options
#'
#' @return list with p.values and correlation estimate
#'
#' @importFrom stats cor
#'
my_cor_test <-function(x, y, alternative = "two.sided",...){
  n <- length(x)
  r <- cor(x, y)
  df <- n - 2L
  tstat <- sqrt(df) * r / sqrt(1 - r^2)

  alternative <- match.arg(tolower(alternative), alternative_set)
  pval <- switch(alternative,
                 "two.sided" = 2*(pt(abs(tstat), df, lower.tail=FALSE)),
                 "greater" = pt(tstat, df, lower.tail=FALSE),
                 "less" = 1-pt(tstat, df, lower.tail=FALSE))
  rval <- list(p.value = pval,
                 estimate = r)

  return(rval)
  }
#----
