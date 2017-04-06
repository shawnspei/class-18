#!/usr/bin/env Rscript

#load tidyverse packages
library(readr)
library(dplyr)
library(ggplot2)
library(cowplot)

args <- commandArgs(trailingOnly = TRUE)
input <- args[1]
output <- args[2]

cols <- c('chrom', 'start', 'end', 'name', 'window', 'value')
# col_names specifies the column names
# col_types specifies the column types (sometimes necessary for proper data import)
# c = character, i = integer, d = numeric
df <- read_tsv(input, col_names = cols, col_types = 'ccccid')

# use dplyr group_by  to calculate mean coverage over each window
coverage <- df %>%
  group_by(window) %>%
  summarize(mean_coverage = mean(value))

# reformat axis to be centered at zero rather than 400
coverage$window = seq(-400, 400)

plot <- ggplot(coverage, aes(window, mean_coverage)) +
  geom_point() +
  theme_cowplot()

ggsave(output, plot)

