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

#Analisis -----------------------------------------------------------------
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

# Preparing Matrices ------------------------------------------------------
Negro_M <- negro[1:10,] #A
Refugiado_M <- Refugiado[1:10,] #B
MoiseC_M <- MoiseC[1:10,] #C
Congoles_M <- congoles[1:10,] #D
Estrangeiro_M <- estrangeiro[1:10,] #E
Imigrante_M <- imigrante[1:10,] #F1


# Plotting ----------------------------------------------------------------

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


grid.arrange(A, B, C,D,E,F1, ncol = 3) 



