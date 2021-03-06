% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stats.R
\name{z.plot.range}
\alias{z.plot.range}
\title{Tile plot of best fit area for a correlation}
\usage{
z.plot.range(correlation = "DAK", stat = "MAPE", pprRange = "lp", ...)
}
\arguments{
\item{correlation}{identifier. Can be "HY", "DAK", "DPR" "N10", "SH"}

\item{stat}{Any of the statistical variables in z.stats:}

\item{pprRange}{low (lp) or high (hp) chart area of the Standing-Katz chart}

\item{...}{any other parameter}
}
\description{
Plot will show blue areas with the lowest errors and redish with very high error
or close to MAPE=25. Pink is much greater than 25.
}
\examples{
# plot Dranchuk-AbouKassem
z.plot.range("DAK")

# plot Beggs-Brill correlation with fine grid on Ppr
z.plot.range("BB", interval = "fine")
}
