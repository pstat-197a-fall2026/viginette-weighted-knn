library(tidyverse)
library(tidymodels)
library(readr)

#1 Loading the raw Spotify dataset
spotify_raw <- read_csv("data/raw/spotify_songs.csv")

set.seed(169)

#2 Remove missing track metadata, unduplicate songs across playlists, and selecting helpful predictors
spotify_fix <- spotify_raw |>
  drop_na(track_name, track_artist) |>
  distinct(track_name, track_artist, .keep_all = TRUE) |>
  select(
    track_id,
    track_name,
    track_artist,
    playlist_genre,
    danceability,
    energy,
    loudness,
    speechiness,
    acousticness,
    instrumentalness,
    liveness,
    valence,
    tempo
  )

#3 Getting a balanced, stratified sample of 450 songs per genre (2,700 total)
spotify_sample <- spotify_fix |>
  group_by(playlist_genre) |>
  slice_sample(n = 450) |>
  ungroup()

#4 Saving the processed dataset
write_csv(spotify_sample, "data/processed/spotify_sample.csv")
