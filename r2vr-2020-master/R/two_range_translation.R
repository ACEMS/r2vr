#' Returns a function to translate a point A on a scale with range (o_min, o_max) to a point B in a range (n_min, n_max)
#'
#' @param old_max Double to indicate the maximum value in pixels of an image's selected axis
#' @param old_min Integer to indicate starting position (0) in pixels of an images selected axis
#' @param new_max Double to indicate the maximum position of the translated image's selected axis
#' @param new_min Double to indicate the minimum position of the translated image's selcted axis
#'
#' @return Function translation(old_position) can be called to give the new position
#' 
#' @examples 
#' \donttest{
#' i_translation <- range_translation(5000)
#' x_translation <- range_translation(4000, 0, 2, -2)
#' y_translation <- range_translation(3000, 0, 3/2, -3/2)
#' 
#' fixed_coordinate_i <- i_translation(2500)
#' fixed_coordinate_x <- x_translation(2000)
#' fixed_coordinate_y<- -y_translation(1500)
#' }
#' 
#' @export
range_translation <- function(old_max, old_min = 0, new_max = 1 , new_min = -1) {
  translation = function(old_position) {
    if (old_position < 0) {
      stop('Please enter a non-negative value')
    }
    if (old_position > old_max || old_position < old_min) {
      stop(paste('Please enter a value between', old_min, 'and', old_max, '. You entered:', old_position))
    }
    # 
    ((old_position - old_min)/(old_max - old_min)) * (new_max - new_min) + new_min
  }
  return(translation)
}