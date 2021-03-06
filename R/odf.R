#' @title Class to Store ODF data
#' 
#' @description
#' Class for data stored in a format used at Canadian Department of Fisheries
#' and Oceans laboratories. This is somewhat unusual amongst \code{oce}
#' classes, in that it does not map to a particular instrument, but rather to a
#' storage type; in that sense, it is similar to the \code{bremen-class}.
#' 
#' @section Methods:
#' 
#' Consider an ODF object named \code{odf}.
#' 
#' \emph{Accessing metadata.}
#' 
#' Metadata (contained in the S4 slot named \code{metadata}) may be retrieved
#' or set by name, \code{odf[["longitude"]] <- odf[["longitude"]] + 1} corrects
#' a one-degree error.
#' 
#' \emph{Accessing measured data.}
#' 
#' Column data may be accessed by name, e.g. \code{odf[["salinity"]]},
#' \code{odf[["temperature"]]}, \code{odf[["pressure"]]}, etc.  It is up to the
#' user to realize what is in the object.
#' 
#' \emph{Assigning values.}
#' 
#' Items stored in the object may be altered with e.g.  \code{odf[["salinity"]]
#' <- rep(35,10)}.
#' 
#' \emph{Overview of contents.}
#' 
#' The \code{show} method (e.g.  \code{show(odf)}) displays information about
#' the object.
#' @author Dan Kelley
#' @family things related to \code{odf} data
#' @family classes provided by \code{oce}
setClass("odf", contains="oce")

## [1] Anthony W. Isenor and David Kellow, 2011. ODF Format Specification Version 2.0. (A .doc file downloaded from a now-forgotten URL by Dan Kelley, in June 2011.)
##
## [2] An older document is: http://slgo.ca/app-sgdo/en/pdf/docs_reference/Format_ODF.pdf

setMethod(f="initialize",
          signature="odf",
          definition=function(.Object,time,filename="") {
              ## Assign to some columns so they exist if needed later (even if they are NULL)
              .Object@data$time <- if (missing(time)) NULL else time
              .Object@metadata$filename <- filename
              .Object@metadata$deploymentType <- "" # see ctd
              .Object@processingLog$time <- as.POSIXct(Sys.time())
              .Object@processingLog$value <- "create 'odf' object"
              return(.Object)
          })

#' @title Extract Something From an ODF Object
#' @param x A odf object, i.e. one inheriting from \code{\link{odf-class}}.
#' @template sub_subTemplate
#' @family things related to \code{odf} data
setMethod(f="[[",
          signature(x="odf", i="ANY", j="ANY"),
          definition=function(x, i, j, ...) {
              callNextMethod()
          })

#' @title Replace Parts of an ODF Object
#' @param x An \code{odf} object, i.e. inheriting from \code{\link{odf-class}}
#' @template sub_subsetTemplate
#' @family things related to \code{odf} data
setMethod(f="[[<-",
          signature(x="odf", i="ANY", j="ANY"),
          definition=function(x, i, j, value) {
              callNextMethod(x=x, i=i, j=j, value=value)
          })

#' @title Subset an ODF object
#' 
#' @description
#' This function is somewhat analogous to \code{\link{subset.data.frame}}.
#' 
#' @param x a \code{odf} object.
#' @param subset a condition to be applied to the \code{data} portion of
#' \code{x}.  See \sQuote{Details}.
#' @param \dots ignored.
#' @return A new \code{odf} object.
#' @author Dan Kelley
#' @family things related to \code{odf} data
setMethod(f="subset",
          signature="odf",
          definition=function(x, subset, ...) {
              subsetString <- paste(deparse(substitute(subset)), collapse=" ")
              res <- x
              ##dots <- list(...)
              if (missing(subset))
                  stop("must give 'subset'")

              if (missing(subset))
                  stop("must specify a 'subset'")
              keep <- eval(substitute(subset), x@data, parent.frame(2)) # used for $ts and $ma, but $tsSlow gets another
              res <- x
              for (name in names(x@data)) {
                  res@data[[name]] <- x@data[[name]][keep]
              }
              res@processingLog <- processingLogAppend(res@processingLog, paste("subset(x, subset=", subsetString, ")", sep=""))
              res
          })


#' @title Plot an ODF Object
#' 
#' @description
#' Plot data contained within an ODF object,
#' using \code{\link{oce.plot.ts}} to create panels of time-series plots for all
#' the columns contained in the \code{odf} object. This is crude, but \code{odf}
#' objects are usually cast to other types, and those types have more useful
#' plots.
#' 
#' @param x A \code{odf} object, e.g. one inheriting from \code{\link{odf-class}}.
#' @author Dan Kelley
#' @family functions that plot \code{oce} data
#' @family things related to \code{odf} data
setMethod(f="plot",
          signature=signature("odf"),
          definition=function(x) {
              names <- names(x@data)
              n <- length(names)
              par(mfrow=c(n-1, 1))
              for (i in 1:n) {
                   if (names[i] != "time") {
                       oce.plot.ts(x[["time"]], x[[names[i]]],
                                   ylab=names[i], mar=c(2, 3, 0.5, 1), drawTimeRange=FALSE)
                   }
              }
          })


