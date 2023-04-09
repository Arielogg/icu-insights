## MODEL TRAINING SCRIPT ##
## This script attempts to build prediction models using the selected features from the dataset. ##

# Loading dependencies (installing them if not installed already)
install.packages("rpart.plot")
install.packages('AUC')
install.packages('caret')
install.packages("randomForest")
install.packages("xgboost")
install.packages("cleandata")

library(rpart)
library(rpart.plot)
library(caret)
library(xgboost)
library(randomForest)
library(cleandata)

# Importing the feature-selected data
db_reduced <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/encoded_admissions_df.csv")
mean(db_reduced$days_between)
median(db_reduced$days_between)

# Separating admission lengths for regression and classification models
#admission_days <- db_reduced$days_between 
#stay_length <- db_reduced$stay_length
db_reduced$days_between <- NULL # Only for classification problems

# Eliminating some variables as they unnecesarily increase dimensionality of the problem
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
predictions <- predict(dt_model, test[,-2], type = "class")

# Evaluating decision tree's performance
conf_mat_dt <- confusionMatrix(predictions, test$stay_length)
conf_mat_dt

rpart.plot(dt_model)

######### RANDOM FOREST MODEL ##########
rf_model <- randomForest(stay_length ~ ., data = train)
predictionsrf <- predict(rf_model, test[,-2], type = "class")

# Evaluating decision tree's performance
conf_mat_rf <- confusionMatrix(predictionsrf, test$stay_length)
conf_mat_rf

########### XGBOOST MODEL ##############
label_train <- as.data.frame(train[, 2])
label_test <- as.data.frame(test[, 2])
train$days_between <- NULL
test$days_between <- NULL

# Converting categoricals into ordinals (XGB-specific format)
admission_type_train <- encode_ordinal(train[,1, drop=FALSE], order=c('EW EMER.','EU OBSERVATION','OBSERVATION ADMIT','SURGICAL SAME DAY ADMISSION','URGENT','DIRECT EMER.','AMBULATORY OBSERVATION','ELECTIVE','DIRECT OBSERVATION'))
admission_type_test <- encode_ordinal(test[,1, drop=FALSE], order=c('EW EMER.','EU OBSERVATION','OBSERVATION ADMIT','SURGICAL SAME DAY ADMISSION','URGENT','DIRECT EMER.','AMBULATORY OBSERVATION','ELECTIVE','DIRECT OBSERVATION'))
gendertrain <- encode_ordinal(train[,4, drop=FALSE], order=c('F','M'))
gendertest <- encode_ordinal(test[,4, drop=FALSE], order=c('F','M'))
  
train$admission_type <- NULL
train$gender <- NULL
test$admission_type <- NULL
test$gender <- NULL

train$admission_type <- admission_type_train[,1]
train$stay_length <- as.numeric(as.character(train$stay_length)) # This is due to the fact that xgboost is extremely picky on the data format
train$gender <- gendertrain[,1]
test$admission_type <- admission_type_test[,1]
test$stay_length <- as.numeric(as.character(test$stay_length))
test$gender <- gendertest[,1]

# Defining predictor and response variables in training set
train_x = data.matrix(train[,-1])
xgb_train <- xgb.DMatrix(data = train_x, label = train$stay_length) 

# Defining predictor and response variables in testing set
test_x = data.matrix(test[,-1])
xgb_test <- xgb.DMatrix(data = test_x, label = test$stay_length)

colnames(xgb_test) <- colnames(xgb_train)

# Set the parameters for the XGBoost model
params <- list(
  objective = "multi:softmax",
  num_class = 3,
  max_depth = 5,
  eta = 0.3,
  nthread = 2,
  eval_metric = "mlogloss"
)

# Train the XGBoost model
xgbModel <- xgb.train(
  params = params,
  data = xgb_train,
  nrounds = 50,
  watchlist = list(train = xgb_train, test = xgb_test),
  print_every_n = 10
)

# Make predictions on the testing data
xgbPreds <- predict(xgbModel, xgb_test)
xgbPredsFactor <- factor(xgbPreds, levels = levels(factor(test[, 1])))

# Evaluate the model's performance
conf_mat_xgb <- confusionMatrix(xgbPredsFactor, factor(test[, 1]))

############################################################################
########################## Regression ######################################
############################################################################

# Recalling data for the regression problem.
db_reduced <- read.csv("C:/Users/ariel/Documents/MLDM/Data Mining/encoded_admissions_df.csv")
db_reduced$insurance <- NULL
db_reduced$marital_status <- NULL
db_reduced$race <- NULL
db_reduced$language <- NULL

# Redeclaring train and test sets:
train <- db_reduced[train_index, ]
test <- db_reduced[-train_index, ]

#Removing unnecesary categoricals from dataframes
train[c("subject_id", "hadm_id")] <- list(NULL) 
test[c("subject_id", "hadm_id")] <- list(NULL)

# Regression tree
train$stay_length <- NULL # Don't need these two for regression
test$stay_length <- NULL
test_y <- test[,2]

regression_tree <- rpart(days_between ~ ., data = train, method = "anova")
regression_tree_pred <- rpart.predict(regression_tree, test[,-2], type = "vector")

# Calculate the mean squared error, root mean squared error, and mean absolute error
mse <- mean((regression_tree_pred - test[,2])^2)
rmse <- sqrt(mse)
mae <- mean(abs(regression_tree_pred - test[,2]))

