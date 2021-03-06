% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidem.R
\docType{data}
\name{tidedata}
\alias{tidedata}
\title{Tidal Constituent Information}
\source{
The data come from the \code{tide3.dat} file of the \code{T_TIDE}
package (Pawlowicz et al., 2002), and derive from Appendices provided by
Foreman (1977).  The data are scanned using \file{tests/tide.R} in this
package, which also performs some tests using \code{T_TIDE} values as a
reference.
}
\description{
The \code{tidedata} dataset contains Tide-constituent information that is
use by \code{\link{tidem}} to fit tidal models.  \code{tidedata} is a list
containing
\describe{
\item{\code{const}}{
a list containing vectors
\code{name} (a string with constituent name),
\code{freq} (the frequency, in cycles per hour),
\code{kmpr} (a string naming the comparison constituent, blank if there is none),
\code{ikmpr} (index of comparison constituent, or \code{0} if there is none),
\code{df} (frequency difference between constituent and its
comparison, used in the Rayleigh criterion),
\code{d1} through \code{d6} (the first through sixth Doodson numbers),
\code{semi},
\code{nsat} (number of satellite constituents),
\code{ishallow},
\code{nshallow},
\code{doodsonamp},
and
\code{doodsonspecies}.
}
\item{\code{sat}}{
a list containing vectors
\code{deldood},
\code{phcorr},
\code{amprat},
\code{ilatfac},
and
\code{iconst}.
}
\item{\code{shallow}}{
a list containing vectors
\code{iconst},
\code{coef},
and
\code{iname}.
}
}
Apart from the use of \code{d1} through \code{d6}, the naming and content
follows \code{T_TIDE} (see Pawlowicz et al. 2002), which in turn builds upon
the analysis of Foreman (1977).
}
\author{
Dan Kelley
}
\references{
Foreman, M. G. G., 1977.  Manual for tidal heights analysis and
prediction.  Pacific Marine Science Report 77-10, Institute of Ocean
Sciences, Patricia Bay, Sidney, BC, 58pp.

Pawlowicz, Rich, Bob Beardsley, and Steve Lentz, 2002.  Classical tidal
harmonic analysis including error estimates in MATLAB using \code{T_TIDE}.
Computers and Geosciences, 28, 929-937.
}
\seealso{
Other things related to \code{tidem} data: \code{\link{[[,tidem-method}},
  \code{\link{[[<-,tidem-method}},
  \code{\link{plot,tidem-method}},
  \code{\link{predict.tidem}},
  \code{\link{summary,tidem-method}},
  \code{\link{tidem-class}}, \code{\link{tidemAstron}},
  \code{\link{tidemVuf}}, \code{\link{tidem}}
}

