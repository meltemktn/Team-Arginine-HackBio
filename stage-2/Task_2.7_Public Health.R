# HackBio Internship Program - February, 2025
# Task 2.7(Public Health) submission under the stage-2 task by Favour Imoniye (Team-arginine)
# Team-arginine  consists of four people, namely:
# Meltem (GitHub: @meltemktn)
# BenAkande (GitHub: @BenAkande123)
# Manav Vaish (GitHub: @manavvaish)
# Favour_Imoniye (GitHub: @Favour-Imoniye)
# GitHub link to the task  2.7 code for stage-2:

# Install data visualization packages
install.packages("ggplot2", dependencies = c("Depends","Imports"),lib= .libPaths()[1])
install.packages(c("pillar","colorspace","scales","tibble" , "rlang"),lib= .libPaths()[1])
install.packages("gridExtra", dependencies = FALSE, lib= .libPaths()[1])

library(gridExtra, lib.loc= .libPaths() [1] )
library(ggplot2, lib.loc= .libPaths() [1] )
# Import dataset
nhanes_data <- read.csv("https://raw.githubusercontent.com/HackBio-Internship/public_datasets/main/R/nhanes.csv", header = TRUE)

# Check the dimensions of the data and the distribution of missing values
dim(nhanes_data)
colSums(is.na(nhanes_data))
sum(!complete.cases(nhanes_data))

# Handle missing data
nhanes_num <- c("Income", "Poverty", "HomeRooms", "BMI", "BPSys", "BPDia", "Height", "Weight", "Pulse",
              "Testosterone", "HDLChol", "PhysActiveDays", "AlcoholDay", "AlcoholYear", "TotChol",
              "DiabetesAge", "nPregnancies", "nBabies", "SleepHrsNight")

nhanes_data[nhanes_num] <- lapply (nhanes_data[nhanes_num],
                                   function(x)
  ifelse(is.na(x), 0,x))  #Convert all missing numerical values to 0


nhanes_cat <- c("Education", "MaritalStatus", "RelationshipStatus","Insured", "SmokingStatus",
               "Work", "HomeOwn","Diabetes","PhysActive")

nhanes_data[nhanes_cat] <- lapply (nhanes_data[nhanes_cat], function(x)
  ifelse(is.na(x), "0",x)) #Convert all missing categorical values to a string "0"

sum(!complete.cases(nhanes_data)) #Confirm the absence of missing values


#Visualizing the distribution of BMI, Weight, Weight in Pounds and Age using Histograms

# Histogram for BMI
df <- nhanes_data
#Use ggplot's subset function to filter out 0s and aesthetic mapping to establish the axes

plot1 <- ggplot(subset(df,BMI!=0), aes(x = BMI)) +
  geom_histogram(binwidth = 2, fill = "steelblue", color = "black") + #Customize the size and colors of the bars
  theme_minimal() + #Customize the plot's theme
  ggtitle("Distribution of BMI") + #Add a title to the plot using ggtitle function
  xlab("BMI") +
  ylab("Count")

# Histogram for Weight (kg)
plot2 <- ggplot(subset(df,Weight !=0), aes(x = Weight)) +
  geom_histogram(binwidth = 5, fill = "darkgreen", color = "black") +
  theme_minimal() +
  ggtitle("Distribution of Weight (kg)") +
  xlab("Weight (kg)") +
  ylab("Count")

# Histogram for Weight in Pounds
# Remove rows that contain 0 in the Weight column
nhanes_data_clean <- nhanes_data[nhanes_data$Weight != 0, ]

# Create a new Weight column in pounds by multiplying the old column by 2.2
nhanes_data_clean$Weight_pounds <- nhanes_data_clean$Weight * 2.2

# Plot histogram
plot3 <- ggplot(nhanes_data_clean, aes(x = Weight_pounds)) +
  geom_histogram(binwidth = 10, fill = "purple", color = "black") +
  theme_minimal() +
  ggtitle("Distribution of Weight (lbs)") +
  xlab("Weight (lbs)") +
  ylab("Count")