#' @title Summarize an ODF Object
#' 
#' @description
#' Pertinent summary information is presented, including the station name,
#' sampling location, data ranges, etc.
#' 
#' @param object an object of class \code{"odf"}, usually, a result of a call
#' to \code{\link{read.odf}} or \code{\link{read.oce}}.
#' @param \dots further arguments passed to or from other methods.
#' @return A matrix containing statistics of the elements of the \code{data}
#' slot.
#' @author Dan Kelley
#' @family things related to \code{odf} data
setMethod(f="summary",
          signature="odf",
          definition=function(object, ...) {
              cat("ODF Summary\n-----------\n\n")
              showMetadataItem(object, "type",                     "Instrument:          ")
              showMetadataItem(object, "model",                    "Instrument model:    ")
              showMetadataItem(object, "serialNumber",             "Instr. serial no.:   ")
              showMetadataItem(object, "serialNumberTemperature",  "Temp. serial no.:    ")
              showMetadataItem(object, "serialNumberConductivity", "Cond. serial no.:    ")
              showMetadataItem(object, "filename",                 "File source:         ")
              showMetadataItem(object, "hexfilename",              "Orig. hex file:      ")
              showMetadataItem(object, "institute",                "Institute:           ")
              showMetadataItem(object, "scientist",                "Chief scientist:     ")
              showMetadataItem(object, "date",                     "Date:                ", isdate=TRUE)
              showMetadataItem(object, "startTime",                "Start time:          ", isdate=TRUE)
              showMetadataItem(object, "systemUploadTime",         "System upload time:  ", isdate=TRUE)
              showMetadataItem(object, "cruise",                   "Cruise:              ")
              showMetadataItem(object, "ship",                     "Vessel:              ")
              showMetadataItem(object, "station",                  "Station:             ")
              callNextMethod()
          })


 
findInHeader <- function(key, lines) # local
{
    i <- grep(key, lines)
    if (length(i) < 1)
        ""
    else
        gsub("\\s*$", "", gsub("^\\s*", "", gsub("'","", gsub(",","",strsplit(lines[i[1]], "=")[[1]][2]))))
}

