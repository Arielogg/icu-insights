# ICU Length of Stay Prediction using the R programming language

This . The goal of this project is to develop a predictive model for the length of stay of patients in the ICU (Intensive Care Unit) using the R programming language and a dataset of ICU patient records.

## Dataset

The dataset used in this project is the MIMIC-IV (Medical Information Mart for Intensive Care IV) dataset, which is a freely accessible database containing de-identified health data associated with over 40,000 patients who stayed in ICUs at the Beth Israel Deaconess Medical Center in Boston, Massachusetts, USA.

## Project Overview

The project is divided into the following stages:

1. Data preprocessing and cleaning: In this stage, we clean and preprocess the MIMIC-IV dataset, handle missing values and outliers, and perform feature engineering to select the most relevant features for our predictive model.

2. Exploratory data analysis (EDA): In this stage, we explore the MIMIC-IV dataset using statistical and visualization techniques to gain insights into the relationships between variables and identify patterns and trends in the data.

3. Model development and evaluation: In this stage, we develop and evaluate several predictive models using various machine learning algorithms, including regression, decision trees, random forests, and gradient boosting. We also evaluate the performance of our models using metrics such as mean squared error, R-squared, and accuracy.

4. Model deployment: In this stage, we deploy our final predictive model as a web application that can take input data and provide predictions for the length of stay of patients in the ICU.

## Project Files

The repository contains the following files:

- `data`: This folder contains the MIMIC-III dataset in CSV format.

- `preprocessing.R`: This R script contains the code for preprocessing and cleaning the MIMIC-III dataset.

- `eda.R`: This R script contains the code for performing exploratory data analysis on the MIMIC-III dataset.

- `modeling.R`: This R script contains the code for developing and evaluating predictive models for the ICU length of stay.

- `app.R`: This R script contains the code for deploying the final predictive model as a web application.

- `README.md`: This file.

## Dependencies

To run the project, you will need to have R and the following R packages installed:

- `tidyverse`
- `caret`
- `randomForest`
- `gbm`
- `shiny`

## Running the Project

To run the project, follow these steps:

1. Clone the repository to your local machine.

2. Install the required dependencies.

3. Run the preprocessing.R script to preprocess and clean the dataset.

4. Run the eda.R script to perform exploratory data analysis on the dataset.

5. Run the modeling.R script to develop and evaluate predictive models.

6. Run the app.R script to deploy the final predictive model as a web application.

## Credits

This project was conducted by Ariel GUERRA ADAMES as part of the Data Mining and Knowledge Discovery course at Université Jean Monnet de Saint-Étienne.
