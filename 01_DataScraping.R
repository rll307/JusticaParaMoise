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