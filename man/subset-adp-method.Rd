% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/adp.R
\docType{methods}
\name{subset,adp-method}
\alias{subset,adp-method}
\title{Subset an ADP Object}
\usage{
\S4method{subset}{adp}(x, subset, ...)
}
\arguments{
\item{x}{An \code{adp} object, i.e. one inheriting from \code{\link{adp-class}}.}

\item{subset}{A condition to be applied to the \code{data} portion of
\code{x}.  See \sQuote{Details}.}

\item{...}{Ignored.}
}
\value{
A new \code{\link{adp-class}} object.
}
\description{
Subset an adp (acoustic Doppler profile) object, in a manner that is function
is somewhat analogous to \code{\link{subset.data.frame}}.  Subsetting can be by
\code{time} or \code{distance}, but these may not be combined; use a sequence
of calls to subset by both.
}
\examples{
library(oce)
data(adp)
# First part of time series
plot(subset(adp, time < mean(range(adp[['time']]))))

}
\author{
Dan Kelley
}
\seealso{
Other things related to \code{adp} data: \code{\link{[[,adp-method}},
  \code{\link{[[<-,adp-method}}, \code{\link{adp-class}},
  \code{\link{adp}}, \code{\link{as.adp}},
  \code{\link{beamName}}, \code{\link{beamToXyzAdp}},
  \code{\link{beamToXyzAdv}}, \code{\link{beamToXyz}},
  \code{\link{beamUnspreadAdp}}, \code{\link{binmapAdp}},
  \code{\link{enuToOtherAdp}}, \code{\link{enuToOther}},
  \code{\link{plot,adp-method}},
  \code{\link{read.adp.nortek}},
  \code{\link{read.adp.rdi}},
  \code{\link{read.adp.sontek.serial}},
  \code{\link{read.adp.sontek}}, \code{\link{read.adp}},
  \code{\link{read.aquadoppHR}},
  \code{\link{read.aquadoppProfiler}},
  \code{\link{read.aquadopp}},
  \code{\link{summary,adp-method}}, \code{\link{toEnuAdp}},
  \code{\link{toEnu}}, \code{\link{velocityStatistics}},
  \code{\link{xyzToEnuAdp}}, \code{\link{xyzToEnu}}
}

