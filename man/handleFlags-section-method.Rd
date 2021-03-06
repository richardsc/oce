% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/section.R
\docType{methods}
\name{handleFlags,section-method}
\alias{handleFlags,section-method}
\title{Handle flags in Section Objects}
\usage{
\S4method{handleFlags}{section}(object, flags = list(), actions = list())
}
\arguments{
\item{object}{An object of \code{\link{section-class}}.}

\item{flags}{An optional \code{\link{list}} containing (a)
items with names of entries in the \code{data} slot of \code{object},
or (b) a single unnamed item. In the first case, the attention is
focussed on the named items, while in the second case the 
all the data in the \code{object}'s \code{data} slot are examined.
Each element in the list must be set to an integer or vector of integers,
specifying conditions to be met before actions are to be taken.}

\item{actions}{An optional \code{\link{list}} that contains items with
names that match those in the \code{flags} argument.  If \code{actions}
is not supplied, the default will be to set all values identified by
\code{flags} to \code{NA}; this can also be specified by
specifying \code{actions=list("NA")}. It is also possible to specify 
functions that calculate replacement values. These are provided
with \code{object} as the single argument, and must return a
replacement for the data item in question.}
}
\description{
Data-quality flags are stored in the \code{metadata}
slot of \code{\link{oce-class}} objects in a 
\code{\link{list}} named \code{flags}.
The present function (a generic that has specialized versions
for various data classes) provides a way to
manipulate the core data based on
the data-quality flags. For example, a common operation is to replace suspicious
or erroneous data with \code{NA}.

If \code{metadata$flags} in the object supplied as the first argument
is empty, then that object is returned, unaltered.
Otherwise, \code{handleFlags} analyses the data-quality flags within
the object, in relation to the \code{flags} argument, and interprets
the \code{action} argument to select an action to be applied to mached
data.

Reasonable defaults are used if \code{flags} and \code{actions}
are not supplied (see \sQuote{Details}),
but different schemes are used in different
data archives, so it is risky to rely on these defaults.
It is usually necessary to tailor \code{flags} and \code{actions} 
to the data and the analysis goals.
}
\details{
If \code{flags} and \code{actions} are not provided, the
default is to use WHP (World Hydrographic Program) flags [1], in which the
value 2 indicates good data, and other values indicate either unchecked,
suspicious, or bad data. Any data not flagged as good are set
to \code{NA} in the returned value. Since WHP flag codes run
from 1 to 9, this default is equivalent to
setting \code{flags=list(all=c(1, 3:9))} along with
\code{action=list("NA")}.
}
\section{Implementation status}{
 \code{handleFlags} is a new function as of March 2016,
and it will probably continue to evolve through the rest of 2016.
Users are asked to be patient, and to provide help by
looking at the documentation and telling the developers
whether the planned functioning seems reasonable.
}
\examples{
library(oce)
data(section)
section2 <- handleFlags(section)
par(mfrow=c(2,1))
plotTS(section)
plotTS(section2)

}
\references{
1. \url{https://www.nodc.noaa.gov/woce/woce_v3/wocedata_1/whp/exchange/exchange_format_desc.htm}
}
\seealso{
Other functions that handle data-quality flags: \code{\link{handleFlags,argo-method}},
  \code{\link{handleFlags,ctd-method}},
  \code{\link{handleFlags}}

Other things related to \code{section} data: \code{\link{[[,section-method}},
  \code{\link{[[<-,section-method}},
  \code{\link{as.section}},
  \code{\link{plot,section-method}},
  \code{\link{read.section}}, \code{\link{section-class}},
  \code{\link{sectionAddStation}},
  \code{\link{sectionGrid}}, \code{\link{sectionSmooth}},
  \code{\link{sectionSort}}, \code{\link{section}},
  \code{\link{subset,section-method}},
  \code{\link{summary,section-method}}
}

