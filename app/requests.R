library(httr)
library(jsonlite)

url <- "http://api:8080/%s"

get_request <- function(path, query) {
    uri <- sprintf(url, path)
    print(uri)
    resp <- GET(uri, query = query)
    data <- fromJSON(content(resp, as = "text"))
    return(data)
}

post_request <- function(path, body) {
    uri <- sprintf(url, path)
    data <- POST(uri, body = body, encode = "form", verbose())
    return(data)
}

delete_request <- function(path) {
    uri <- sprintf(url, path)
    data <- DELETE(uri, verbose())
    return(data)
}

put_request <- function(path) {
    uri <- sprintf(url, path)
    data <- PUT(uri, verbose())
    return(data)
}
