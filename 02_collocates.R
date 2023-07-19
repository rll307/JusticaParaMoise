# HEADER --------------------------------------------
# Author: Rodrigo Esteves de Lima-Lopes
# Copyright (c) The author
# Email: rll307@unicamp.br
# Wed May 4 11:21:42 2022
# Script Name: 02_Collocates.R
# Project: JusticaMoise
# Description: Analysis of collocates

Moise.t <- subset(tweets, lang == "pt")
Moise.t$text <- abjutils::rm_accent(Moise.t$text)
Moise <- corpus(Moise.t)
Moise.tok <- tokens(Moise,
                    remove_punct = TRUE,
                    remove_numbers = TRUE,
                    remove_url = TRUE,
                    remove_symbols = TRUE,
                    verbose = TRUE
)

Moise.tok <- tokens_replace(
  Moise.tok,
  "kabagambe",
  "kabamgabe",
  verbose = TRUE
)

Moise.d <- dfm(Moise.tok,
               tolower = TRUE,
               verbose = TRUE
)


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

source("._FunctionCollocates.R")

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



