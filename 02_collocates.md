# Colocatesand basic statistics

## Introduction

This repository contains the scripts written for our article:

**Representations of Violence against a Black Migrant on Twitter** By [Rodrigo Esteves de Lima Lopes](mailto:rll307@unicamp.br) (CNPq/UNICAMP) and [Vivan Monteiro](mailto:viviangomesms@gmail.com) (CNPq/UNICAMP).

The article is currently under review by the journal. Once it is published, we will update this page.

## Objective

In this tutorial, we will discuss the procedures for calculating collocates and creating basic statistics about the corpus.

## Packages

In this tutorial, we will need the following packages:

-   quanteda/tidyverse
    -   For quantitative data analysis and corpus compilation.
-   quanteda.textstats
    -   For calculating statistical elements of the corpus.
-   dplyr and tidyr
    -   For data organization.
-   abjutils
    -   For removing accents and diacritics.
-   calculateCoocStatistics
    -   A script written by Martin Schweinberger for collocate calculation.
    -   Originally available [here](https://ladal.edu.au/coll.html#2_Finding_Collocations).

## Procedures

### Pre-processing

1)  After [data scraping](01_DataScraping.md), we will need to select only the data in Portuguese.

    ``` r
    Moise.t <- subset(tweets, lang == "pt")
    ```

2)  Next, we remove accents and diacritics.

    ``` r
    Moise.t$text <- abjutils::rm_accent(Moise.t$text)
    ```

### Corpus compilation and basic statistics

1)  We then create a corpus in the format supported by quanteda.

```         
Moise <- corpus(Moise.t)
```

2)  We tokenise the corpus, allowing for lexical manipulation.

    ``` r
    Moise.tok <- tokens(Moise,
      remove_punct = TRUE,
      remove_numbers = TRUE,
      remove_url = TRUE,
      remove_symbols = TRUE,
      verbose = TRUE
    )
    ```

3)  We correct the spelling of a proper name.

``` r
Moise.tok <- tokens_replace(
  Moise.tok,
  "kabagambe",
  "kabamgabe",
  verbose = TRUE
)
```

4)  Finally, we generate a dfm (document-feature matrix), a requirement for calculating collocates.

``` r
Moise.d <- dfm(Moise.tok,
  tolower = TRUE,
  verbose = TRUE
)
```

### Basic Statistics

To calculate the basic statistics of the corpus, we will use the following sequence of commands based on the quanteda package:

``` r
# Calculates types
type <- 
  ntoken(Moise.tok) |> 
  sum() 
# Calculates tokens
token <- 
  ntype(Moise.tok) |> 
  sum() 
# Calculates types/tokens ratio
TTR <-
  textstat_lexdiv(Moise.tok, measure = 'TTR') 
# TTR means
TTR <- 
  mean(as.numeric(TTR$TTR), na.rm = TRUE) 
#Final data frame
BasicStats <-
  data.frame(
    Types = type,
    Tokens = token,
    TTR = TTR,
    Tweets = length(Moise.t$tweet_id)
  ) 
```

### Collocates

Firstly, we need to import the calculation function.

```
source("._FunctionCollocates.R")
```

In the article, six terms were chosen, and we should run the script for each of them.

```
coocTerm <- "refugiado"
Refugiado <-
  calculateCoocStatistics(coocTerm,
                          Moise.d,
                          measure = "LOGLIK") |> 
  data.frame()
colnames(Refugiado)[1] <- "Value"
Refugiado$Word <- rownames(Refugiado)
Refugiado$Value <- round(Refugiado$Value, 2)
Refugiado$from <- "refugiado"
```
An R script is avalilable [here](02_collocates.R)
