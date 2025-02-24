# HackBio Internship Program - February, 2025
# Team-arginine on the stage-2 task
# The group consists of four people, namely:
# Meltem (GitHub: @meltemktn)
# BenAkande (GitHub: @BenAkande123)
# Manav Vaish (GitHub: @manavvaish)
# Favour_Imoniye (GitHub: @Favour-Imoniye)
# GitHub link to the team-arginine repository for stage-2:
# https://github.com/meltemktn/Team-Arginine-HackBio/tree/main/stage-2
# Link to the video submission: https://shorturl.at/s9Au4


# Task Code 2.1: Microbiology

# Part I : Growth Curve of the Knock-Out vs Knock-in Strains

# Load the data
micro_data<-read.csv("https://raw.githubusercontent.com/HackBio-Internship/2025_project_collection/refs/heads/main/Python/Dataset/mcgc.tsv",header = T,sep="\t")

time_points<-micro_data$time # Define time column
time_points

# Extract columns, then sort them in a way that orders them WT vs mutant for each strain

strain_data <- lapply(list(c(2,14,26), # Strain_1_Rep_1 WT
                           c(3,15,27), # Strain_1_Rep_1 mutant
                           c(4,16,28), # Strain_1_Rep_2 WT
                           c(5,17,29), # Strain_1_Rep_2 mutant
                           c(6,18,30), # Strain_2_Rep_1 WT
                           c(7,19,31), # Strain_2_Rep_1 mutant
                           c(8,20,32), # Strain_2_Rep_2 WT
                           c(9,21,33), # Strain_2_Rep_2 mutant
                           c(10,22,34),# Strain_3_Rep_1 WT
                           c(11,23,35),# Strain_3_Rep_1 mutant
                           c(12,24,36),# Strain_3_Rep_2 WT
                           c(13,25,37)),# Strain_3_Rep_2 mutant
                           function(cols) micro_data[, cols]) 


# Name each list of strains

names(strain_data)<-c("Strain_1_Rep_1_wt","Strain_1_Rep_1_mutant",
                      "Strain_1_Rep_2_wt","Strain_1_Rep_2_mutant",
                      "Strain_2_Rep_1_wt","Strain_2_Rep_1_mutant",
                      "Strain_2_Rep_2_wt","Strain_2_Rep_2_mutant",
                      "Strain_3_Rep_1_wt","Strain_3_Rep_1_mutant",
                      "Strain_3_Rep_2_wt","Strain_3_Rep_2_mutant")

# Create the data frame by adding time points first

strain_df <- data.frame(Time = time_points)

# Add means of technical replicates to the data frame

for (i in 1:length(strain_data)) {
  strain_df[[names(strain_data)[i]]] <- rowMeans(strain_data[[i]], na.rm = TRUE)
}

# Start plotting !


# Set plot layout to be larger 

options(repr.plot.width = 10, repr.plot.height = 8) # Increase the width and height for a larger plot

# Specify a layout for multiple plots

par(mfrow = c(3,2), mar = c(5,4,2,3))  # 3 rows for each strains, 2 columns for each biological replicate 
# Depending on your setup, you can change the margins and the plot size!


# Plot for Strain_1_Rep 1 WT vs knock-out

plot(strain_df$Time, strain_df$Strain_1_Rep_1_wt, type = "l", col = "blue",
     xlab = "Time (mins)", ylab = "OD600", main = "Strain_1_Rep_1 WT vs KO", lty = 1, ylim = c(0, max(strain_df[,-1], na.rm = TRUE)))
lines(strain_df$Time, strain_df$Strain_1_Rep_1_mutant, col = "red", lty = 2) # Add lines for Strain_1_Rep_1_mutant

# Add legend to Strain_1_Rep_1 plot

legend("bottomright", legend = c("WT", "KO"), col = c("blue", "red"), lty = c(1, 2), cex = 0.9)

# Plot for Strain_1_Rep_2 WT vs knock-out

plot(strain_df$Time, strain_df$Strain_1_Rep_2_wt, type = "l", col = "blue",
     xlab = "Time (mins)", ylab = "OD600", main = "Strain_1_Rep_2 WT vs KO", lty = 1, ylim = c(0, max(strain_df[,-1], na.rm = TRUE)))
lines(strain_df$Time, strain_df$Strain_1_Rep_2_mutant, col = "red", lty = 2)

# Add legend to Strain_1_Rep_2 plot

legend("bottomright", legend = c("WT", "KO"), col = c("blue", "red"), lty = c(1, 2), cex = 0.9)


