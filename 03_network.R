#Universidade Estadual de Campinas (UNICAMP)
#Autora: Vivian Gomes Monteiro Souza
#Criacao de redes de palavras e frequencias 
# Script Name: 03_Network.R
# Project: JusticaMoise


# Pacotes -----------------------------------------------------------------
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(tidytext)
library(dplyr)
# Análise -----------------------------------------------------------------

#Criacao da variavel
tweets.moise <- tweets

#Selecao dos tweets (texto) dentre as demais informacõs
tweets.moise <- tweets.moise$text

#Exclusao dos acentos
tweets.moise <- abjutils::rm_accent(tweets.moise)

#Transformacao de todo o texto em caixa baixa
tweets.moise <- tolower(tweets.moise)

#Exclusao de caracteres que nao sejam letras
tweets.moise <- stringr::str_replace_all(tweets.moise,"[^a-zA-Z\\s]", "")

#Transformacao do arquivo em data frame
tweets.moise.df <- data.frame(tweets.moise)

#Acrescimo de nome para coluna 
names(tweets.moise.df)[1] <- "Tweet"

#Exclusao dos tweets que se repetem 
tweets.moise.df <- tweets.moise.df %>%
  distinct()

#Criacao Corpus
tweets.moise.corpus <- corpus(tweets.moise.df, text_field = "Tweet")


#Criacao Tokens

tweets.moise.tokens  <- tokens(tweets.moise.corpus,
                              what = "word",
                              remove_punct = TRUE,
                              remove_symbols = TRUE,
                              remove_numbers = TRUE,
                              remove_url = TRUE,
                              split_hyphens = FALSE,
                              include_docvars = TRUE,
                              padding = FALSE,
                              verbose = TRUE
)

#Limpeza do corpus

lista.stopwords <- readr::read_csv('Stopwordsportugues_MT.csv') 
lista.stopwords  <- lista.stopwords |>
  purrr::as_vector()

tweets.moise.tokens <- tokens_remove(tweets.moise.tokens, c(lista.stopwords)) 

#Soma tokes e types

n.tokens.moise <- ntoken(tweets.moise.tokens)
sum(n.tokens.moise) #135.388

n.type.tokens.moise <- ntype(tweets.moise.tokens)
sum(n.type.tokens.moise) #131.371


#Criacao dfm e fcm


tweets.moise.dfm <- dfm(tweets.moise.tokens)
tweets.moise.top <- names(topfeatures(tweets.moise.dfm, 500))

tweets.moise.fcm <- fcm(
  tweets.moise.tokens,
  context = 'window',
  count = "frequency",
  window = 2L,
  weights = NULL,
  ordered = FALSE,
  tri = TRUE
)

tweets.moise.fcm.top <- fcm_select(tweets.moise.fcm , pattern = tweets.moise.top)

# Plot 

textplot_network(tweets.moise.fcm.top, min_freq = 15, edge_color = "#979A9A", edge_alpha = 0.8, edge_size = 5)














