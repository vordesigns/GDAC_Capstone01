## It was necessary to create an ODBC connector for an SQL Server
## Do to my preference of working with the datasets stored in 
## .csv files
# ----------------------------------------------------------------------
install.packages("odbc")
# ----------------------------------------------------------------------
library(odbc)
# ----------------------------------------------------------------------
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "TABITHA",
                 Database = "GDAC",
                 UID = "rgdac",
                 PWD = rstudioapi::askForPassword("Database password"),
                 Port = 1433)
# ----------------------------------------------------------------------
## There are calculations at "Case Study 1_How does a bike-share 
## navigate speedy success" directed.
## [Files]( )(https://divvy-tripdata.s3.amazonaws.com/index.html)
## 1. Each file required calculated fields as follows:
##    Field:  ride_length
##    ^Calculation:    =TEXT(D2-C2,"h:mm:ss")
##
##    Field:  day_of_week
##    ^Calculation:    =WEEKDAY(C2,1)
## The calculations were added to the 66 xxxx-divvy-tripdata.csv 
## files, 1 file named 202209-divvy-publictripdata.csv, and
## 5 files Divvy_Trips_xxxx_Qx files.
## NOTES:
##    ^ Calculations were adjusted for the non xxxx-divvy-tripdata files
##      as/if necessary

# list.files(path, pattern=NULL, all.files=FALSE,
# full.names=FALSE)
# dir(path, pattern=NULL, all.files=FALSE,
# full.names=FALSE)


# # ----------------------------------------------------------------------
# # Helper functions to run the query and report status
# # ----------------------------------------------------------------------
#' Run a non-query SQL command
#' @param con A DBI connection object
#' @param query SQL query as a string
#' @param label Optional label for logging
#' @return NULL, prints message
#' @export
run_query <- function(con, query, label = NULL) {
  tryCatch({
    result <- DBI::dbExecute(con, query)
    prefix <- if (!is.null(label)) paste0("[", label, "] ") else ""
    if (result == 0) {
      message(prefix, "Commands completed successfully.")
    } else {
      message(prefix, result, " rows affected.")
    }
  }, error = function(e) {
    message("Error: ", e$message)
  })
}

# # Execute the query (this line triggers the action)
# run_query(con, query, label = "Create divvy_trips_xxxx_qx")

#' Fetch data from a SQL query
#'
#' @param con A DBI connection object
#' @param query SQL query as a string
#' @param label Optional label for logging
#'
#' @return A data frame containing the result of the query, or NULL on error
#' @export
fetch_data <- function(con, query, label = NULL) {
  tryCatch({
    df <- DBI::dbGetQuery(con, query)
    prefix <- if (!is.null(label)) paste0("[", label, "] ") else ""
    message(prefix, "Query executed. ", nrow(df), " rows returned.")
    return(df)
  }, error = function(e) {
    message("Error: ", e$message)
    return(NULL)
  })
}
