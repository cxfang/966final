library(tidyverse)
library(rstudioapi)
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



all_subjs <- read_csv('data_cleaned/all_subjs.csv')

correct_responses = read_csv('collision_correct_responses.csv')
m1_data <- read_csv("model_data/model1/m1_noise0.1.csv") %>% 
  rename(m1_preds = model_prediction)

m2_data <- read_csv("model_data/model2/m2_fr0.1_vel0.05.csv") %>% 
  rename(m2_preds = model_prediction)

m3_data <- read_csv("model_data/model3/m3_fr0.1_vel0.05_col0.15.csv") %>% 
  rename(m3_preds = model_prediction)

df_final <- all_subjs %>% 
  filter(trial_type == "exp") %>%
  select(c(speed, friction, collider_position, response, participant_id)) %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  group_by(speed, friction, collider_position, participant_id) %>% 
  summarise(mean_response = mean(response)) %>% 
  merge(m3_data, by=c('speed', 'friction', 'collider_position')) %>% 
  merge(m2_data, by=c('speed', 'friction', 'collider_position')) %>% 
  merge(m1_data, by=c('speed', 'friction', 'collider_position')) %>%
  merge(correct_responses, by = c('collider_position', 'speed', 'friction')) %>%
  group_by(collider_position,m1_preds, m2_preds, m3_preds, friction, speed) %>% 
  summarise(
    mean_resp = mean(mean_response)
  )


m1_corr = cor.test(df_final$mean_resp, df_final$m1_preds)
m2_corr = cor.test(df_final$mean_resp, df_final$m2_preds)
m3_corr = cor.test(df_final$mean_resp, df_final$m3_preds)

df_final %>% 
  ggplot(
    aes(x = m1_preds, y = mean_resp)
  ) +
  geom_jitter(
    shape = 3,
    width = 0.01,
    height = 0
    ) +
  geom_smooth(method='lm') +
  xlab("Model 1 Prediction") +
  ylab("Human Prediction") +
  annotate("text", x = 0.6, y= 0.15, label = "r = 0.83", color = "blue") +
  theme_classic()

ggsave("plots/compare_models/m1_corr.png",
       width=3, height=3)

df_final %>% 
  ggplot(
    aes(x = m2_preds, y = mean_resp)
  ) +
  geom_jitter(
    shape = 3,
    width = 0.01,
    height = 0
  ) +
  geom_smooth(method='lm') +
  xlab("Model 2 Prediction") +
  ylab("Human Prediction") +
  annotate("text", x = 0.6, y= 0.15, label = "r = 0.86", color = "blue") +
  theme_classic()

ggsave("plots/compare_models/m2_corr.png",
       width=3, height=3)


df_final %>% 
  ggplot(
    aes(x = m3_preds, y = mean_resp)
  ) +
  geom_jitter(
    shape = 3,
    width = 0.01,
    height = 0
  ) +
  geom_smooth(method='lm') +
  xlab("Model 3 Prediction") +
  ylab("Human Prediction") +
  annotate("text", x = 0.6, y= 0.15, label = "r = 0.85", color = "blue") +
  theme_classic()


ggsave("plots/compare_models/m3_corr.png",
       width=3, height=3)
