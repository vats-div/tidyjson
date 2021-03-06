#' Append keys to a new column
#' 
#' @name append_values
#' @param x a tbl_json object
#' @param column.name the column.name to append the values into the data.frame
#'   under
#' @param force parameter that determines if the variable type should be computed or not
#'        if force is FALSE, then the function may take more memory
NULL

#' Creates the append_values_* functions
#' @param type the JSON type that will be appended
#' @param as.value function to force coercion to numeric, string, or logical
append_values_factory <- function(type, as.value) {
  
  function(x, column.name = type, force=TRUE) {
    
    assert_that(is.tbl_json(x))
  
    # Extract json 
    json <- attr(x, "JSON")

    assert_that(length(json) == nrow(x))
    
    # if json is empty, return empty
    if (length(json) == 0) {
       x[column.name] <- as.value(NULL)
       return(tbl_json(x, json))
     }
  
    # if force is FALSE, then check type of the elements 
    if (!force) { 
       x[column.name] <- append_values_type(json, type) %>% as.value
    } else {
       new_val <- my_unlist(json) %>% as.value
       assert_that(length(new_val) == nrow(x))
       x[column.name] <- new_val
    }
  
    # return as appropriate class type 
    tbl_json(x, json)
    
  }
}

#' Unlists while preserving NULLs and only unlisting lists with one value
#' @param l a list that we want to unlist
my_unlist <- function(l) {
  nulls <- vapply(l, function(x) is.null(x) | is.list(x), TRUE)
  l[nulls] <- NA
  unlist(l, recursive = FALSE)
}

#' get list of values from json
#' @param json extracted using attributes
#' @param type input type (numeric, string, etc)
append_values_type <- function(json, type) {

   # Determine type
   types <- determine_types(json)
    
   # Initialize column to NAs
   column <- rep(NA, length(json))
    
   # Identify correct types
   correct <- types == type
   
   # Set correct to data
   column[correct] <- unlist(json[correct])

   column
    
}

#' @export
#' @rdname append_values
append_values_string <- append_values_factory("string", function(x) as.character(x))

#' @export
#' @rdname append_values
append_values_number <- append_values_factory("number", function(x) as.numeric(x))

#' @export
#' @rdname append_values
append_values_logical <- append_values_factory("logical", function(x) as.logical(x))
