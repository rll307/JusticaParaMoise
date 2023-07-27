# Data Scraping

## Introduction

This tutorial provides information regarding data scrapin for the article:

**Representations of Violence against a Black Migrant on Twitter** By [Rodrigo Esteves de Lima Lopes](mailto:rll307@unicamp.br) (CNPq/UNICAMP) and [ Vivian Gomes Monteiro Souza](mailto:viviangomesms@gmail.com) (CNPq/UNICAMP).

The article is currently under review by the journal. Once it is published, we will update this page.

## What do we need?

To perform this scraping, we will need:

1.  An academic Twitter account.

-   This account can be obtained [here](https://developer.twitter.com/en/products/twitter-api/academic-research).

2.  A working installation of [R](https://www.r-project.org/).
3.  The package [AcademictwitteR](https://github.com/cjbarrie/academictwitteR).

## Commands

The following command brings the data scraping parameters:

```{r}
get_all_tweets(
    query = "#JusticaparaMoise",
    start_tweets = "2022-01-01T00:00:00Z",
    end_tweets = "2022-03-30T00:00:00Z",
    file = "moise",
    data_path = "data/",
    n = 1000000,
  )
```

The following command imports the data to the R platform:

```{r}
tweets <- bind_tweets(
  data_path = "data/",
  output_format = "tidy"
)
```

A simple script is [here](01_DataScraping.R)