# Plot for Strain_2_Rep_1 WT vs knock-out

plot(strain_df$Time, strain_df$Strain_2_Rep_1_wt, type = "l", col = "green",
     xlab = "Time (mins)", ylab = "OD600", main = "Strain_2_Rep_1 WT vs KO", lty = 3, ylim = c(0, max(strain_df[,-1], na.rm = TRUE)))
lines(strain_df$Time, strain_df$Strain_2_Rep_1_mutant, col = "purple", lty = 4)

# Add legend to Strain_2_Rep_1 plot

legend("bottomright", legend = c("WT", "KO"), col = c("green", "purple"), lty = c(3, 4), cex = 0.9)


# Plot for Strain_2_Rep_2 WT vs knock-out

plot(strain_df$Time, strain_df$Strain_2_Rep_2_wt, type = "l", col = "green",
     xlab = "Time (mins)", ylab = "OD600", main = "Strain_2_Rep_2 WT vs KO", lty = 3, ylim = c(0, max(strain_df[,-1], na.rm = TRUE)))
lines(strain_df$Time, strain_df$Strain_2_Rep_2_mutant, col = "purple", lty = 4)

# Add legend to Strain_2_Rep_2 plot

legend("bottomright", legend = c("WT", "KO"), col = c("green", "purple"), lty = c(3, 4), cex = 0.9)


# Plot for Strain_3_Rep_1 WT vs knock-out

plot(strain_df$Time, strain_df$Strain_3_Rep_1_wt, type = "l", col = "cyan",
     xlab = "Time (mins)", ylab = "OD600", main = "Strain_3_Rep_1 WT vs KO", lty = 5, ylim = c(0, max(strain_df[,-1], na.rm = TRUE)))
lines(strain_df$Time, strain_df$Strain_3_Rep_1_mutant, col = "orange", lty = 6)

# Add legend to Strain_3_Rep_1 plot

legend("bottomright", legend = c("WT", "KO"), col = c("cyan", "orange"), lty = c(5, 6), cex = 0.9)


# Plot for Strain_3_Rep_2 WT vs knock-out

plot(strain_df$Time, strain_df$Strain_3_Rep_2_wt, type = "l", col = "cyan",
     xlab = "Time (mins)", ylab = "OD600", main = "Strain_3_Rep_2 WT vs KO", lty = 5, ylim = c(0, max(strain_df[,-1], na.rm = TRUE)))
lines(strain_df$Time, strain_df$Strain_3_Rep_2_mutant, col = "orange", lty = 6)

# Add legend to Strain_3_Rep_2 plot

legend("bottomright", legend = c("WT", "KO"), col = c("cyan", "orange"), lty = c(5, 6), cex = 0.9)


# After plotting, reset the plot layout to a single plot

par(mfrow = c(1, 1)) # This returns to a single plot layout


# Part II: Determine the time it takes to reach the carrying capacity for each strain

# Modify the previous function based on the current dataset

carrying_capacity<-function(final_od,time_points,od_values) {
  target_od <- final_od*0.8 # Calculates 80% of the final OD (representing the carrying capacity)
  time_for_capacity<-time_points[min(which(od_values>=target_od))] # Identify the point at which OD value reaches or exceeds the target OD
}

# Apply the function across all the strains

for (i in 2:ncol(strain_df)) {  # Skip the time column
  final_od<-max(strain_df[[i]])
  result<-carrying_capacity(final_od,strain_df$Time,strain_df[[i]])
  print(paste("Time it takes to reach the carrying capacity for",colnames(strain_df)[i],"is",result,"minutes"))
}

# Part III: Generating a scatterplot and a boxplot 


# Create a dataframe 

capacity_df <- data.frame(Strain = colnames(strain_df)[-1])  # Exclude the first column (Time)

# Define empty column named OD_capacity

capacity_df$OD_capacity <- NA 

for (i in 2:ncol(strain_df)) {  # Skip the time column
  final_od <- max(strain_df[[i]])
  result <- carrying_capacity(final_od, strain_df$Time, strain_df[[i]])
  capacity_df$OD_capacity[i - 1] <- result  # Store the result
}

# Display the updated dataframe to verify

print(capacity_df)


# Define the strain names for categorization

wt_strains<-c("Strain_1_Rep_1_wt","Strain_1_Rep_2_wt",
              "Strain_2_Rep_1_wt","Strain_1_Rep_2_wt",
              "Strain_3_Rep_1_wt","Strain_3_Rep_2_wt")

