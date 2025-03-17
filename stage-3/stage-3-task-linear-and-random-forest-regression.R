# HackBio Internship Program - February, 2025
# Team-arginine on the stage-3 task
# The group consists of four people, namely:
# Meltem (GitHub: @meltemktn)
# BenAkande (GitHub: @BenAkande123)
# Manav Vaish (GitHub: @manavvaish)
# Favour_Imoniye (GitHub: @Favour-Imoniye)
# GitHub link to the team-arginine repository for stage-3:
# https://github.com/meltemktn/Team-Arginine-HackBio/tree/main/stage-3


# Load the libraries 

library(ggplot2)
library(caret)
library(randomForest)
library(dplyr)

# Load the data

chem_data<-read.csv("https://raw.githubusercontent.com/HackBio-Internship/2025_project_collection/refs/heads/main/Python/Dataset/drug_class_struct.txt",sep="\t",header = T)
head(chem_data)
str(chem_data)
dim(chem_data)

# Eliminate contrast error by defining factors


chem_data <- chem_data[, sapply(chem_data, function(x) if(is.factor(x)) length(levels(x)) > 1 else TRUE)] 
chem_data[,5:25]<-lapply(chem_data[,5:25],as.numeric) # Convert the chemical properties columns into numeric 
chem_data <- chem_data[sample(nrow(chem_data), 10000), ] # Downsize the data
chemdataselected<-select(chem_data,-c("SpiroCount","PosCount","NegCount","ComponentCount")) # Remove columns with 0 and 1 values


# Split data into training and test datasets

set.seed(42)
train_index <- createDataPartition(chemdataselected$score, p = 0.8, list = FALSE) # a function in the caret package
train_data <- chemdataselected[train_index, ]
test_data <- chemdataselected[-train_index, ]


# Train the model with linear regression vs random forest regression

lm_model <- train(score ~ ., data = train_data[,c("score",colnames(chemdataselected[,5:21]))], # dot means all variables, tilde defines relationships with variables
                  method = "lm",
                  trControl = trainControl(method = "cv", number = 5),
                  )
rf_model <- train(score ~ ., data = train_data[,c("score",colnames(chemdataselected[,5:21]))], # dot means all variables, tilde defines relationships with variables
                  method = "rf",
                  trControl = trainControl(method = "cv", number = 5),
                  tuneGrid=data.frame(mtry=4),
                  ntree=100
)


# Print the summary for the linear regression model

summary(lm_model$finalModel)
lm_predictions <- predict(lm_model, newdata = test_data)
lm_rmse <- RMSE(lm_predictions, test_data$score)
lm_mae<-MAE(lm_predictions, test_data$score)


# Print the summary for the random forest regression model

summary(rf_model$finalModel)
rf_predictions <- predict(rf_model, newdata = test_data)
rf_rmse <- RMSE(rf_predictions, test_data$score)
rf_mae<- MAE(rf_predictions, test_data$score)


# Extract feature importance and plot the most important 10 factors for linear regression

lm_importance <- varImp(lm_model)
plot(lm_importance,top=10)


# Extract feature importance and plot the most important 10 factors for random forest regression

rf_importance <- varImp(rf_model)
plot(rf_importance,top=10)


# Now plot the results for a comparison between random forest regression and linear regression


results <- data.frame(actual_score = test_data$score,
                      Predicted_LM = lm_predictions,
                      Predicted_RF = rf_predictions)


ggplot(results, aes(x = actual_score)) +
  geom_point(aes(y = Predicted_LM, color = "Linear Regression")) +
  geom_point(aes(y = Predicted_RF, color = "Random Forest")) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") + # adds a reference line (y=x)
  labs(title = "Predicted vs. Actual Score",
       x = "Actual Score",
       y = "Predicted Score") + theme_minimal()+xlim(c(min(lm_predictions), max(rf_predictions)))

# Plot the RMSE and MAE for both linear and random forest regression 

score_df<-data.frame(model=rep(c("Linear Regression","Random Forest Regression"),each=2),
                     metric=rep(c("RMSE","MAE"),times=2),
                     scores=c(lm_rmse, lm_mae, rf_rmse,rf_mae))
