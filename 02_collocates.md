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
#Refurgiado

coocTerm <- "refugiado"

Refugiado <- calculateCoocStatistics(coocTerm,
                                     Moise.d,
                                     measure = "LOGLIK") |>
  data.frame()

colnames(Refugiado)[1] <- "Value"
Refugiado$Word <- rownames(Refugiado)
#Refugiado$n <- 1:length(Refugiado$Value)
Refugiado$Value <- round(Refugiado$Value, 2)
Refugiado$from <- "refugiado"

# Moïse
coocTerm <- "moise"
MoiseC <- calculateCoocStatistics(coocTerm,
                                  Moise.d,
                                  measure = "LOGLIK") |>
  data.frame()


colnames(MoiseC)[1] <- "Value"
MoiseC$Word <- rownames(MoiseC)
#MoiseC$n <- 1:length(MoiseC$Value)
MoiseC$Value <- round(MoiseC$Value, 2)
MoiseC$from <- "moise"

#MoiseC |> View()
# imigrante

coocTerm <- "imigrante"
imigrante <- calculateCoocStatistics(coocTerm,
                                     Moise.d,
                                     measure = "LOGLIK") |>
  data.frame()

colnames(imigrante)[1] <- "Value"
imigrante$Word <- rownames(imigrante)
#imigrante$n <- 1:length(imigrante$Value)
imigrante$Value <- round(imigrante$Value, 2)
imigrante$from <- "imigrante"
#imigrante |> View()

# congoles

coocTerm <- "congoles"
congoles <- calculateCoocStatistics(coocTerm,
                                    Moise.d,
                                    measure = "LOGLIK") |>
  data.frame()

colnames(congoles)[1] <- "Value"
congoles$Word <- rownames(congoles)
#congoles$n <- 1:length(congoles$Value)
congoles$Value <- round(congoles$Value, 2)
congoles$from <- "congoles"
#congoles |> View()

# estrangeiro

coocTerm <- "estrangeiro"
estrangeiro <- calculateCoocStatistics(coocTerm,
                                       Moise.d,
                                       measure = "LOGLIK") |>
  data.frame()

colnames(estrangeiro)[1] <- "Value"
estrangeiro$Word <- rownames(estrangeiro)
#estrangeiro$n <- 1:length(estrangeiro$Value)
estrangeiro$Value <- round(estrangeiro$Value, 2)
estrangeiro$from <- "estrangeiro"
#colnames(estrangeiro)[2] <- "to"
#names <- rownames(estrangeiro)

#estrangeiro |> View()

# negro

coocTerm <- "negro"
negro <- calculateCoocStatistics(coocTerm,
                                 Moise.d,
                                 measure = "LOGLIK") |>
  data.frame()

colnames(negro)[1] <- "Value"
negro$Word <- rownames(negro)
#negro$n <- 1:length(negro$Value)
negro$Value <- round(negro$Value, 2)
negro$from <- "negro"
#colnames(negro)[2] <- "to"
#names <- rownames(negro)
#negro |> View()
```

### Preparing Matrices
```
Negro_M <- negro[1:10,] #A
Refugiado_M <- Refugiado[1:10,] #B
MoiseC_M <- MoiseC[1:10,] #C
Congoles_M <- congoles[1:10,] #D
Estrangeiro_M <- estrangeiro[1:10,] #E
Imigrante_M <- imigrante[1:10,] #F1

```
# Plotting 

```
set.seed(5645)  
colors2 <- colorRampPalette(c("lightgray","gray", "darkgray", "black"))(10)

A <- Negro_M %>%
  mutate(Word = fct_reorder(Word, Value)) %>%
  ggplot(aes(
    y = Word,
    x = from,
    fill = Value)) +
  geom_tile() +
  scale_fill_gradientn(colours = colors2) +
  coord_equal() +
  labs(
    x = "Nódulo",
    y = "Colocados",
    fill = "Verosimilhança (log)"
  )

B <- Refugiado_M %>%
  mutate(Word = fct_reorder(Word, Value)) %>%
  ggplot(aes(
    y = Word,
    x = from,
    fill = Value)) +
  geom_tile() +
  scale_fill_gradientn(colours = colors2) +
  coord_equal() +
  labs(
    x = "Nódulo",
    y = "Colocados",
    fill = "Verosimilhança (log)"
  )

C <- MoiseC_M %>%
  mutate(Word = fct_reorder(Word, Value)) %>%
  ggplot(aes(
    y = Word,
    x = from,
    fill = Value)) +
  geom_tile() +
  scale_fill_gradientn(colours = colors2) +
  coord_equal() +
  labs(
    x = "Nódulo",
    y = "Colocados",
    fill = "Verosimilhança (log)"
  )

D <- Congoles_M %>%
  mutate(Word = fct_reorder(Word, Value)) %>%
  ggplot(aes(
    y = Word,
    x = from,
    fill = Value)) +
  geom_tile() +
  scale_fill_gradientn(colours = colors2) +
  coord_equal() +
  labs(
    x = "Nódulo",
    y = "Colocados",
    fill = "Verosimilhança (log)"
  )

E <- Estrangeiro_M %>%
  mutate(Word = fct_reorder(Word, Value)) %>%
  ggplot(aes(
    y = Word,
    x = from,
    fill = Value)) +
  geom_tile() +
  scale_fill_gradientn(colours = colors2) +
  coord_equal() +
  labs(
    x = "Nódulo",
    y = "Colocados",
    fill = "Verosimilhança (log)"
  )

F1 <- Imigrante_M %>%
  mutate(Word = fct_reorder(Word, Value)) %>%
  ggplot(aes(
    y = Word,
    x = from,
    fill = Value)) +
  geom_tile() +
  scale_fill_gradientn(colours = colors2) +
  coord_equal() +
  labs(
    x = "Nódulo",
    y = "Colocados",
    fill = "Verosimilhança (log)"
  )
```
![Collocates ploting]()

An R script is avalilable [here](02_collocates.R)

