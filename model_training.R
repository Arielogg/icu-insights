## MODEL TRAINING SCRIPT ##
## This script attempts to build prediction models using the selected features from the dataset. ##

# Loading dependencies (installing them if not already)
install.packages("rpart.plot")
install.packages('AUC')
install.packages('caret')
install.packages("randomForest")
install.packages("xgboost")
install.packages("cleandata")

library(rpart)
library(rpart.plot)
library(AUC)
library(caret)
library(xgboost)
library(randomForest)
library(cleandata)

# Importing the feature-selected data
db_reduced <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/encoded_admissions_df.csv")

# Separating admission lengths for regression and classification models
admission_days <- db_reduced$days_between 
stay_length <- db_reduced$stay_length

#db_reduced$days_between <- NULL

# Eliminating some variables as they do not contribute to problems
db_reduced$insurance <- NULL
db_reduced$marital_status <- NULL
db_reduced$race <- NULL
db_reduced$language <- NULL

#db_reduced$admission_type <- NULL # Experiments without ic codes encoded

# Factorizing categorical variables
db_reduced[c("gender","stay_length",
             "admission_type")] <- lapply(db_reduced[c("gender","stay_length",
                                                       "admission_type")], factor)
# Seeding for reproducibility
set.seed(42) 

# Separating in train and test splits
train_index <- sample(nrow(db_reduced), 0.8 * nrow(db_reduced))
train <- db_reduced[train_index, ]
test <- db_reduced[-train_index, ]

#Removing unnecesary categoricals from dataframes
train[c("subject_id", "hadm_id")] <- list(NULL) 
test[c("subject_id", "hadm_id")] <- list(NULL)

########## Classification#############
####### DECISION TREES MODEL ##########
dt_model <- rpart(stay_length ~ ., data = train, method = "class")
predictions <- predict(dt_model, test[,-3], type = "class")

# Evaluating decision tree's performance
table(predictions, test$stay_length)
confMatTree2 <- confusionMatrix(predictions, test$stay_length, positive = levels(test$stay_length)[2])
accuracyTree2 <- confMatTree2$overall["Accuracy"]
recall_per_class2 <- confMatTree2$byClass[, "Sensitivity"]
balanced_accuracy2 <- mean(recall_per_class2)

rpart.plot(dt_model)

######### RANDOM FOREST MODEL ##########
rf_model <- randomForest(stay_length ~ ., data = train)
predictionsrf <- predict(rf_model, test[,-3], type = "class")

table(predictionsrf, test$stay_length)
confMatTree1 <- confusionMatrix(predictionsrf, test$stay_length, positive = levels(test$stay_length)[2])
accuracyTree1 <- confMatTree1$overall["Accuracy"]
recall_per_class <- confMatTree1$byClass[, "Sensitivity"]
balanced_accuracy <- mean(recall_per_class)

rpart.plot(regression_tree)

########### XGBOOST MODEL ##############
label_train <- as.data.frame(train[, 1])
label_test <- as.data.frame(test[, 1])
train$days_between <- NULL

# Converting categoricals into ordinals (XGB-specific format)
admission_type <- encode_ordinal(train[,1, drop=FALSE], order=c('EW EMER.','EU OBSERVATION','OBSERVATION ADMIT','SURGICAL SAME DAY ADMISSION','URGENT','DIRECT EMER.','AMBULATORY OBSERVATION','ELECTIVE','DIRECT OBSERVATION'))
stay_length <- encode_ordinal(train[,2, drop=FALSE], order=c('0','1','2'))
gender <- encode_ordinal(train[,2, drop=FALSE], order=c('F','M'))

train$admission_type <- NULL
train$stay_length <- NULL
train$gender <- NULL

train$admission_type <- admission_type[,1]
train$stay_length <- stay_length[,1]
train$gender <- gender[,1]

xgb_train <- xgb.DMatrix(data = train) 
xgb_test <- xgb.DMatrix(data = test[,-3], label = label_test)

### Regression
# Regression tree
train$stay_length <- NULL # Don't need these two for regression
test$stay_length <- NULL
test_y <- test[,2]
test$days_between <- NULL
regression_tree <- rpart(days_between ~ ., data = train, method = "anova")
regression_tree_pred <- rpart.predict(regression_tree, test, type = "vector")

#TODO: Evaluate regressor results