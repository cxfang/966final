library(tidyverse)
library(rstudioapi)
# library(brms)
# library(bayestestR)
# library(bayesplot)
# library(sjPlot)
## Set plotting preferences
ggplot2::theme_set(ggplot2::theme_bw(base_size=18))
ggplot2::theme_update(panel.grid = ggplot2::element_blank(), 
                      strip.background = ggplot2::element_blank(),
                      legend.key = ggplot2::element_blank(),
                      panel.border = ggplot2::element_blank(),
                      axis.line = ggplot2::element_line(),
                      strip.text = ggplot2::element_text(face = "bold"),
                      plot.title = element_text(hjust = 0.5))
options(ggplot2.discrete.colour= c("#A31F34", "#8A8B8C"))

## Set function defaults
filter <- dplyr::filter
group_by <- dplyr::group_by
summarize <- dplyr::summarize
select <- dplyr::select

## Set working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$`path`))

data <- read_csv("data/session-657f6bfb51682.csv") %>%
  filter(trial_type == "video-keyboard-response") %>%
  select(c(trial_index, rt, stimulus, response)) %>% 
  separate(
    col = "stimulus",
    into = c("bye", "stimulus"),
    sep = "/"
  ) %>% 
  select(-c(bye))

data$stimulus <- gsub('.mov"]', "", data$stimulus)

data_cleaned <- data %>% 
  separate(
    col = "stimulus",
    into = c("speed", "friction", "collider_position", "color", "mirror"),
    sep = "_"
  ) %>% 
  mutate(participant_id = "657f6bfb51682")

data_cleaned$collider_position <- gsub('c', "", data_cleaned$collider_position)

data_cleaned <- data_cleaned %>%
  mutate(trial_type = case_when(
    trial_index < 138 ~ "control1",
    trial_index >= 138 & trial_index < 434 ~ "exp",
    trial_index >= 434 ~ "control2"
  ))

# data_cleaned <- data_cleaned %>% 
#   mutate(trial_type = case_when(
#     trial_index < 15 ~ "control1",
#     trial_index >= 15 & trial_index < 311 ~ "exp",
#     trial_index >= 311 ~ "control2"
#   ))

write.csv(data_cleaned, "data_cleaned/subj9.csv", row.names=FALSE)


#combine into one file
subj1 <- read_csv("data_cleaned/subj1.csv")
subj2 <- read_csv("data_cleaned/subj2.csv")
subj3 <- read_csv("data_cleaned/subj3.csv")
subj4 <- read_csv("data_cleaned/subj4.csv")
subj5 <- read_csv("data_cleaned/subj5.csv")
subj6 <- read_csv("data_cleaned/subj6.csv")
subj7 <- read_csv("data_cleaned/subj7.csv")
subj8 <- read_csv("data_cleaned/subj8.csv")
subj9 <- read_csv("data_cleaned/subj9.csv")

all_subjs <- rbind(subj1, subj2, subj3, subj4, subj5, subj6, subj7, subj8, subj9)

correct_responses = read_csv('collision_correct_responses.csv')

all_subjs <- all_subjs %>% 
  merge(correct_responses, by = c('speed', 'friction', 'collider_position'))

write.csv(all_subjs, "data_cleaned/all_subjs.csv", row.names=FALSE)

accuracy_by_friction <- all_subjs %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  mutate(resp_correct = ifelse(response == correct_response, 1, 0)) %>% 
  group_by(friction) %>% 
  summarise(percent_correct = mean(resp_correct))

accuracy_by_speed <- all_subjs %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  mutate(resp_correct = ifelse(response == correct_response, 1, 0)) %>% 
  group_by(speed, participant_id) %>% 
  summarise(percent_correct = mean(resp_correct))

speed_t_test <- t.test(percent_correct ~ speed, accuracy_by_speed %>% filter(speed != "med"))

accuracy <- all_subjs %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  mutate(resp_correct = ifelse(response == correct_response, 1, 0)) %>% 
  group_by(trial_type, participant_id) %>% 
  summarise(percent_correct = mean(resp_correct))

condition_t_test <- t.test(percent_correct ~ trial_type, accuracy %>% filter(trial_type != "control2"))

accuracy_by_condition <- all_subjs %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  mutate(resp_correct = ifelse(response == correct_response, 1, 0)) %>% 
  group_by(trial_type) %>% 
  summarise(percent_correct = mean(resp_correct))

accuracy_by_condition_and_speed <- all_subjs %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  mutate(resp_correct = ifelse(response == correct_response, 1, 0)) %>% 
  group_by(trial_type, speed) %>% 
  summarise(percent_correct = mean(resp_correct))

accuracy_by_condition_and_friction <- all_subjs %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  mutate(resp_correct = ifelse(response == correct_response, 1, 0)) %>% 
  group_by(trial_type, friction) %>% 
  summarise(percent_correct = mean(resp_correct))

accuracy_by_participant <- all_subjs %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  mutate(resp_correct = ifelse(response == correct_response, 1, 0)) %>% 
  group_by(participant_id) %>% 
  summarise(percent_correct = mean(resp_correct))


accuracy_by_speed_and_friction <- all_subjs %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  mutate(resp_correct = ifelse(response == correct_response, 1, 0)) %>% 
  group_by(friction, speed) %>% 
  summarise(
    percent_correct = mean(resp_correct), 
    se = sd(resp_correct)/sqrt(9))



#LOAD MODEL DATA

m1_fast_high <- read_csv('model_data/model1/fast_high_noise0.1.csv')
m1_fast_med <- read_csv('model_data/model1/fast_med_noise0.1.csv')
m1_fast_low <- read_csv('model_data/model1/fast_low_noise0.1.csv')
m1_med_high <- read_csv('model_data/model1/med_high_noise0.1.csv')
m1_med_med <- read_csv('model_data/model1/med_med_noise0.1.csv')
m1_med_low <- read_csv('model_data/model1/med_low_noise0.1.csv')
m1_slow_high <- read_csv('model_data/model1/slow_high_noise0.1.csv')
m1_slow_med <- read_csv('model_data/model1/slow_med_noise0.1.csv')
m1_slow_low <- read_csv('model_data/model1/slow_low_noise0.1.csv')

m1_data <- rbind(m1_fast_high, m1_fast_med, m1_fast_low, 
                 m1_med_high, m1_med_med, m1_med_low, 
                 m1_slow_high, m1_slow_med, m1_slow_low)

write.csv(m1_data, "model_data/model1/m1_noise0.1.csv", row.names=FALSE)


