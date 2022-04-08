assert_file_exists <- function(file_arg){
  if(!fs::file_exists(file_arg))
    stop("File: ", file_arg, " was not found.")
  NULL
}
