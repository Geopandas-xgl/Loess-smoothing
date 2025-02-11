# Clear the workspace
rm(list = ls())

# Install and load required packages
if(!require('openxlsx')) {install.packages('openxlsx'); library(openxlsx)}
if(!require('msir')) {install.packages('msir'); library(msir)}
if(!require('ggplot2')) {install.packages('ggplot2'); library(ggplot2)}

# Set the working directory (update to your path)

setwd("C:/Users/19328/Documents/github/R-code/Loess/Template_horizontal")

# Define section name and file name (update as needed)
section <- "PTB_dU"
file_name  <- "Zhang-2018-Geology";

# Load data from Excel file (update file name)
data_raw <- read.xlsx(paste0(file_name,".xlsx"), sheet = section)

# Rename columns for clarity (update column name)
colnames(data_raw)[colnames(data_raw) == "dU"] <- "delta"
colnames(data_raw)[colnames(data_raw) == "age"] <- "series"


# Split data into four subsets (update group numbers and row indices as needed)
data1 <- data_raw[1:36,]
data2 <- data_raw[37:50,]
data3 <- data_raw[51:67,]
data4 <- data_raw[68:83,]

# Sort data by age in descending and ascending order
data_sorted_des <- data_raw[order(-data_raw$series),]
data_sorted_as <- data_raw[order(data_raw$series),]

# Extract numeric data from columns
Label <- data_sorted_des$label
delta <- as.numeric(data_sorted_des$delta)
series <- as.numeric(data_sorted_des$series)

# Loess smoothing parameters (adjustable)
span <- 0.61  # Smoothing span
nsigma <- 2  # Number of standard deviations for confidence interval

# Perform loess smoothing
loess_mod <- loess.sd(delta ~ series, span = span, nsigma = nsigma)

# Add upper and lower confidence intervals
loess_mod$upper <- loess_mod$y + loess_mod$sd
loess_mod$lower <- loess_mod$y - loess_mod$sd

# Add smoothed data into input data
data_loess <- cbind(
  data_sorted_as,
  X_loess= loess_mod$x,
  Y_loess = loess_mod$y,
  upper = loess_mod$upper,
  lower = loess_mod$lower)

# Creature a fold named by section to save smoothed data to an Excel file
dir.create(paste0(gsub("\\s+", "_", section)), showWarnings = TRUE, recursive = FALSE)

output_path <- paste0(gsub("\\s+", "_", section), "/", gsub("\\s+", "_", section), "_", gsub("\\s+", "_", span), "_loess.xlsx")
write.xlsx(data_loess, output_path, row.names = FALSE)

# Add labels to subsets for the legend (update your labels)
data1$label <- "Dawen"
data2$label <- "Dajiang"
data3$label <- "Kamura"
data4$label <- "Taskent"

# Plot data with smoothed loess fit
plot <- ggplot(data_loess, aes(x = X_loess)) +
  geom_ribbon(aes(ymin = lower, ymax = upper), fill = "#AED6E1", alpha = 0.7) +  # Confidence interval
  geom_line(aes(y = Y_loess), color = "#3799B5", linewidth = 0.7) +  # Loess fit
  geom_point(data = data1, aes(x = series, y = delta, fill = label), shape = 21, size = 1.8) +  # Data points (subset 1)
  geom_point(data = data2, aes(x = series, y = delta, fill = label), shape = 21, size = 1.8) +  # Data points (subset 2)
  geom_point(data = data3, aes(x = series, y = delta, fill = label), shape = 21, size = 1.8) +  # Data points (subset 3)
  geom_point(data = data4, aes(x = series, y = delta, fill = label), shape = 21, size = 1.8) +  # Data points (subset 4)
  # update your breaks and labels, Notice: the decimal point of number in marker is equal to that in labels  
  scale_x_reverse(name = "Age (Ma)", limits = c(252.45, 251.5), breaks = round(seq(252.4, 251.5, by = -0.1),digits=1), labels = function(x) ifelse(x %in% c(252.4, 252.2, 252.0, 251.8, 251.6), as.character(x), "")) +
  scale_y_continuous(name = expression(delta^{238}*"U (\u2030)"), limits = c(-1, 0.3), breaks = round(seq(-1, 0.3, by = 0.1),digits=1), labels = function(y) ifelse(y %in% c(-1.0, -0.6, -0.2, 0.2), as.character(y), "")) +
  scale_fill_manual(values = c("Dawen" = "#009392", "Dajiang" = "#9CCB86","Kamura"="#EEB479","Taskent"="#CF597E")) + # set filled color of marker (update your colors and labels)
  theme_minimal(base_size = 15) +
    theme(
      panel.grid = element_blank(),
      panel.background = element_rect(fill = "white"),
      plot.background = element_rect(fill = "white"),
      axis.title.x = element_text(margin = margin(t = 8), size = 12),  # Slightly increase distance from x-axis label
      axis.title.y = element_text(margin = margin(r = 8), size = 12),  # Slightly increase distance from y-axis label
      axis.text.x = element_text(size = 10,color = "black"),  # Decrease font size of x-axis labels
      axis.text.y = element_text(size = 10,color = "black"),  # Decrease font size of y-axis labels
      panel.border = element_blank(),  # Hide the border of the figure
      axis.ticks = element_line(linewidth = 0.4),
      axis.ticks.length = unit(0.2, "cm"),
      plot.title = element_text(size = 12, hjust = 0.5),  # Center-align the title and reduce font size
      legend.position = c(0.85, 0.85),
      legend.title = element_blank(),  # Hide the legend title
      legend.text = element_text(size = 10),  # Decrease font size of legend text
      legend.key.size = unit(0.4, "cm"),  # Decrease the width and height of legend space
      legend.background = element_blank()
    ) +
    ggtitle(paste0(gsub("\\s+", "_", section), "_span_", round(span, 3), "_sigma_", round(nsigma, 1)))
  
  # Save the plot as PNG and PDF
  ggsave(paste0(gsub("\\s+", "_", section),"/", file_name,"_", gsub("\\s+", "_", section), "_", gsub("\\s+", "_", span), ".png"), plot = plot, width = 6, height = 3, dpi = 800, bg = "white")
  ggsave(paste0(gsub("\\s+", "_", section), "/",file_name,"_", gsub("\\s+", "_", section), "_", gsub("\\s+", "_", span), ".pdf"), plot = plot, width = 6, height = 3, dpi = 800, device = cairo_pdf, bg = "white")
