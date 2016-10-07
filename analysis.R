require(ggplot2)
require(dplyr)

results <- read.csv("results.csv")
results <- results %>% group_by(CAP) %>% arrange(-time) %>% mutate(normalized_time = (time - min(time))/ (max(time) - min(time)))

results_summary <- results %>% group_by(CAP) %>% summarise(mean_time = mean(time))
results_sd <- results %>% group_by(CAP) %>% summarise(sd = sd(time))
results_sd$mean <- results_summary$mean_time
results_sd_normalized <- results %>% group_by(CAP) %>% summarise(sd = sd(normalized_time))

ggplot(results_summary, aes(CAP, mean_time)) + geom_line()
ggplot(results_summary %>% filter(CAP >= 50), aes(CAP, mean_time)) + geom_line()
ggplot(results_sd_normalized, aes(CAP, sd)) + geom_line()

results_summary <- results_summary %>% mutate(performance_loss = c(-diff(results_summary$mean_time)/results_summary$mean_time[2:length(results_summary$mean_time)],0))

results_summary <- results_summary %>% mutate(performance_loss2 = mean_time*CAP/100.0)
ggplot(results_summary, aes(CAP, performance_loss2)) + 
  geom_line() + 
  ylab("Performance loss = mean time * cap") +
  ggtitle("Performance X CAP")

ggsave("cpucap.png")