# Histogram for Age
plot4 <- ggplot(subset(df, Age !=0), aes(x = Age)) +
  geom_histogram(binwidth = 5, fill = "red", color = "black") +
  theme_minimal() +
  ggtitle("Distribution of Age") +
  xlab("Age") +
  ylab("Count")

grid.arrange(plot1,plot2,plot3,plot4, ncol=2, nrow=2) #Represent all charts in a single plot


# Calculating the mean 60-second pulse rate for all participants
mean_pulserate <- mean(nhanes_data$Pulse [nhanes_data$Pulse !=0], na.rm=TRUE) #Use na.rm and !=0 to exclude the 0s in the column
print(paste("The average pulse rate of all participants is", mean_pulserate))

# Calculating the range of values for diastolic blood pressure in all participants

#Determine the range by identifying the min and max values on the column

Min_BPDia <- min(nhanes_data$BPDia)
Max_BPDia <- max(nhanes_data$BPDia)

paste0("Range of Diastolic Blood Pressure:", " ", Min_BPDia, "-", Max_BPDia) #Use Paste0 to return the range without any extra space

#Calculating the Variance of all incomes
variance_Income <- var(nhanes_data$Income [nhanes_data$Income != 0], na.rm = TRUE)
print(paste("Variance of all incomes:", variance_Income))

#Calculating the Standard Deviation of all incomes
sd(nhanes_data$Income [nhanes_data$Income !=0], na.rm = TRUE)

# Visualizing the relationship between weight and height using Scatter plots

#Distribution of Weight and Height across Gender
plot5 <- ggplot(subset(df,Weight !=0 & Height !=0 & Gender != "0"), aes(x = Weight, y = Height,
                 color = Gender))+
    geom_point() +
    theme_minimal() +
    labs(title = "Weight vs. Height by Gender",
         x = "Weight (kg)", y = "Height (cm)")

#Distribution of Weight and Height across Diabetes
plot6 <- ggplot(subset(df, Weight !=0 & Height !=0 & Diabetes != "0"), aes(x = Weight, y = Height,
  color = Diabetes))+
  geom_point() +
  theme_minimal() +
  labs(title = "Weight vs. Height by Diabetes",
       x = "Weight (kg)", y = "Height (cm)")

#Distribution of Weight and Height across Smoking Status
 plot7 <-ggplot(subset(df, Weight !=0 & Height !=0 & SmokingStatus != "0"), aes(x = Weight, y = Height,
                color = SmokingStatus))+
   geom_point() +
   theme_minimal() +
   labs(title = "Weight vs. Height by Smoking Status",
        x = "Weight (kg)", y = "Height (cm)")

 grid.arrange(plot5,plot6,plot7, ncol=2, nrow=2) #Represent all charts in a single plot

#Calculating the t-tests between some variables

#t-test between Age and Gender
#Use  Welch's Two sample t-test to conduct t-tests between numerical and categorical columns
 Age_ttest <- t.test(Age~Gender,data = nhanes_data,subset =Age !=0 & Gender !="0")
  print(Age_ttest)

#t-test between BMI and Diabetes
  BMI_ttest <- t.test(BMI~Diabetes,data = nhanes_data,subset =BMI !=0 & Diabetes !="0")
  print(BMI_ttest)

#t-test between Alcohol Year and Relationship Status
  AlcoholYear_ttest <- t.test(AlcoholYear~RelationshipStatus,data = nhanes_data,subset =AlcoholYear !=0 & RelationshipStatus !="0")
  print(AlcoholYear_ttest)

#Results of the t-tests
#Based on the p-value for the Age and Gender t-test, there is no statistically significant difference in age between males and females
#The p-value for the BMI and Diabetes t-test suggests a major difference in BMI between people with diabetes and otherwise
#The p-value for the Alcohol year and Relationship status indicates a difference in alcohol consumption  between single and committed people
