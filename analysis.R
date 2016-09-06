require(ggplot2)
require(dplyr)

results <- read.csv("results.csv")
results_summary <- results %>% group_by(CAP) %>% summarise(mean_time = mean(time))
ggplot(results_summary, aes(CAP, mean_time)) + geom_line()

