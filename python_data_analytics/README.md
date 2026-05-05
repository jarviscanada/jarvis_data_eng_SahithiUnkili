# Introduction

London Gift Shop (LGS) is an online UK-based retailer that sells giftware products to both individual and wholesale customers. Despite operating for over a decade, the company has experienced stagnant revenue growth. To address this challenge, LGS aims to better understand customer purchasing behavior and leverage data-driven insights to improve marketing effectiveness and increase revenue.

In this project, we analyze historical transaction data to uncover patterns in customer behavior using RFM (Recency, Frequency, Monetary) segmentation. The results enable LGS to identify high-value customers, detect churn risk, and design targeted marketing campaigns such as personalized promotions, re-engagement emails, and loyalty programs.

The project was implemented using Python in a Jupyter Notebook environment. Key libraries include Pandas and NumPy for data processing, and Matplotlib/Seaborn for visualization. The work focuses on data cleaning, feature engineering, customer segmentation, and business insight generation.

---

# Implementation

## Project Architecture

This PoC follows a simplified data pipeline architecture:

1. **Data Source**
   - Transactional data exported by LGS IT team in SQL format
   - Data includes invoices, products, customers, and transaction details

2. **Data Ingestion**
   - Data loaded into a Pandas DataFrame from CSV/SQL dump

3. **Data Processing & Cleaning**
   - Removal of cancelled transactions
   - Handling missing customer IDs
   - Feature engineering (TotalPrice, datetime conversion)

4. **Analytics Layer**
   - RFM (Recency, Frequency, Monetary) calculation
   - Customer segmentation based on behavioral patterns

5. **Visualization & Insights**
   - Customer distribution by segment
   - Revenue contribution analysis
   - Geographic revenue trends

6. **Output**
   - Jupyter Notebook with insights and recommendations
   - GitHub repository for reproducibility


---

## Data Analytics and Wrangling

You can find the full analysis notebook here:

[Retail Data Analytics Notebook](./retail_data_analytics_wrangling.ipynb)

### How the Data Helps LGS Increase Revenue

The analysis enables LGS to transition from generic marketing to targeted, data-driven strategies:

- **Customer Segmentation**
  - Identify Champions, Loyal, At-Risk, and Lost customers
  - Focus marketing efforts where ROI is highest

- **Retention Strategy**
  - Detect customers at risk of churn early
  - Launch re-engagement campaigns (discounts, reminders)

- **Revenue Optimization**
  - Upsell high-frequency customers
  - Offer bundles and premium products to loyal segments

- **Geographic Insights**
  - Identify top-performing countries
  - Tailor regional marketing strategies

Overall, this approach allows LGS to maximize customer lifetime value and improve marketing efficiency.

# Improvements

If given more time, the following enhancements could significantly improve the solution:

1. **Automation & Pipeline Integration**
   - Build an automated ETL pipeline to refresh data and segmentation regularly
   - Schedule jobs using tools like Airflow or cron

2. **Machine Learning Integration**
   - Develop a churn prediction model to proactively identify at-risk customers
   - Implement clustering (K-Means) for deeper segmentation

3. **Business Integration**
   - Integrate results with CRM/email marketing tools
   - Enable real-time campaign triggering based on customer behavior