ggplot(score_df, aes(x = model, y = scores, fill = metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Model", y = "Value", fill = "Metric", title = "RMSE and MAE Comparison Before Feature Selection") +
  scale_fill_manual(values = c("RMSE" = "turquoise", "MAE" = "salmon")) +
  theme_minimal()


# Identify the R-squared values of the linear and random regression models 

lm_rsquare<-lm_model$results$Rsquared
rf_rsquare<-rf_model$results$Rsquared

# Plot R-squared values for both linear and random forest regression

rsq_df<-data.frame(model=c("Linear Regression","Random Forest Regression"),
                   metric=c("Linear Regression","Random Forest Regression R-squared"),
                   scores=c(lm_rsquare,rf_rsquare)
)

ggplot(rsq_df, aes(x = model, y = scores, fill = model)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Model", y = "Value", fill = "Model", title = "R-Square Comparison Before Feature Selection") +
  scale_fill_manual(values = c("Linear Regression" = "darkblue", "Random Forest Regression" = "lightblue")) +
  theme_minimal()

# Try running RFE for linear regression 

control <- rfeControl(functions = lmFuncs, method = "cv", number = 5,rerank = FALSE,verbose=FALSE)
rfe_result <- rfe(x = chemdataselected[, 5:21], y = chemdataselected$score, sizes = c(5,10,15), rfeControl = control)

print(rfe_result)


# Select the top features 

top_features <- predictors(rfe_result)


# Keep only selected features

df_selected <- chemdataselected %>% select(all_of(top_features), score)


# View the first few rows

head(df_selected)


# Now apply the model on the selected features 

train_index <- createDataPartition(df_selected$score, p = 0.8, list = FALSE)

train_data <- df_selected[train_index, ]
test_data <- df_selected[-train_index, ]

lm_model <- train(score ~ ., data = train_data,
                  method = "lm",
                  trControl = trainControl(method = "cv", number = 5))  


# Print model summary

print(lm_model)



# Model Evaluation on Test Data

# Predict on test data

lm_predictions <- predict(lm_model, newdata = test_data)

# Compute RMSE (Root Mean Squared Error) and MAE (Mean Absolute Error)


lm_rmse <- RMSE(lm_predictions, test_data$score)
lm_mae<-MAE(lm_predictions, test_data$score)

# Print RMSE

print(paste("Linear regression RMSE:", round(lm_rmse, 2)))



# Feature Importance Analysis


# Extract feature importance

lm_importance <- varImp(lm_model)

# Plot top 10 important features

plot(lm_importance, top = 10)



# Try doing the same for random forest regression

# Try running RFE for random forest regression 

control_rf <- rfeControl(functions = rfFuncs, method = "cv", number = 5,rerank = FALSE,verbose=FALSE)
rfe_result_rf <- rfe(x = chemdataselected[, 5:21], y = chemdataselected$score, sizes = c(5), rfeControl = control)

print(rfe_result_rf)


# Select the top features 

top_features_rf <- predictors(rfe_result_rf)


# Keep only selected features

df_selected_rf <- chemdataselected %>% select(all_of(top_features_rf), score)


# View the first few rows

head(df_selected_rf)


# Now apply the random forest regression model on the selected features 

train_index <- createDataPartition(df_selected_rf$score, p = 0.8, list = FALSE)

train_data_rf <- df_selected_rf[train_index, ]
test_data_rf <- df_selected_rf[-train_index, ]

rf_model <- train(score ~ ., data = train_data_rf,
                  method = "rf",
                  trControl = trainControl(method = "cv", number = 5),
                  tuneGrid=data.frame(mtry=3),
                  ntree=100)  


# Print model summary

print(rf_model)



# Model Evaluation on Test Data

# Predict on test data

rf_predictions <- predict(rf_model, newdata = test_data_rf)

# Compute RMSE (Root Mean Squared Error) and MAE (Mean Absolute Error)

rf_rmse <- RMSE(rf_predictions, test_data_rf$score)
rf_mae<- MAE(rf_predictions, test_data$score)



# Print RMSE 

print(paste("Random forest regression RMSE:", round(rf_rmse, 2)))



# Feature Importance Analysis


# Extract feature importance

rf_importance <- varImp(rf_model)

# Plot top 10 important features

plot(rf_importance, top = 10)


# Plot RMSE and MAE comparison

score_df<-data.frame(model=rep(c("Linear Regression","Random Forest Regression"),each=2),
                     metric=rep(c("RMSE","MAE"),times=2),
                     scores=c(lm_rmse, lm_mae, rf_rmse,rf_mae))
ggplot(score_df, aes(x = model, y = scores, fill = metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Model", y = "Value", fill = "Metric", title = "RMSE and MAE Comparison After Feature Selection") +
  scale_fill_manual(values = c("RMSE" = "turquoise", "MAE" = "salmon")) +
  theme_minimal()


# Identify the R-squared values of the linear and random regression models for selected features

rf_rsquare_sel<-rf_model$results$Rsquared
lm_rsquare_sel<-lm_model$results$Rsquared

# Plot R-squared values for both linear and random forest regression

rsq_df<-data.frame(model=c("Linear Regression","Random Forest Regression"),
                   metric=c("Linear Regression","Random Forest Regression R-squared"),
                   scores=c(lm_rsquare_sel,rf_rsquare_sel)
)
ggplot(rsq_df, aes(x = model, y = scores, fill = model)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Model", y = "Value", fill = "Model", title = "R-Square Comparison After Feature Selection") +
  scale_fill_manual(values = c("Linear Regression" = "darkblue", "Random Forest Regression" = "lightblue")) +
  theme_minimal()

