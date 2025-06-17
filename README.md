# NYC Airbnb Price Prediction Project

## Project Overview
This project explores and predicts Airbnb listing prices in New York City using real-world data. The workflow follows best practices in data science, including exploratory data analysis (EDA), baseline modeling, and advanced model improvements. The goal is to understand the factors influencing Airbnb prices and build accurate, generalizable predictive models.

## Data
- Source: NYC Airbnb Open Data (processed and cleaned)
- Key features: location, room type, number of bedrooms/bathrooms, host and review history, engineered features (e.g., distance from city center, bed efficiency)

## Exploratory Data Analysis (EDA)
- **Distribution:** Prices are right-skewed, with most listings under $300/night but some much higher.
- **Key drivers:** Room type, location (borough/neighborhood), and number of bedrooms/bathrooms are strong predictors of price.
- **Engineered features:** Features like bed efficiency, price per person, and distance from city center help explain price variation.
- **Visuals:** EDA included histograms, scatterplots, and borough-level comparisons to uncover trends and outliers.

## Baseline Model
- **Model:** Linear regression using both original and engineered features.
- **Performance:**
  - Test RMSE: ~58
  - Test R²: ~0.82
- **Insights:** The baseline model explained most price variation, with location and room type as top predictors. Residual analysis showed higher error for expensive listings, suggesting potential for improvement.

## Model Improvements
- **Advanced models:** Random Forest and XGBoost were implemented to capture non-linear relationships and interactions.
- **Performance:**
  - Random Forest Test RMSE: ~21, R²: ~0.98
  - XGBoost Test RMSE: ~5, R²: ~0.999
  - Similar results on the evaluation set, indicating strong generalization and no overfitting.
- **Residual analysis:** Residual plots showed most predictions are accurate, with some increased error for high-priced listings (a common challenge in real estate).
- **Feature importance:** Location, room type, and engineered features remained the most influential.

## Conclusion
This project demonstrates a full data science workflow for NYC Airbnb price prediction. Through careful EDA, thoughtful feature engineering, and advanced modeling, we achieved highly accurate and generalizable predictions. The models are robust, interpretable, and ready for further business or research applications.

## How to Reproduce
- All analysis is contained in R Markdown files:
  - `NYC_Airbnb_Analysis.Rmd` (EDA)
  - `NYC_Airbnb_Baseline_Models.Rmd` (Baseline Model)
  - `NYC_Airbnb_Model_Improvements.Rmd` (Advanced Models)
- Data is located in the `data/` directory.
- Visualizations are in the `visualizations/` directory.

## Next Steps (Optional)
- Explore additional features (seasonality, text analysis of reviews, etc.)
- Deploy the model as a web app or API
- Present findings to stakeholders

---


## Reproduce
1. Install R and required packages:
   ```bash
   Rscript -e 'chooseCRANmirror(graphics=FALSE, ind=1); install.packages(c("rmarkdown", "dplyr", "stringr", "lubridate", "ggplot2", "leaflet", "caret", "RANN", "caTools"))'
   ```
2. Place the data files in the correct paths as referenced in the scripts.
3. Render the analysis to HTML:
   ```bash
   Rscript -e "rmarkdown::render('NYC_Airbnb_Analysis.Rmd', output_format='html_document')"
   ```

## Main Files
- `NYC_Airbnb_Analysis.Rmd`: Main analysis and report (R Markdown)
- `bnb_analysis.R`: Full R script version of the analysis
- `bnb_listing_rev.csv`, `evalset_rev.csv`, `bnb_evalset.csv` : Data files 