ko_strains<-c("Strain_1_Rep_1_mutant","Strain_1_Rep_2_mutant",
              "Strain_2_Rep_1_mutant","Strain_1_Rep_2_mutant",
              "Strain_3_Rep_1_mutant","Strain_3_Rep_2_mutant")

# Extract the capacities for each strain

wt_capacities<-capacity_df[capacity_df$Strain %in% wt_strains,"OD_capacity"]
ko_capacities<-capacity_df[capacity_df$Strain %in% ko_strains,"OD_capacity"]

# Perform t-test

t_test_result<-t.test(wt_capacities,ko_capacities)

# View results

t_test_result$statistic # t-value
t_test_result$parameter # df
t_test_result$p.value #statistical significance
t_test_result$estimate #means of two groups (wild-type vs knock-out strains)
t_test_result$conf.int # confidence interval

# Calculate the mean and confidence intervals for wild-type and knock-out

wt_mean<-t_test_result$estimate[1] # wild-type mean
ko_mean<-t_test_result$estimate[2] # knock-out mean


# Create a scatter plot

plot(1:2, # view the means only (two values for wild-type and knock-out means)
     t_test_result$estimate,# means of wild-type and knock-out
     pch=19,xaxt="n",col=c("green","purple"),
     xlab="Strain",ylab="Time to reach the carrying capacity (mins)",
     ylim=range(strain_df$Time),cex=1.5,
     main="Wild-type vs knock-out strains carrying capacity") 

# Add x-axis labels
axis(1, at = 1:2, labels = c("Wild type (1-3)", "Mutant (1-3)"))

# Calculate confidence intervals 

wt_std_err<-sd(wt_capacities,na.rm = TRUE)/sqrt(length(wt_capacities)) # Standard error of wild-type means
ko_std_err<-sd(ko_capacities,na.rm = TRUE)/sqrt(length(ko_capacities)) # Standard error of knock-out means
critical_t_value<-qt(0.975, df = t_test_result$parameter) # Critical t-value (for 95% confidence interval, t-percentile is 0.975)
wt_conf_interval<-c(wt_std_err-(critical_t_value*wt_std_err),wt_std_err+(critical_t_value*wt_std_err))
ko_conf_interval<-c(ko_std_err-(critical_t_value*ko_std_err),ko_std_err+(critical_t_value*ko_std_err))

# Add confidence intervals as error bars

arrows(x0 = 1, y0 = wt_conf_interval[1], x1 = 1, y1 = wt_conf_interval[2], 
       angle = 90, code = 3, col = "green", length = 0.1)  # wild-type CI
arrows(x0 = 2, y0 = ko_conf_interval[1], x1 = 2, y1 = ko_conf_interval[2], 
       angle = 90, code = 3, col = "purple", length = 0.1)  # mutant CI

# Annotate the results

text(1.5, max(t_test_result$estimate) + 0.1 * diff(range(t_test_result$estimate)), 
     labels = paste("t =", round(t_test_result$statistic, 2), 
                    ", p =", format.pval(t_test_result$p.value, digits = 3)), 
     cex = 0.9)


# Create a box plot


# Construct a list of wild-type and knock-out carrying capacities

boxplot_data<-list("Wild-type (1-3)"= wt_capacities, "Mutant (1-3)"=ko_capacities)

# Define y-axis range and intervals

y_min <- floor(min(c(wt_capacities, ko_capacities), na.rm = TRUE) / 50) * 50
y_max <- ceiling(max(c(wt_capacities, ko_capacities), na.rm = TRUE) / 50) * 50
y_intervals <- seq(y_min, y_max, by = 50)

# Add custom y-axis with intervals

axis(2, at = y_intervals, las = 1, cex.axis = 0.9)  # Horizontal labels (las: Label of axis style)

# Create the plot 

boxplot(boxplot_data,
        xlab="Strain",
        ylab="Time to reach the carrying capacity (mins)",
        ylim=c(y_min,y_max),
        main="Wild type vs knock-out strains carrying capacity",
        notch=FALSE # in case you'd like to add the median
        
     )

# Annotate with t-test results

text(1.5, y_max - 0.05 * (y_max - y_min), # For legibility
     labels = paste("t =", round(t_test_result$statistic, 2), 
                    ", p =", format.pval(t_test_result$p.value, digits = 3)), 
     cex = 0.9)



# The verdict:

# Based on the t-test results and the graphs, 
# there is no statistical difference between the time it takes for the wild-type and knock-out strains.
# Therefore, we cannot reject the null hypothesis.
