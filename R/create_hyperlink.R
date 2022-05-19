#' Create hyperlink
#'
#' @param url
#'
#' @return
#' @export
#'
#' @examples

createLink <- function(url) {
  
  paste('<a href=', url,' class="btn btn-primary mb1 black bg-silver" target="_blank">Click here</a>')
  
}


#' List if URLs to create hyperlinks
#'
#' This function contains links to ..
#'
#' @param customer The customer id from secuTrial
#' @param project.id The project id from secuTrial obtained from the Admin Tool
#'
#' @return
#' @export
#'
#' @examples

get_links <- function(customer = "CHI", project.id = 12396){
  
  links <- list(secuTrial = paste0("\\href{https://secutrial2.usb.ch/apps/WebObjects/ST21-productive-DataCapture.woa/wa/choose?customer=",
                                   customer, "&projectid=", project.id))
    
  return(links)
  
}
  