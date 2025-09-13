# Load necessary libraries
# install.packages(c("rvest", "dplyr", "stringr"))

library(rvest)
library(dplyr)
library(stringr)

# 1. Get the list of packages as a data frame
url <- "https://cran.r-project.org/web/packages/available_packages_by_date.html"

#### Read the HTML content from the URL ####
cran_html <- read_html(url)

# Extract the table from the HTML and convert it to a data frame
packages_df <- cran_html %>%
  html_table() %>%
  `[[`(1)

# Rename columns for clarity
colnames(packages_df) <- c("Date", "Name", "Desc")

View(packages_df)

# Separate Year, Month, Day
packages_df <- packages_df %>%
  tidyr::separate_wider_delim(
    Date,
    delim = "-",
    names = c("Year", "Month", "Day")
  ) %>%
  dplyr::mutate(
    dplyr::across(
      c(Year, Month, Day),
      as.numeric
    )
  )


# Group by year, month, and day
grouped_packages <- packages_df %>%
  group_by(Year, Month, Day) %>%
  summarize(
    count = n(),
    .groups = "drop"
  ) %>% 
  arrange(desc(Year), desc(Month), desc (Day))

# Print the final grouped data frame
print(grouped_packages)

# Plot Daily Publish
library(ggplot2)
grouped_packages %>% ggplot(aes(Day, count, fill = Year))+
  geom_bar(stat = "identity")


## Group by Year, Month 
# Extract Last Two years
packages_df %>%
  dplyr::group_by(Year, Month) %>%
  dplyr::summarize(
    count = n(),
    .groups = "drop"
  ) %>%
  dplyr::arrange(dplyr::desc(Year), dplyr::desc(Month)) %>%
  dplyr::filter(Year %in% c(max(Year), max(Year) - 1)) %>%
  ggplot2::ggplot(ggplot2::aes(x = Month, y = count)) +
  # Add the vertical line segments for the stems
  ggplot2::geom_segment(ggplot2::aes(x = Month, xend = Month, y = 0, yend = count),
                        linewidth = 1.5, color = "steelblue") +
  # Add the points for the "lollipops"
  ggplot2::geom_point(ggplot2::aes(color = as.factor(Year)), size = 4) +
  # Ensure the x-axis labels are 1-12
  ggplot2::scale_x_continuous(breaks = 1:12) +
  # Separate plots for each year
  ggplot2::facet_wrap(~Year) +
  ggplot2::labs(
    title = "New Packages on CRAN by Month (Last Two Years)",
    subtitle = "Separate panels for each year",
    x = "Month",
    y = "Number of Packages",
    color = "Year"
  )

## Group by Year  
packages_df %>%
  group_by(Year) %>%
  summarize(
    count = n(),
    .groups = "drop"
  ) %>% 
  arrange(desc(Year)) %>% 
  ggplot(aes(Year, count))+geom_bar(stat = "identity")



# Create the lollipop chart
packages_df %>%
  group_by(Year) %>%
  summarize(
    count = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Year)) %>%
  ggplot(aes(x = Year, y = count)) +
  # Add the vertical line segments
  ggplot2::geom_segment(ggplot2::aes(x = Year, xend = Year, y = 0, yend = count),
                        color = "blue") +
  # Add the dots at the end of the segments
  ggplot2::geom_point(color = "red", size = 4) +
  ggplot2::geom_text(ggplot2::aes(label = count), vjust = -0.9, size = 3) +
  ggplot2::labs(
    title = "Number of New Packages on CRAN by Year",
    subtitle = "Data from CRAN package archive",
    x = "Year",
    y = "Number of Packages"
  )

