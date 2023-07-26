# HEADER --------------------------------------------
# Author: Rodrigo Esteves de Lima-Lopes
# Copyright (c) The author
# Email: rll307@unicamp.br
# Wed May 4 11:21:42 2022
# Script Name: 01_DataScraping.R
# Project: JusticaMoise
# Description: Analysis of collocates
# Notes:

library(academictwitteR)

tweets <-
  get_all_tweets(
    query = "#JusticaparaMoise",
    start_tweets = "2022-01-01T00:00:00Z",
    end_tweets = "2022-03-30T00:00:00Z",
    file = "moise",
    data_path = "data/",
    n = 1000000,
  )

tweets <- bind_tweets(
  data_path = "data/",
  output_format = "tidy"
)