library(httr)

url <- "http://127.0.0.1/%s"

get_request <- function(path){
    uri <- sprintf(url, path)
    data <- GET(uri, verbose())
    return(data)
}

post_request <- function(path, body){
    uri <- sprintf(url, path)
    data <- POST(uri, body = body, encode = "form", verbose())
    return(data)
}

delete_request <- function(path){
    uri <- sprintf(url, path)
    data <- DELETE(uri, verbose())
    return(data)
}

put_request <- function(path){
    uri <- sprintf(url, path)
    data <- PUT(uri, verbose())
    return(data)
}