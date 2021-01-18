# this file finds non-binary sentiments and save to different files for SFS and SFT responses

library(readr)
library(dplyr)
library(udpipe)
library(openxlsx)
library(tidytext)
library(stringr)


source('utils.R')

SFS <- read_csv("SFS_2020_cleaned.csv")
SFS$ID <- seq.int(nrow(SFS))
View(SFS$ID)


nrc <- get_sentiments("nrc")
bing <- get_sentiments("bing")


############################
##     SFS 
############################
tidy_Q201 <- SFS %>%
  select( ID, Q201) %>%
  unnest_tokens(word, Q201)

# Q202

tidy_Q202 <- SFS %>%
  select( ID, Q202) %>%
  unnest_tokens(word, Q202)

tidy_Q203 <- SFS %>%
  select( ID, Q203) %>%
  unnest_tokens(word, Q203)


# we are getting the most dominant sentiment based on all words (unigrams only) in the response
sentiment_Q201_SFS <- tidy_Q201 %>%
  inner_join(nrc) %>%
  group_by(ID, sentiment) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  mutate(rank = row_number(desc(count))) %>%
  group_by(ID) %>%
  top_n(1, wt = rank) %>%
  select(ID, sentiment)



SFS_Q201_multisentiment <- SFS %>%
  left_join(sentiment_Q201_SFS)

# save to file
write.csv(SFS_Q201_multisentiment, file = "SFS_Q201_multisentiment.csv", row.names = FALSE)


# for Q202 response
sentiment_Q202_SFS <- tidy_Q202 %>%
  inner_join(nrc) %>%
  group_by(ID, sentiment) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  mutate(rank = row_number(desc(count))) %>%
  group_by(ID) %>%
  top_n(1, wt = rank) %>%
  select(ID, sentiment)

SFS_Q202_multisentiment <- SFS %>%
  left_join(sentiment_Q202_SFS)

# save to file
write.csv(SFS_Q202_multisentiment, file = "SFS_Q202_multisentiment.csv", row.names = FALSE)

# for Q203 response
sentiment_Q203_SFS <- tidy_Q203 %>%
  inner_join(nrc) %>%
  group_by(ID, sentiment) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  mutate(rank = row_number(desc(count))) %>%
  group_by(ID) %>%
  top_n(1, wt = rank) %>%
  select(ID, sentiment)

SFS_Q203_multisentiment <- SFS %>%
  left_join(sentiment_Q203_SFS)

write.csv(SFS_Q203_multisentiment, file = "SFS_Q203_multisentiment.csv", row.names = FALSE)


# final SFS
SFS$sentiment_Q203 <- SFS_Q203_multisentiment$sentiment

SFS$sentiment_Q201 <- SFS_Q201_multisentiment$sentiment
SFS$sentiment_Q202 <- SFS_Q202_multisentiment$sentiment
write.csv(SFS, file = "SFS_multisentiment.csv", row.names = FALSE)


############################
##     SFT
############################
SFT <- read_csv("SFT_2020_cleaned.csv")
SFT$ID <- seq.int(nrow(SFT))

tidy_Q41 <- SFT %>%
  select( ID, Q41) %>%
  unnest_tokens(word, Q41)


tidy_Q51 <- SFT %>%
  select( ID, Q51) %>%
  unnest_tokens(word, Q51)



# we are getting the most dominant sentiment based on all words (unigrams only) in the response
sentiment_Q41_SFT <- tidy_Q41 %>%
  inner_join(nrc) %>%
  group_by(ID, sentiment) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  mutate(rank = row_number(desc(count))) %>%
  group_by(ID) %>%
  top_n(1, wt = rank) %>%
  select(ID, sentiment)


sentiment_Q51_SFT <- tidy_Q51 %>%
  inner_join(nrc) %>%
  group_by(ID, sentiment) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  mutate(rank = row_number(desc(count))) %>%
  group_by(ID) %>%
  top_n(1, wt = rank) %>%
  select(ID, sentiment)


SFT_Q41_multisentiment <- SFT %>%
  left_join(sentiment_Q41_SFT)

SFT_Q51_multisentiment <- SFT %>%
  left_join(sentiment_Q51_SFT)

SFT$sentiment_Q41 <- SFT_Q41_multisentiment$sentiment
SFT$sentiment_Q51 <- SFT_Q51_multisentiment$sentiment
write.csv(SFT, file = "SFT_multisentiment.csv", row.names = FALSE)


