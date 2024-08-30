if (!require("rmarkdown", character.only = TRUE)) {
  install.packages("rmarkdown")
  library("rmarkdown", character.only = TRUE)
} else {
  library("rmarkdown", character.only = TRUE)
}

rmarkdown::render(here::here("report.rmd"), clean=TRUE)