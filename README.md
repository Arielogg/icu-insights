# ICU Length of Stay Prediction using the R programming language
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Logo_de_l%27Université_Jean_Monnet_Saint-Etienne.png/640px-Logo_de_l%27Université_Jean_Monnet_Saint-Etienne.png" alt="Université Jean Monnet" title="Université Jean Monnet">

The goal of this project is to perform an exploratory data analysis using the R programming language on a portion of the MIMIC-IV dataset. Parting from any interesting relationships found in the data, a classification model based on the RuleFit algorithm is trained and used to predict the length of stay of a given in the hospital given some admission criteria.

## Dataset

The dataset used in this project is the MIMIC-IV (Medical Information Mart for Intensive Care IV) dataset, which is a freely accessible database containing de-identified health data associated with over 40,000 patients who stayed in ICUs at the Beth Israel Deaconess Medical Center in Boston, Massachusetts, USA between the years of 2008-2019.

## Project Overview

The project is divided into the following stages:

1. Data extraction: Synthesized in the file data_import.R, in this stage we select the most important tables from the dataset, related to the objective of the classifier, and their respective labels.

2. Feature selection: Synthesized in the file feature_selection.R. In this stage, the different tables are synthesized into one single table by means of selection and referencing across the different tables.

3. Exploratory data analysis (EDA): In this stage, we explore the MIMIC-IV dataset using statistical and visualization techniques to gain insights into the relationships between variables and identify patterns and trends in the data.

4. Model development and evaluation: Synthesized in the file model_training.R. In this stage, we develop and evaluate several predictive models using various machine learning algorithms, including regression, decision trees, random forests, and gradient boosting. We also evaluate the performance of our models using metrics such as mean squared error, R-squared, and accuracy.

## Project Files

The repository contains the following files:

- `data_import.R`: This R script contains the code for performing the import of the files and storing them in dataframes.

- `feature_selection.R`: This R script contains the code for preprocessing and cleaning the MIMIC-III dataset.

- `model_training.R`: This R script contains the code for developing and evaluating predictive models for the ICU length of stay.

- `aux_plot.R`: This R script contains the code for plotting all auxiliary graphs.

- `README.md`: This file.

## Dependencies

To run the project, you will need to have R and the following R packages installed:

- `dplyr`
- `AUC`
- `reshape2`
- `rpart.plot`
- `rpart`

## Running the Project

To run the project, follow these steps:

1. Clone the repository to your local machine.

2. Install the required dependencies.

3. Run the data_import.R script to import the necessary files from the dataset.

4. Run the feature_selection.R script to perform the feature selection and condensation.

5. Run the model_training.R script to develop and evaluate predictive models.

6. Run the aux_plots.R script to plot the different auxiliary graphs.

## Credits

This project was conducted by Ariel GUERRA ADAMES as part of the Data Mining and Knowledge Discovery course at Université Jean Monnet de Saint-Étienne, Master Machine Learning and Data Mining cohort 2022-2024.
