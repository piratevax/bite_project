library(stringr)

readFile <- function(path) {
  if (! (str_detect(path, ".csv$") || str_detect(path, ".tsv$"))) {
    stop("File not csv or tsv!")
  }
  if (str_detect(path, ".csv$")) {
    return(read.csv(path, header = TRUE))
  } else {
    return(read.table(path, header = TRUE, sep = "\t"))
  }
}

