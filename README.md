# NYC Airbnb Price Prediction Project

## Project Overview
This project explores and predicts Airbnb listing prices in New York City using real-world data. The workflow follows exploratory data analysis (EDA), baseline modeling, and advanced model improvements. The goal is to understand the factors influencing Airbnb prices and build accurate, generalizable predictive models.

## Data
- Source: NYC Airbnb Open Data (processed and cleaned)
- Key features: location, room type, number of bedrooms/bathrooms, host and review history, engineered features (e.g., distance from city center, bed efficiency)
- Data file: `data/bnb_listing_rev.csv`

## Project Structure
- `NYC_Airbnb_EDA.Rmd` / `NYC_Airbnb_EDA.html`: Exploratory Data Analysis (EDA)
- `NYC_Airbnb_Baseline_Models.Rmd` / `NYC_Airbnb_Baseline_Models.html`: Baseline linear modeling with engineered features and proper data splitting
- `NYC_Airbnb_Model_Improvements.Rmd` / `NYC_Airbnb_Model_Improvements.html`: Advanced modeling (Random Forest, XGBoost), feature engineering, and model evaluation
- `data/`: Contains the cleaned dataset
- `visualizations/`: Contains generated plots and figures
- `README.md`: Project overview and instructions

## Model Performance Summary

| Model                | Dataset      | RMSE   | MAE   | R²     |
|----------------------|-------------|--------|-------|--------|
| **Baseline (Linear)**| Test        | ~58    | ~32   | ~0.82  |
|                      | Evaluation  | ~58    | ~32   | ~0.81  |
| **Random Forest**    | Test        | ~21    | ~7    | ~0.98  |
|                      | Evaluation  | ~21    | ~7    | ~0.98  |
| **XGBoost**          | Test        | ~5     | ~1.5  | ~0.999 |
|                      | Evaluation  | ~5.5   | ~1.4  | ~0.998 |

*Values are approximate, based on reported results.*

## Data Splitting Approach
- **Training Set (60%)**: Used to fit all models and perform feature engineering.
- **Test Set (20%)**: Used to evaluate model performance during development and compare different models.
- **Evaluation Set (20%)**: Held out and used only for the final, unbiased assessment of model performance. This ensures that reported results are not overfitted or biased by repeated testing.

## Findings from Each File

### NYC_Airbnb_EDA.Rmd
- **Purpose:** Exploratory Data Analysis (EDA)
- **Findings:**
  - Price distribution is right-skewed, with most listings under $300/night.
  - Key drivers of price: room type, location (borough/neighborhood), number of bedrooms/bathrooms.
  - Engineered features (e.g., bed efficiency, price per person, distance from center) help explain price variation.
   - `bed_efficiency = beds / accommodates`
   - `price_per_person = price / accommodates`
   - `distance_from_center = sqrt((latitude - 40.7128)^2 + (longitude - (-74.0060))^2)`

  - Visualizations revealed trends and outliers, guiding feature selection for modeling.

### NYC_Airbnb_Baseline_Models.Rmd
- **Purpose:** Baseline predictive modeling using linear regression.
- **Findings:**
  - Linear regression with engineered features explained most price variation (R² ~0.82).
  - Location and room type were the most important predictors.
  - Residual analysis showed higher error for expensive listings, suggesting room for improvement with more complex models.

### NYC_Airbnb_Model_Improvements.Rmd
- **Purpose:** Advanced modeling and model comparison.
- **Findings:**
  - Random Forest and XGBoost models significantly improved accuracy (R² up to ~0.999).
  - Residual plots showed good generalization and no overfitting.
  - Feature importance analysis confirmed the value of engineered features and location.
  - The models are robust and ready for business use.

## Key Results
- **EDA:** Identified key drivers of price (room type, location, bedrooms/bathrooms). Engineered features like bed efficiency and distance from center improved understanding.
- **Baseline Model:** Linear regression explained most price variation (Test RMSE ~58, R² ~0.82). Location and room type were top predictors.
- **Model Improvements:** Random Forest and XGBoost achieved high accuracy (Test RMSE ~21 and ~5, R² up to ~0.999). Residual analysis showed good generalization and no overfitting.

## How to Reproduce
1. Open the R Markdown files in RStudio or your preferred R environment.
2. Knit each `.Rmd` file to generate the corresponding `.html` report.
3. Data is read from `data/bnb_listing_rev.csv`.
4. Visualizations are saved in the `visualizations/` directory.

## Conclusion
This project demonstrates a full data science workflow for NYC Airbnb price prediction. Through careful EDA, thoughtful feature engineering, and advanced modeling, we achieved highly accurate and generalizable predictions. The models are robust, interpretable, and ready for further business or research applications.

## Business/Stakeholder Implications
- **For Hosts:** The models can help Airbnb hosts set competitive and optimal prices for their listings by understanding which features (e.g., location, room type, amenities) most influence price. Hosts can use these insights to make targeted improvements to their properties or adjust pricing strategies to maximize occupancy and revenue.
- **For Airbnb/Platforms:** The predictive models can be integrated into pricing recommendation tools, improving user experience and platform trust. Accurate price predictions can also help detect outliers or potential fraud.
- **For Policymakers:** Understanding the drivers of Airbnb prices can inform housing policy, zoning, and tourism management. Insights into how location and property features affect prices can guide regulations or incentives to balance tourism and local housing needs.
- **For Investors/Analysts:** The findings provide a data-driven foundation for investment decisions, market analysis, and forecasting trends in the short-term rental market.

Overall, this project empowers stakeholders to make informed, data-driven decisions in the dynamic NYC Airbnb market.

## Next Steps (Optional)
- Explore additional features (seasonality, text analysis of reviews, etc.)

---