#' @title Translate from ODF Names to Oce Names
#'
#' @description
#' Translate data names in the ODF convention to similar names in the Oce convention.
#'
#' @details
#' The following table gives the regular expressions that define recognized
#' ODF names, along with the translated names as used in oce objects.
#' If an item is repeated, then the second one has a \code{2} appended
#' at the end, etc.  Note that quality-control columns (with names starting with
#' \code{"QQQQ"}) are not handled with regular expressions. Instead, if such
#' a flag is found in the i-th column, then a name is constructed by taking
#' the name of the (i-1)-th column and appending \code{"Flag"}.
#' \tabular{lll}{
#'     \strong{Regexp} \tab \strong{Result}           \tab \strong{Notes}                                             \cr
#'     \code{ALTB_*.*} \tab \code{altimeter}          \tab                                                            \cr
#'     \code{BATH_*.*} \tab \code{barometricDepth}    \tab Barometric depth (of sensor? of water column?)             \cr
#'     \code{BEAM_*.*} \tab \code{a}                  \tab Used in \code{adp} objects                                 \cr
#'     \code{CNTR_*.*} \tab \code{scan}               \tab Used in \code{ctd} objects                                 \cr
#'     \code{CRAT_*.*} \tab \code{conductivity}       \tab Conductivity ratio                                         \cr
#'     \code{COND_*.*} \tab \code{conductivity}       \tab Conductivity in S/m                                        \cr
#'     \code{DEPH_*.*} \tab \code{pressure}           \tab Sensor depth below sea level                               \cr
#'     \code{DOXY_*.*} \tab \code{oxygen}             \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{ERRV_*.*} \tab \code{error}              \tab Used in \code{adp} objects                                 \cr
#'     \code{EWCT_*.*} \tab \code{u}                  \tab Used in \code{adp} and \code{cm} objects                   \cr
#'     \code{FFFF_*.*} \tab \code{flag_archaic}       \tab Old flag name, replaced by \code{QCFF}                     \cr
#'     \code{FLOR_*.*} \tab \code{fluorometer}        \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{FWETLABS} \tab \code{fwetlabs}           \tab Used in ??                                                 \cr
#'     \code{HCDM}     \tab \code{directionMagnetic}  \tab                                                            \cr
#'     \code{HCDT}     \tab \code{directionTrue}      \tab                                                            \cr
#'     \code{HCSP}     \tab \code{speedHorizontal}    \tab                                                            \cr
#'     \code{LATD_*.*} \tab \code{latitude}           \tab                                                            \cr
#'     \code{LOND_*.*} \tab \code{longitude}          \tab                                                            \cr
#'     \code{NSCT_*.*} \tab \code{v}                  \tab Used in \code{adp} objects                                 \cr
#'     \code{OCUR_*.*} \tab \code{oxygen}             \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{OTMP_*.*} \tab \code{oxygenTemperature}  \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{OXYV_*.*} \tab \code{oxygenVoltage}      \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{PHPH_*.*} \tab \code{pH}                 \tab                                                            \cr
#'     \code{POTM_*.*} \tab \code{theta}              \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{PRES_*.*} \tab \code{pressure}           \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{PSAL_*.*} \tab \code{salinity}           \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{PSAR_*.*} \tab \code{par}                \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{QCFF_*.*} \tab \code{flag}               \tab Overall flag                                               \cr
#'     \code{SIGP_*.*} \tab \code{sigmaTheta}         \tab Used mainly in \code{ctd} objecs                           \cr
#'     \code{SIGT_*.*} \tab \code{sigmat}             \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{SYTM_*.*} \tab \code{time}               \tab Used in many objects                                       \cr
#'     \code{TE90_*.*} \tab \code{temperature}        \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{TEMP_*.*} \tab \code{temperature}        \tab Used mainly in \code{ctd} objects                          \cr
#'     \code{UNKN_*.*} \tab \code{-}                  \tab The result is context-dependent                            \cr
#'     \code{VCSP_*.*} \tab \code{w}                  \tab Used in \code{adp} objects                                 \cr
#' }
#' Any code not shown in the list is transferred to the oce object without renaming, apart from 
#' the adjustment of suffix numbers. The following code have been seen in data files from
#' the Bedford Institute of Oceanography: \code{ALTB}, \code{PHPH} and \code{QCFF}.
#'
#' @section Consistency warning:
#' There are disagreements on variable names. For example, the ``DFO
#' Common Data Dictionary''
#' (\url{http://www.isdm.gc.ca/isdm-gdsi/diction/code_search-eng.asp?code=DOXY})
#' indicates that \code{DOXY} has unit millmole/m^3 for NODC and MEDS, but
#' has unit mL/L for BIO and IML.
#'
#' @param ODFnames Vector of strings holding ODF names.
#' @param ODFunits Vector of strings holding ODF units.
#' @param columns Optional list containing name correspondances, as described for
#' \code{\link{read.ctd.odf}}.
#' @param PARAMETER_HEADER Optional list containing information on the data variables.
#' @template debugTemplate
#' @return A vector of strings.
#' @author Dan Kelley
#' @family functions that interpret variable names and units from headers
ODFNames2oceNames <- function(ODFnames, ODFunits=NULL,
                              columns=NULL, PARAMETER_HEADER=NULL, debug=getOption("oceDebug"))
{
    n <- length(ODFnames)
    if (n != length(ODFunits))
        stop("length of ODFnames and ODFunits must agree but they are ", n, " and ", length(ODFunits))
    names <- ODFnames
    ## message("names: ", paste(names, collapse="|"))
    ## Capture names for UNKN_* items, and key on them.  Possibly this should be done to
    ## get all the names, but then we just transfer the problem of decoding keys
    ## to decoding strings, and that might yield problems with encoding, etc.
    if (!is.null(PARAMETER_HEADER)) {
        if (length(grep("^UNKN_.*", PARAMETER_HEADER[[i]]$CODE))) {
            uname <- PARAMETER_HEADER[[i]]$NAME
            ## message("i:", i, ", name:\"", uname)
            name <- if (length(grep("Percent Good Pings", uname ))) "g" else uname
        }
    }
    ## If 'name' is mentioned in columns, then use columns and ignore the lookup table.
    if (!is.null(columns)) {
        ##message("name:", name)
        ## d<-read.ctd("~/src/oce/create_data/ctd/ctd.cnv",columns=list(salinity=list(name="sal00",unit=list(expression(), scale="PSS-78monkey"))))
        cnames <- names(columns)
        for (i in seq_along(cnames)) {
            if (name[i] == columns[[i]]$name) {
                ##message("HIT; name=", cnames[i])
                ##message("HIT; unit$scale=", columns[[i]]$unit$scale)
                name[i] = names
            }
        }
        ## do something with units too; check this block generally for new spelling
        stop("FIXME(Kelley): code 'columns' support into ODFNames2oceNames")
    }


    ## Infer standardized names for columns, partly based on documentation (e.g. PSAL for salinity), but
    ## mainly from reverse engineering of some files from BIO and DFO.  The reverse engineering
    ## really is a kludge, and if things break (e.g. if data won't plot because of missing temperatures,
    ## or whatever), this is a place to look.
    names <- gsub("ALTB", "altimeter", names)
    names <- gsub("BATH", "waterDepth", names) # FIXME: is this water column depth or sensor depth?
    names <- gsub("BEAM", "a", names)  # FIXME: is this sensible?
    names <- gsub("CNTR", "scan", names)
    names <- gsub("CRAT", "conductivity", names)
    names <- gsub("COND", "conductivity", names)
    names <- gsub("DEPH", "depth", names)
    names <- gsub("DOXY", "oxygen", names)
    names <- gsub("ERRV", "error", names)
    names <- gsub("EWCT", "u", names)
    names <- gsub("FFFF", "flag_archaic", names)
    names <- gsub("FLOR", "fluorometer", names)
    names <- gsub("FWETLABS", "fwetlabs", names) # FIXME: what is this?
    names <- gsub("HCSP", "speedHorizontal", names)
    names <- gsub("HCDM", "directionMagnetic", names)
    names <- gsub("HCDT", "directionTrue", names)
    names <- gsub("LATD", "latitude", names)
    names <- gsub("LOND", "longitude", names)
    names <- gsub("NSCT", "v", names)
    names <- gsub("OCUR", "oxygen", names)
    names <- gsub("OTMP", "oxygenTemperature", names)
    names <- gsub("OXYV", "oxygenVoltage", names)
    names <- gsub("PHPH", "pH", names)
    names <- gsub("POTM", "theta", names) # in a moored ctd file examined 2014-05-15
    names <- gsub("PRES", "pressure", names)
    names <- gsub("PSAL", "salinity", names)
    names <- gsub("PSAR", "par", names)
    names <- gsub("QCFF", "flag", names) # overall flag
    names <- gsub("SIGP", "sigmaTheta", names)
    names <- gsub("SIGT", "sigmat", names) # in a moored ctd file examined 2014-05-15
    names <- gsub("SYTM", "time", names) # in a moored ctd file examined 2014-05-15
    names <- gsub("TE90", "temperature", names)
    names <- gsub("TEMP", "temperature", names)
    names <- gsub("VCSP", "w", names)
    ## Step 3: recognize something from moving-vessel CTDs
    ## Step 4: some meanings inferred (guessed, really) from file CTD_HUD2014030_163_1_DN.ODF
    ## Finally, fix up suffixes.
    ##message("names (line 324): ", paste(names, collapse="|"))
    names <- gsub("_[0-9][0-9]", "", names)
    ##message("names (line 326): ", paste(names, collapse="|"))
    if (n > 1) {
        for (i in 2:n) {
            ##message("names[", i, "] = '", names[i], "'")
            if (1 == length(grep("^QQQQ", names[i])))
                names[i] <- paste(names[i-1], "Flag", sep="")
        }
    }
    ##message("finally, names: ", paste(names, collapse="|"))
    ## Now deal with units
    units <- list()
    for (i in seq_along(names)) {
        ## NOTE: this was originally coded with ==, but as errors in ODF
        ## formatting have been found, I've moved to grep() instead; for
        ## example, the sigma-theta case is done that way, because the
        ## original code expected kg/m^3 but then (issue 1051) I ran
        ## across an ODF file that wrote density as Kg/m^3.
        units[[names[i]]] <- if (ODFunits[i] == "counts") {
            list(unit=expression(), scale="")
        } else if (ODFunits[i] == "db") {
            list(unit=expression(dbar), scale="")
        } else if (ODFunits[i] == "decibars") {
            list(unit=expression(dbar), scale="")
        } else if (1 == length(grep("^deg(ree){0,1}(s){0,1}$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(degree), scale="")
        } else if (1 == length(grep("^IT[P]{0,1}S-68, deg C$", ODFunits[i], ignore.case=TRUE))) {
            ## handles both the correct IPTS and the incorrect ITS.
            list(unit=expression(degree*C), scale="IPTS-68")
        } else if (ODFunits[i] == "degrees C") { # guess on scale
            list(unit=expression(degree*C), scale="ITS-90")
        } else if (ODFunits[i] == "ITS-90, deg C") {
            list(unit=expression(degree*C), scale="ITS-90")
        } else if (1 == length(grep("^m$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(m), scale="")
        } else if (ODFunits[i] == "mg/m^3") {
            list(unit=expression(mg/m^3), scale="")
        } else if (ODFunits[i] == "ml/l") {
            list(unit=expression(ml/l), scale="")
        ##} else if (ODFunits[i] == "m/s") {
        } else if (1 == length(grep("^\\s*m/s\\s*$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(m/s), scale="")
        #} else if (ODFunits[i] == "mho/m") {
        } else if (1 == length(grep("^\\mho(s){0,1}/m\\s*$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(mho/m), scale="")
        } else if (ODFunits[i] == "mmho/cm") {
            list(unit=expression(mmho/cm), scale="")
        ##} else if (ODFunits[i] == "[(]*none[)]$") {
        } else if (1 == length(grep("^[(]*none[)]*$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(), scale="")
        ##} else if (ODFunits[i] == "PSU") {
        } else if (1 == length(grep("^psu$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(), scale="PSS-78")
        } else if (1 == length(grep("^\\s*kg/m\\^3$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(kg/m^3), scale="")
        } else if (1 == length(grep("^\\s*kg/m\\*\\*3\\s*$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(kg/m^3), scale="")
        } else if (1 == length(grep("^sigma-theta,\\s*kg/m\\^3$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(kg/m^3), scale="")
        } else if (1 == length(grep("^seconds$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(s), scale="")
        } else if (ODFunits[i] == "S/m") {
            list(unit=expression(S/m), scale="")
        } else if (ODFunits[i] == "V") {
            list(unit=expression(V), scale="")
        } else if (1 == length(grep("^ug/l$", ODFunits[i], ignore.case=TRUE))) {
            list(unit=expression(ug/l), scale="")
        } else if (nchar(ODFunits[i]) == 0) {
            list(unit=expression(), scale="")
        } else {
            warning("unable to interpret ODFunits[", i, "]='", ODFunits[i], "', for item named '", names[i], "'", sep="")
            list(unit=as.expression(ODFunits[i]), scale=ODFunits[i])
        }
    }
    ## Catch some problems I've seen in data
    directionVariables <- which(names == "directionMagnetic" | names == "directionTrue")
    for (directionVariable in directionVariables) {
        ## message("directionVariable=",directionVariable)
        unit <- units[[directionVariable]]$unit
        if (is.null(unit)) {
            warning("no unit found for '", 
                    names[[directionVariable]], "'; this will not affect calculations, though")
            ## units[[directionVariable]]$unit <- expression(degree)
        } else if ("degree" != as.character(unit)) {
            warning("odd unit, '", as.character(unit), "', for '",
                    names[directionVariable], "'; this will not affect calculations, though")
            ## units[[directionVariable]]$unit <- expression(degree)
        }
    }
    list(names=names, units=units)
}


#' @title Create ODF object from the output of \code{ODF::read_ODF()}
#' 
#' @description
#' As of August 11, 2015, \code{ODF::read_ODF} returns a list with 9 elements,
#' one named \code{DATA}, which is a \code{\link{data.frame}} containing the
#' columnar data, the others being headers of various sorts.  The present
#' function constructs an oce object from such data, facilitating processing
#' and plotting with the general oce functions.
#' This involves storing the 8 headers verbatim in the
#' \code{odfHeaders} in the \code{metadata} slot, and also
#' copying some of the header
#' information into more standard names (e.g.  \code{metadata@@longitude} is a
#' copy of \code{metadata@@odfHeader$EVENT_HEADER$INITIAL_LATITUDE}).  As for
#' the \code{DATA}, they are stored in the \code{data} slot, after renaming
#' from ODF to oce convention using \code{\link{ODFNames2oceNames}}.
#' 
#' @param ODF A list as returned by \code{read_ODF} in the \code{ODF} package
#' @param coerce A logical value indicating whether to coerce the return value
#' to an appropriate object type, if possible.
#' @param debug a flag that turns on debugging.  Set to 1 to get a moderate
#' amount of debugging information, or to 2 to get more.
#' @return An oce object, possibly coerced to a subtype.
#'
#' @section Caution: This function may change as the \code{ODF} package
#' changes.  Since \code{ODF} has not been released yet, this should not affect
#' any users except those involved in the development of \code{oce} and
#' \code{ODF}.
#' @author Dan Kelley
#' @family things related to \code{odf} data
ODF2oce <- function(ODF, coerce=TRUE, debug=getOption("oceDebug"))
{
    ## Stage 1. insert metadata (with odfHeader holding entire ODF header info)
    ## FIXME: add other types, starting with ADCP perhaps
    isCTD <- FALSE
    isMCTD <- FALSE
    if (coerce) {
        if ("CTD" == ODF$EVENT_HEADER$DATA_TYPE) { 
            isCTD <- TRUE
            res <- new("ctd")
        } else if ("MCTD" == ODF$EVENT_HEADER$DATA_TYPE) { 
            isMCTD <- TRUE
            res <- new("ctd")
            res@metadata$deploymentType <- "moored"
        } else {
            res <- new("odf") # FIXME: other types
        }
    } else {
        res <- new("odf")
    }
    ## Save the whole header as read by BIO routine read_ODF()

    res@metadata$odfHeader <- list(ODF_HEADER=ODF$ODF_HEADER,
                                    CRUISE_HEADER=ODF$CRUISE_HEADER,
                                    EVENT_HEADER=ODF$EVENT_HEADER,
                                    METEO_HEADER=ODF$METEO_HEADER,
                                    INSTRUMENT_HEADER=ODF$INSTRUMENT_HEADER,
                                    QUALITY_HEADER=ODF$QUALITY_HEADER,
                                    GENERAL_CAL_HEADER=ODF$GENERAL_CAL_HEADER,
                                    POLYNOMIAL_CAL_HEADER=ODF$POLYNOMIAL_CAL_HEADER,
                                    COMPASS_CAL_HEADER=ODF$COMPASS_CAL_HEADER,
                                    HISTORY_HEADER=ODF$HISTORY_HEADER,
                                    PARAMETER_HEADER=ODF$PARAMETER_HEADER,
                                    RECORD_HEADER=ODF$RECORD_HEADER,
                                    INPUT_FILE=ODF$INPUT_FILE)

    ## Define some standard items that are used in plotting and summaries
    if (isCTD) {
        res@metadata$type <- res@metadata$odfHeader$INSTRUMENT_HEADER$INST_TYPE
        res@metadata$model <- res@metadata$odfHeader$INSTRUMENT_HEADER$INST_MODEL
        res@metadata$serialNumber <- res@metadata$odfHeader$INSTRUMENT_HEADER$SERIAL_NUMBER
    }
    res@metadata$startTime <- strptime(res@metadata$odfHeader$EVENT_HEADER$START_DATE_TIME,
                                       "%d-%B-%Y %H:%M:%S", tz="UTC")
    res@metadata$filename <- res@metadata$odfHeader$ODF_HEADER$FILE_SPECIFICATION
    res@metadata$serialNumber <- res@metadata$odfHeader$INSTRUMENT_HEADER$SERIAL_NUMBER
    res@metadata$ship <- res@metadata$odfHeader$CRUISE_HEADER$PLATFORM
    res@metadata$cruise <- res@metadata$odfHeader$CRUISE_HEADER$CRUISE_NUMBER
    res@metadata$station <- res@metadata$odfHeader$EVENT_HEADER$EVENT_NUMBER # FIXME: is this right?
    res@metadata$scientist <- res@metadata$odfHeader$CRUISE_HEADER$CHIEF_SCIENTIST
    res@metadata$latitude <- as.numeric(res@metadata$odfHeader$EVENT_HEADER$INITIAL_LATITUDE)
    res@metadata$longitude <- as.numeric(res@metadata$odfHeader$EVENT_HEADER$INITIAL_LONGITUDE)

    ## Stage 2. insert data (renamed to Oce convention)
    xnames <- names(ODF$DATA)
    res@data <- as.list(ODF$DATA)
    ## table relating ODF names to Oce names ... guessing on FFF and SIGP, and no idea on CRAT
    ## FIXME: be sure to record unit as conductivityRatio.
    resNames <- ODFNames2oceNames(xnames, columns=NULL, PARAMETER_HEADER=ODF$PARAMETER_HEADER, debug=debug-1)
    names(res@data) <- resNames
    ## Obey missing values ... only for numerical things (which might be everything, for all I know)
    nd <- length(resNames)
    for (i in 1:nd) {
        if (is.numeric(res@data[[i]])) {
            NAvalue <- as.numeric(ODF$PARAMETER_HEADER[[i]]$NULL_VALUE)
            ## message("NAvalue: ", NAvalue)
            res@data[[i]][res@data[[i]] == NAvalue] <- NA
        }
    }
    ## Stage 3. rename QQQQ_* columns as flags on the previous column
    names <- names(res@data)
    for (i in seq_along(names)) {
        if (substr(names[i], 1, 4) == "QQQQ") {
            if (i > 1) {
                names[i] <- paste(names[i-1], "Flag", sep="")
            }
        }
    }
    ## use old (FFFF) flag if there is no modern (QCFF) flag
    if ("flag_archaic" %in% names && !("flag" %in% names))
        names <- gsub("flag_archaic", "flag", names)
    names(res@data) <- names
    res
}


#' @title Read an ODF file
#'
#' @description
#' ODF (Ocean Data Format) is a 
#' format developed at the Bedford Institute of Oceanography and also used
#' at other Canadian Department of Fisheries and Oceans (DFO) facilities.
#' It can hold various types of time-series data, which includes a variety
#' of instrument types. Thus, \code{read.odf} 
#' is used by \code{read.ctd.odf} for CTD data, etc. As of mid-2015,
#' \code{read.odf} is still in development, with features being added as  a 
#' project with DFO makes available more files.
#'
#' @details
#' Note that some elements of the metadata are particular to ODF objects,
#' e.g. \code{depthMin}, \code{depthMax} and \code{sounding}, which
#' are inferred from ODF items named \code{MIN_DEPTH}, \code{MAX_DEPTH}
#' and \code{SOUNDING}, respectively. In addition, the more common metadata
#' item \code{waterDepth}, which is used in \code{ctd} objects to refer to
#' the total water depth, is set to \code{sounding} if that is finite,
#' or to \code{maxDepth} otherwise.
#'
#' @examples
#' library(oce)
#' odf <- read.odf(system.file("extdata", "CTD_BCD2014666_008_1_DN.ODF", package="oce")) 
#' # Figure 1. make a CTD, and plot (with span to show NS)
#' plot(as.ctd(odf), span=500, fill='lightgray')
#' # show levels with bad QC flags
#' subset(odf, flag!=0)
#' # Figure 2. highlight bad data on TS diagram
#' plotTS(odf, type='o') # use a line to show loops
#' bad <- odf[["flag"]]!=0
#' points(odf[['salinity']][bad],odf[['temperature']][bad],col='red',pch=20)
#'
#' @param file the file containing the data.
#' @template debugTemplate
#' @param columns An optional \code{\link{list}} that can be used to convert unrecognized
#' data names to resultant variable names.  For example,
#' \code{columns=list(salinity=list(name="salt", unit=list(unit=expression(), scale="PSS-78"))}
#' states that a short-name of \code{"salt"} represents salinity, and that the unit is
#' as indicated. This is passed to \code{\link{cnvName2oceName}} or \code{\link{ODFNames2oceNames}},
#' as appropriate, and takes precendence over the lookup table in that function.
#' @return an object of class \code{oce}. It is up to a calling function to determine what to do with this object.
#' @seealso \code{\link{ODF2oce}} will be an alternative to this, once (or perhaps if) a \code{ODF}
#' package is released by the Canadian Department of Fisheries and Oceans.

#' @references Anthony W. Isenor and David Kellow, 2011. ODF Format Specification
#' Version 2.0. (This is a .doc file downloaded from a now-forgotten URL by Dan Kelley,
#' in June 2011.)
read.odf <- function(file, columns=NULL, debug=getOption("oceDebug"))
{
    oceDebug(debug, "read.odf(\"", file, "\", ...) {\n", unindent=1, sep="")
    if (is.character(file)) {
        filename <- fullFilename(file)
        file <- file(file, "r")
        on.exit(close(file))
    } else {
        filename <- ""
    }
    if (!inherits(file, "connection"))
        stop("argument `file' must be a character string or connection")
    if (!isOpen(file)) {
        open(file, "r")
        on.exit(close(file))
    }
    lines <- readLines(file, 1000, encoding="UTF-8")
    pushBack(lines, file) # we used to read.table(text=lines, ...) but it is VERY slow
    dataStart <- grep("-- DATA --", lines)
    if (!length(dataStart)) {
        lines <- readLines(file, encoding="UTF-8")
        dataStart <- grep("-- DATA --", lines)
        if (!length(dataStart)) {
            stop("cannot locate a line containing '-- DATA --'")
        }
        pushBack(lines, file)
    }

    parameterStart <- grep("PARAMETER_HEADER", lines)
    if (!length(parameterStart))
        stop("cannot locate any lines containing 'PARAMETER_HEADER'")
    ## namesWithin <- parameterStart[1]:dataStart[1]
    ## extract column codes in a step-by-step way, to make it easier to adjust if the format changes

    ## The mess below hides warnings on non-numeric missing-value codes.
    options <- options('warn')
    options(warn=-1) 
    nullValue <- NA
    t <- try({nullValue <- as.numeric(findInHeader("NULL_VALUE", lines)[1])},
        silent=TRUE)
    if (class(t) == "try-error") {
        nullValue <- findInHeader("NULL_VALUE", lines)[1]
    }
    options(warn=options$warn)

    ODFunits <- lines[grep("^\\s*UNITS\\s*=", lines)]
    ODFunits <- gsub("^[^']*'(.*)'.*$",'\\1', ODFunits) # e.g.  "  UNITS= 'none',"
    ##message("below is ODFunits...")
    ##print(ODFunits)

    ODFnames <- lines[grep("^\\s*CODE\\s*=", lines)]
    ODFnames <- gsub("^.*CODE=", "", ODFnames)
    ODFnames <- gsub(",", "", ODFnames)
    ODFnames <- gsub("^[^']*'(.*)'.*$",'\\1', ODFnames) # e.g. "  CODE= 'CNTR_01',"
    ##message("below is ODFnames...")
    ##print(ODFnames)

    oceDebug(debug, "ODFnames: ", paste(ODFnames, collapse="|"), "\n")
    namesUnits <- ODFNames2oceNames(ODFnames, ODFunits, PARAMETER_HEADER=NULL, columns=columns, debug=debug-1)
    ##names <- ODFName2oceName(ODFnames, PARAMETER_HEADER=NULL, columns=columns, debug=debug-1)
    oceDebug(debug, "oce names:", paste(namesUnits$names, collapse="|"), "\n")
    scientist <- findInHeader("CHIEF_SCIENTIST", lines)
    ship <- findInHeader("PLATFORM", lines) # maybe should rename, e.g. for helicopter
    institute <- findInHeader("ORGANIZATION", lines) # maybe should rename, e.g. for helicopter
    station <- findInHeader("EVENT_NUMBER", lines)
    latitude <- as.numeric(findInHeader("INITIAL_LATITUDE", lines))
    longitude <- as.numeric(findInHeader("INITIAL_LONGITUDE", lines))
    cruise <- findInHeader("CRUISE_NAME", lines)
    countryInstituteCode <- findInHeader("COUNTRY_INSTITUTE_CODE", lines)
    cruiseNumber <- findInHeader("CRUISE_NUMBER", lines)
    DATA_TYPE <- findInHeader("DATA_TYPE", lines)
    deploymentType <- if ("CTD" == DATA_TYPE) "profile" else if ("MCTD" == DATA_TYPE) "moored" else "unknown"
    ## date <- strptime(findInHeader("START_DATE", lines), "%b %d/%y")
    startTime <- strptime(tolower(findInHeader("START_DATE_TIME", lines)), "%d-%b-%Y %H:%M:%S", tz="UTC")
    ## endTime <- strptime(tolower(findInHeader("END_DATE_TIME", lines)), "%d-%b-%Y %H:%M:%S", tz="UTC")
    NAvalue <- as.numeric(findInHeader("NULL_VALUE", lines))
    depthMin <- as.numeric(findInHeader("MIN_DEPTH", lines))
    depthMax <- as.numeric(findInHeader("MAX_DEPTH", lines))
    sounding <- as.numeric(findInHeader("SOUNDING", lines))
    waterDepth <- ifelse(sounding!=NAvalue, sounding, ifelse(depthMax!=NAvalue,depthMax,NA)) # also see later

    type <- findInHeader("INST_TYPE", lines)
    if (length(grep("sea", type, ignore.case=TRUE)))
        type <- "SBE"
    serialNumber <- findInHeader("SERIAL_NUMBER", lines)
    model <- findInHeader("MODEL", lines)
    res <- new("odf")
    res@metadata$header <- NULL
    res@metadata$units <- namesUnits$units
    ## res@metadata$dataNamesOriginal <- ODFnames
    res@metadata$dataNamesOriginal <- as.list(ODFnames)
    names(res@metadata$dataNamesOriginal) <- namesUnits$names
    res@metadata$type <- type
    res@metadata$model <- model
    res@metadata$serialNumber <- serialNumber
    res@metadata$ship <- ship
    res@metadata$scientist <- scientist
    res@metadata$institute <- institute
    res@metadata$address <- NULL
    res@metadata$cruise <- cruise
    res@metadata$station <- station
    res@metadata$countryInstituteCode <- countryInstituteCode
    res@metadata$cruiseNumber <- cruiseNumber
    res@metadata$deploymentType <- deploymentType
    res@metadata$date <- startTime
    res@metadata$startTime <- startTime
    res@metadata$latitude <- latitude
    res@metadata$longitude <- longitude
    res@metadata$recovery <- NULL
    res@metadata$waterDepth <- waterDepth
    res@metadata$depthMin <- depthMin
    res@metadata$depthMax <- depthMax
    res@metadata$sounding <- sounding
    res@metadata$sampleInterval <- NA
    res@metadata$filename <- filename
    ##> ## fix issue 768
    ##> lines <- lines[grep('%[0-9.]*f', lines,invert=TRUE)]
    data <- read.table(file, skip=dataStart, stringsAsFactors=FALSE)
    if (length(data) != length(namesUnits$names))
        stop("mismatch between length of data names (", length(namesUnits$names), ") and number of columns in data matrix (", length(data), ")")
    names(data) <- namesUnits$names
    if (!is.na(nullValue)) {
        data[data==nullValue] <- NA
    }
    if ("time" %in% namesUnits$names)
        data$time <- as.POSIXct(strptime(as.character(data$time), format="%d-%b-%Y %H:%M:%S", tz="UTC"))
    ##res@metadata$names <- namesUnits$names
    ##res@metadata$labels <- namesUnits$names
    res@data <- as.list(data)

    ## Return to water depth issue. In a BIO file, I found that the missing-value code was
    ## -99, but that a SOUNDING was given as -99.9, so this is an extra check.
    if (is.na(waterDepth) || waterDepth < 0) {
        res@metadata$waterDepth <- max(abs(res@data$pressure), na.rm=TRUE)
        warning("estimating waterDepth from maximum pressure")
    }

    res@processingLog <- processingLogAppend(res@processingLog, paste(deparse(match.call()), sep="", collapse=""))
    oceDebug(debug, "} # read.odf()\n")
    res
}

