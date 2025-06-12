# NYC Airbnb Price Analysis

This project analyzes Airbnb listing data from New York City to understand pricing patterns and build predictive models for rental prices across different boroughs.

## Project Overview
- **Data Cleaning:** Preprocessing and feature engineering on Airbnb listings data.
- **Exploratory Analysis:** Visualizations and statistics to explore borough, room type, and other factors.
- **Geospatial Analysis:** Interactive maps to visualize price distribution across NYC.
- **Predictive Modeling:** Linear regression models for each borough, with special attention to bathroom sharing and neighborhood effects.
- **Evaluation:** Model performance comparison and predictions on a holdout evaluation set.

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
