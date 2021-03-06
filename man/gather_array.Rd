% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/gather_array.r
\name{gather_array}
\alias{gather_array}
\title{Expands a tbl_json to span the indices of a JSON array}
\usage{
gather_array(x, column.name = "array.index")
}
\arguments{
\item{x}{a tbl_json whose JSON attribute should always be an array}

\item{column.name}{the name to give to the array index column created}
}
\value{
a tbl_json with a new column (column.name) that captures the array
  index and JSON attribute extracted from the array
}
\description{
Expands a tbl_json to span the indices of a JSON array
}

