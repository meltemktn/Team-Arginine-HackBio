# HackBio Internship Program - February, 2025
# Team-arginine on the stage-2 task
# The group consists of four people, namely:
# Meltem (GitHub: @meltemktn)
# BenAkande (GitHub: @BenAkande123)
# Manav Vaish (GitHub: @manavvaish)
# Favour_Imoniye (GitHub: @Favour-Imoniye)
# GitHub link to the team-arginine repository for stage-2:
# https://github.com/meltemktn/Team-Arginine-HackBio/tree/main/stage-2library(dplyr)
# Link to the video submission: https://tinyurl.com/2xa2xpm3


# Task Code 2.3: Botany and Plant Science

# Load the libraries and the data

library(ggplot2)
library(tidyr)
data_url <- 'https://raw.githubusercontent.com/HackBio-Internship/2025_project_collection/refs/heads/main/Python/Dataset/Pesticide_treatment_data.txt'
data <- read.table(data_url, header = TRUE, sep = "\t", row.names = 1)

# Extract relevant columns for WT and Mutant

wt_dmso <- data %>% filter(grepl("WT_DMSO", rownames(data)))
wt_24h <- data %>% filter(grepl("WT_pesticide_24h", rownames(data)))
mutant_dmso <- data %>% filter(grepl("mutant_DMSO", rownames(data)))
mutant_24h <- data %>% filter(grepl("mutant_pesticide_24h", rownames(data)))
delta_M_wt <- wt_24h - wt_dmso
delta_M_mutant <- mutant_24h - mutant_dmso
delta_M <- data.frame(
  WT = as.numeric(delta_M_wt),
  Mutant = as.numeric(delta_M_mutant)
)
delta_M$Residual <- delta_M$Mutant - delta_M$WT
residual_cutoff <- 0.3
delta_M$Residual_Color <- ifelse(
  abs(delta_M$Residual) <= residual_cutoff, "Within Cutoff", "Outside Cutoff"
)

# Start plotting 

ggplot(delta_M, aes(x = WT, y = Mutant, color = Residual_Color)) +
  geom_point(size = 3) +  # Scatter plot points
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +  # y = x line
  scale_color_manual(values = c("Within Cutoff" = "grey", "Outside Cutoff" = "salmon")) +  # Color mapping
  labs(
    title = "Difference in Metabolic Response (ΔM)",
    x = "ΔM (WT)",
    y = "ΔM (Mutant)",
    color = "Residual Cutoff"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12)
  )
ggsave("delta_M_residual_plot.png", width = 8, height = 6, dpi = 300)

# Define the outliers 

outliers <- delta_M[abs(delta_M$Residual) > residual_cutoff, ]
outlier_metabolites <- rownames(outliers)[1:6]  # Select the first 6 metabolites
metabolite_data <- data[outlier_metabolites, ]
plot_data <- data.frame(
  Metabolite = rep(outlier_metabolites, each = 6),
  Time = rep(c("0h", "8h", "24h"), times = 2 * length(outlier_metabolites)),
  Treatment = rep(c("WT", "Mutant"), each = 3, times = length(outlier_metabolites)),
  Value = as.numeric(t(metabolite_data))
)
ggplot(plot_data, aes(x = Time, y = Value, color = Treatment, group = Treatment)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  facet_wrap(~ Metabolite, scales = "free_y") +
  labs(
    title = "Metabolite Levels Over Time (0h, 8h, 24h)",
    x = "Time",
    y = "Metabolite Level"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    strip.text = element_text(size = 12, face = "bold")
  )

# Save the plot 

ggsave("metabolite_line_plots.png", width = 10, height = 8, dpi = 300)


# Findings: Some metabolites show distinct responses in mutants, hinting at potential metabolic shifts linked to pesticide resistance.