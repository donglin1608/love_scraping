
library(rvest)

base_url <- "https://books.toscrape.com/catalogue/page-"
book_data <- list()

for (i in 1:5) {
  # Construct the URL for the current page
  url <- paste0(base_url, i, ".html")
  
  # Read the HTML content of the page
  page <- read_html(url)
  
  # Extract book titles
  titles <- page %>%
    html_nodes(".product_pod h3 a") %>%
    html_attr("title")
  
  # Extract book prices
  prices <- page %>%
    html_nodes(".product_price .price_color") %>%
    html_text()
  
  # Extract star ratings
  ratings <- page %>%
    html_nodes(".product_pod p.star-rating") %>%
    html_attr("class") %>%
    gsub("star-rating ", "", .)
  
  # Extract availability status
  availability <- page %>%
    html_nodes(".product_price .availability") %>%
    html_text(trim = TRUE)
  
  # Combine the extracted data into a data frame
  page_data <- data.frame(
    Title = titles,
    Price = prices,
    Rating = ratings,
    Availability = availability,
    stringsAsFactors = FALSE
  )
  
  # Append the data frame to the list
  book_data[[i]] <- page_data
}

# Combine all the data into one data frame
book_data_df <- do.call(rbind, book_data)

# View the scraped data
print(book_data_df)

