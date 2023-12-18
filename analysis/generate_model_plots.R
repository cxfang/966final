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
  select(c(speed, friction, collider_position, response, participant_id, trial_type)) %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  group_by(speed, friction, collider_position, participant_id, trial_type) %>% 
  summarise(mean_response = mean(response)) %>% 
  merge(m3_data, by=c('speed', 'friction', 'collider_position')) %>% 
  merge(m2_data, by=c('speed', 'friction', 'collider_position')) %>% 
  merge(m1_data, by=c('speed', 'friction', 'collider_position')) %>% 
  filter(trial_type == "exp") %>% 
  group_by(collider_position,m1_preds, m2_preds, m3_preds, friction, speed) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>%
  # merge(correct_responses %>% filter(speed == 'fast', friction == 'high'), by = c('collider_position')) %>%
  rename(
    "Model 1" = m1_preds,
    "Model 2" = m2_preds,
    "Model 3" = m3_preds,
    "Human" = mean_resp
  ) %>%
  pivot_longer(
    cols = c("Model 1", "Model 2", "Model 3", "Human"),
    names_to = "type",
    values_to = "preds"
  )

#FAST HIGH
df_final %>% 
  filter(speed == "fast", friction == "high") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
    )

ggsave("plots/compare_models/fast_high.png",
       width=3, height=3)

#FAST MED
df_final %>% 
  filter(speed == "fast", friction == "med") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/compare_models/fast_med.png",
       width=3, height=3)

#FAST LOW
df_final %>% 
  filter(speed == "fast", friction == "low") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/compare_models/fast_low.png",
       width=3, height=3)

#MED HIGH
df_final %>% 
  filter(speed == "med", friction == "high") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/compare_models/med_high.png",
       width=3, height=3)

#MED MED
df_final %>% 
  filter(speed == "med", friction == "med") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/compare_models/med_med.png",
       width=3, height=3)

#MED LOW
df_final %>% 
  filter(speed == "med", friction == "low") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/compare_models/med_low.png",
       width=3, height=3)

#SLOW HIGH
df_final %>% 
  filter(speed == "slow", friction == "high") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/compare_models/slow_high.png",
       width=3, height=3)

#SLOW MED
df_final %>% 
  filter(speed == "slow", friction == "med") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/compare_models/slow_med.png",
       width=3, height=3)

#SLOW LOW
df_final %>% 
  filter(speed == "slow", friction == "low") %>% 
  ggplot(aes(x = collider_position, y=preds, color=type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkgrey', 'darkred', 'darkblue', 'darkgreen' )) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/compare_models/slow_low.png",
       width=3, height=3)


# #SLOW LOW
# slow_low <- df_final %>% 
#   filter(speed == "slow", friction == "low") %>% 
#   filter(trial_type == "exp") %>% 
#   group_by(collider_position, model_prediction) %>% 
#   summarise(
#     mean_resp = mean(mean_response)
#   ) %>% 
#   merge(correct_responses %>% filter(speed == 'slow', friction == 'low'), by = c('collider_position')) %>% 
#   select(c(collider_position, model_prediction, mean_resp)) %>% 
#   pivot_longer(
#     cols = c(model_prediction, mean_resp),
#     names_to = "type",
#     values_to = "preds"
#   )
# 
# slow_low %>% 
#   ggplot(aes(x = collider_position, y=preds, color=type)) +
#   geom_line(size = 1.5) +
#   geom_point(size = 2.5) +
#   ylim(0, 1.01) +
#   xlim(0, 18) +
#   labs(x = NULL, y = NULL) +
#   scale_color_manual(values = c('darkgrey', 'darkred')) +
#   theme(
#     legend.position = "none",
#     axis.text=element_text(size=8)
#   )
# 
# ggsave("plots/compare_models/slow_low.png",
#        width=3, height=3)
