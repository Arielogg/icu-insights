# Data Mining for Medical Triage Assistance using the R Progamming Language
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Logo_de_l%27Université_Jean_Monnet_Saint-Etienne.png/640px-Logo_de_l%27Université_Jean_Monnet_Saint-Etienne.png" alt="Université Jean Monnet" title="Université Jean Monnet">

The goal of this project is to use the R programming language to extract and process information from the MIMIC-IV dataset that could be related to the length of stays of patients admitted in the intensive care unit (ICU) of a given hospital, in order to predict the length of a stay of incoming patients in said units through classification or regression models. Departing from any interesting relationships found in the data, classification models based on the decision trees, random forests, and eXtreme Gradient Boosting algorithms are trained and used to predict the length of stay of a given in the hospital given some admission criteria.

## Dataset

The dataset used in this project is the MIMIC-IV (Medical Information Mart for Intensive Care IV) dataset, which is a freely accessible database containing de-identified health data associated with over 40,000 patients who stayed in ICUs at the Beth Israel Deaconess Medical Center in Boston, Massachusetts, USA between the years of 2008-2019.

## Project Overview

The project is divided into the following stages:

1. Data extraction: found in the file data_import.R, in this stage I select the most important tables from the dataset, related to the objective of the classifier, and their respective labels.

2. Feature selection: found in the file feature_selection.R. In this stage, the different tables are synthesized into one single table by means of selection and referencing across the different tables.

3. Model evaluation: found in the file model_training.R. In this stage, I develop and evaluate a few predictive models using the previously mentioned machine learning algorithms, including decision trees, random forests, and gradient boosting. I also evaluate the performance of these models given standardized accuracy metrics for the given task.

3. Visualization: found in the file aux_plots.R. In this stage, various auxiliary plots are produced to help illustrate the data, the models, and their respective performances.

## Project Files

The repository contains the following files:

- `data_import.R`: This R script contains the code for performing the import of the files and storing them in dataframes.

- `feature_selection.R`: This R script contains the code for preprocessing and extracting features of interest from the MIMIC-IV dataset.

- `model_training.R`: This R script contains the code for developing and evaluating predictive models for the length of stay.

- `aux_plot.R`: This R script contains the code for plotting all auxiliary graphs.

- `README.md`: This file.

## Dependencies

To run the project, you will need to have R and the following R packages installed:

- `dplyr`
- `reshape2`
- `rpart.plot`
- `rpart`
- `caret`
- `randomForest`
- `xgboost`
- `cleandata`

## Running the Project

To run the project, follow these steps:

1. Clone the repository to your local machine.

2. Install the required dependencies.

3. Run the data_import.R script to import the necessary files from the dataset.

4. Run the feature_selection.R script to perform the feature selection and target encoding.

5. Run the model_training.R script to develop and evaluate predictive models.

6. Run the aux_plots.R script to plot the different auxiliary graphs.

## Credits

This project was conducted by Ariel GUERRA ADAMES as part of the Data Mining and Knowledge Discovery course at Université Jean Monnet de Saint-Étienne, Master Machine Learning and Data Mining cohort 2022-2024.
