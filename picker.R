remotes::install_github("ABbiodiversity/wildRtrax", force = T)
library(wildRtrax)
library(fs)


all_wbnp_tasks <- dir_ls("/users/alexandremacphail/desktop/wbnpfill", regexp = "*.csv") %>%
  map_dfr(~read_csv(.)) %>%
  mutate(year = lubridate::year(recordingDate),
         hour = lubridate::hour(recordingDate),
         type = case_when(hour %in% c(3:9) ~ "Dawn", hour %in% c(20:23) ~ "Dusk", TRUE ~ NA_character_)) %>%
  drop_na(type) %>%
  group_by(location, year, type) %>%
  tally() %>%
  ungroup() %>%
  filter(n < 4, year == 2018)

wbnp18 <- wt_audio_scanner("/Volumes/BUdata/WBNP/2018", file_type = "all", extra_cols = F)

wbnp18 |>
  mutate(year = lubridate::year(recording_date_time),
         hour = lubridate::hour(recording_date_time),
         type = case_when(hour %in% c(3:9) ~ "Dawn", hour %in% c(20:23) ~ "Dusk", TRUE ~ NA_character_)) %>%
  drop_na(type) |>
  filter(location %in% all_wbnp_tasks$location)
