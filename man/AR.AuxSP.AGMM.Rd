% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AR.AuxSP.AGMM.R
\name{AR.AuxSP.AGMM}
\alias{AR.AuxSP.AGMM}
\alias{AR.AuxSP.AGMM.fit}
\title{Fit additive risk model with auxiliary subgroup survival rates using AGMM}
\usage{
AR.AuxSP.AGMM(
  formula,
  data,
  aux,
  na.action = na.omit,
  lambdas = NULL,
  lambdas.num = 10,
  trace.cv = FALSE
)
}
\arguments{
\item{formula}{formula object, with the response on the left of a ~ operator,
and the terms on the right. The response must be a survival object as
returned by the Surv function.}

\item{data}{a data.frame in which to interpret the variables named in the formula.}

\item{aux}{a list that should contain the auxiliary subgroup survival information.
It has three elements:
\code{tstar} auxiliary time point (only 1 is allowed);
\code{phi} auxiliary survival rates;
\code{G} indicator matrix whose one row indicates one group.
Note that we should let length(phi)=nrow(G).}

\item{na.action}{a missing-data filter function.
This is applied to the model.frame after any subset argument has been used.}

\item{lambdas}{user-specified tuning paramters.
default is NULL.}

\item{lambdas.num}{number tuning parameters that will be evaluated at.
default is 10.}
}
\value{
A list \code{out} representing the fit,
which contains the following elements:
\code{coef} for estimated coefficients,
\code{convergence} for the optimizatoin is converged or not.
}
\description{
This is a function used to fit the additive risk model
in the presence of potentially incomparable subgroup survival rates
as auxiliary information based on the GMM framework and penalization.
The method is motivated by Chen et al. (2020).
}
\examples{
## import the data:
data("toydata1")
## prepare the auxiliary information:
gXcut <- function(X){  # group function
rbind(  ( X[,1] >= 0.5 & X[,2] == 0),
        ( X[,1] <  0.5 & X[,2] == 0),
        ( X[,1] >= 0.5 & X[,2] == 1),
        ( X[,1] <  0.5 & X[,2] == 1)
) * 1
}
phi.true <- c(0.646,0.732,0.433,0.491)
tau <- c(0.2,0,0,0)
phi <- phi.true - tau
aux <- list(tstar=0.5,phi=phi,
            G=gXcut(toydata1[,c("X1","X2")]))
## fit the model:
AR.AuxSP.AGMM(Surv(yobs,delta)~X1+X2,data=toydata1,aux=aux,trace.cv=TRUE)

}
\references{
Chen, Z., Ning, J., Shen, Y., and Qin, J. (2020).
Combining primary cohort data with external aggregate information
without assuming comparability.
Biometrics. doi: https://doi.org/10.1111/biom.13356.
}
