#' Extracts values from JSON refereced by a sequence of keys
#' @param x tbl_json object
#' @param ... column=value list where 'column' will be the column name created
#'   and 'value' must be a call to jstring(), jnumber() or jlogical() specifying
#'   the path to get the value (and the type implicit in the function name) 
#' @export
spread_values <- function(x, ...) {
  
  assert_that(is.tbl_json(x))
  
  # Get JSON
  json <- attr(x, "JSON")
  
  # Get new values
  new_values <- lapply(list(...), function(f) f(json))
  
  # Add on new values
  x <- data.frame(x, new_values, stringsAsFactors = FALSE)
  
  tbl_json(x, json)
  
}

#' Factory that creates the j* functions below
#' 
#' @param na.value value to replace NULL with
#' @param conversion.function function to convert vector to appropriate type
jfactory <- function(na.value, conversion.function) {
  
  function(...) {
  
    # Prepare path
    path <- prep_path(...)
  
    # Return a closure to deal with JSON lists
    function(json) {
      data <- list_path(json, path)
      data <- replace_nulls(data, na.value)
      conversion.function(data)
    }
    
  }
  
}

#' Navigates nested objects to get at keys of a specific type, to be used as
#' arguments to spread_values
#' 
#' @name jfunctions
#' @param ... the path to follow
#' @return a function that can operate on parsed JSON data
NULL

#' @rdname jfunctions
#' @export
jstring <- jfactory(NA_character_, as.character)

#' @rdname jfunctions 
#' @export
jnumber <- jfactory(NA_real_, as.numeric)

#' @rdname jfunctions  
#' @export
jlogical <- jfactory(NA, as.logical)


