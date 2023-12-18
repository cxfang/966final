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

df_final <- all_subjs %>% 
  select(c(speed, friction, collider_position, response, participant_id, trial_type)) %>% 
  mutate(response = ifelse(response == "f", 1, 0)) %>% 
  group_by(speed, friction, collider_position, participant_id, trial_type) %>% 
  summarise(mean_response = mean(response))

#FAST HIGH
fast_high <- df_final %>% 
  filter(speed == "fast", friction == "high") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'fast', friction == 'high'), by = c('collider_position'))

fast_high %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
    theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/fast_high.png",
       width=3, height=3)

#FAST MED
fast_med <- df_final %>% 
  filter(speed == "fast", friction == "med") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'fast', friction == 'med'), by = c('collider_position'))

fast_med %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/fast_med.png",
       width=3, height=3)

#FAST LOW
fast_low <- df_final %>% 
  filter(speed == "fast", friction == "low") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'fast', friction == 'low'), by = c('collider_position'))

fast_low %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/fast_low.png",
       width=3, height=3)


#MED HIGH
med_high <- df_final %>% 
  filter(speed == "med", friction == "high") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'med', friction == 'high'), by = c('collider_position'))

med_high %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/med_high.png",
       width=3, height=3)

#MED MED
med_med <- df_final %>% 
  filter(speed == "med", friction == "med") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'med', friction == 'med'), by = c('collider_position'))

med_med %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/med_med.png",
       width=3, height=3)

#MED LOW
med_low <- df_final %>% 
  filter(speed == "med", friction == "low") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'med', friction == 'low'), by = c('collider_position'))

med_low %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/med_low.png",
       width=3, height=3)


#SLOW HIGH
slow_high <- df_final %>% 
  filter(speed == "slow", friction == "high") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'slow', friction == 'high'), by = c('collider_position'))

slow_high %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/slow_high.png",
       width=3, height=3)

#SLOW MED
slow_med <- df_final %>% 
  filter(speed == "slow", friction == "med") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'slow', friction == 'med'), by = c('collider_position'))

slow_med %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/slow_med.png",
       width=3, height=3)

#SLOW LOW
slow_low <- df_final %>% 
  filter(speed == "slow", friction == "low") %>% 
  # filter(trial_type == "exp") %>% 
  group_by(collider_position, trial_type) %>% 
  summarise(
    mean_resp = mean(mean_response)
  ) %>% 
  merge(correct_responses %>% filter(speed == 'slow', friction == 'low'), by = c('collider_position'))

slow_low %>% 
  ggplot(aes(x = collider_position, y=mean_resp, color=trial_type)) +
  geom_line(size = 1.5) +
  geom_point(size = 2.5) +
  ylim(0, 1.01) +
  xlim(0, 18) +
  labs(x = NULL, y = NULL) +
  scale_color_manual(values = c('darkblue', 'darkred', 'darkgrey')) +
  theme(
    legend.position = "none",
    axis.text=element_text(size=8)
  )

ggsave("plots/human_data/control/slow_low.png",
       width=3, height=3)


# #SLOW LOW
# slow_low <- df_final %>% 
#   filter(speed == "slow", friction == "low") %>% 
#   filter(trial_type == "exp") %>% 
#   group_by(collider_position) %>% 
#   summarise(
#     mean_resp = mean(mean_response), 
#     stddev = sd(mean_response)
#   ) %>% 
#   merge(correct_responses %>% filter(speed == 'slow', friction == 'low'), by = c('collider_position'))
# 
# slow_low %>% 
#   mutate(color = ifelse(correct_response == 1, 'darkred', 'azure4')) %>% 
#   ggplot(aes(x = collider_position, y=mean_resp, fill=color)) +
#   geom_bar(stat = "identity") +
#   scale_fill_identity() +
#   geom_errorbar(aes(
#     ymin = mean_resp - stddev/sqrt(8), 
#     ymax = mean_resp + stddev/sqrt(8)
#   ), width = 0.1) +
#   ylim(0, 1.01) +
#   xlim(0, 18) +
#   labs(x = NULL, y = NULL) +
#   ggtitle("Slow Velocity / Low Friction") +
#   theme_classic()
# 
# ggsave("plots/human_data/slow_low.png",
#        width=4, height=4)
