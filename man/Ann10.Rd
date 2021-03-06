% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ANN.R
\name{z.Ann10}
\alias{z.Ann10}
\title{Artificial Neural Network correlation}
\usage{
z.Ann10(pres.pr, temp.pr, tolerance, verbose)
}
\arguments{
\item{pres.pr}{pseudo-reduced pressure}

\item{temp.pr}{pseudo-reduced temperature}

\item{tolerance}{controls the iteration accuracy}

\item{verbose}{print internal}
}
\description{
Artificial Neural Network correlation
}
\examples{
# calculate a single z point
ppr <- 1.5
tpr <- 2.0
z.calc <- z.Ann10(pres.pr = ppr, temp.pr = tpr)
## calculate z for multiple Ppr and Tpr
ppr <- c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5)
tpr <- c(1.05, 1.1, 1.7, 2)
z.calc <- z.Ann10(ppr, tpr)
}
