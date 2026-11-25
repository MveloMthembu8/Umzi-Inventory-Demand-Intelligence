# Umzi Inventory & Demand Intelligence

An end-to-end analysis of inventory, sales and supplier performance for **Umzi Wholesale & Distribution (Pty) Ltd**, a fictional mid-sized wholesaler based in Durban, South Africa. The business operates four warehouses across Durban, Johannesburg, Cape Town and Pretoria, stocks 105 products across seven categories, and sources products from 13 suppliers, six of which are international.

The project covers January 2024 to December 2025 and uses Python for data preparation and exploration, PostgreSQL for structured querying, Microsoft Excel for summary reporting and Power BI for interactive business intelligence.

**Dashboard:** [Insert published Power BI report or PDF link]

![Dashboard Overview](Screenshots/dashboard_overview.png)

## Project Deliverables

| Deliverable | Description |
|---|---|
| Python Notebook | Data inspection, cleaning, validation and exploratory analysis |
| Cleaned Dataset | Standardised transactional dataset used across the project |
| SQL Analysis | PostgreSQL queries addressing key business questions |
| Excel Workbook | PivotTables, summary calculations and reporting |
| Power BI Dashboard | Interactive dashboard for monitoring operational performance |

## The Problem

Wholesalers lose money in two directions. Too much stock ties up working capital and increases storage costs. Too little means unfulfilled orders, missed sales opportunities and customers who may purchase elsewhere. Unreliable supplier deliveries make both problems harder to manage because replenishment depends on stock arriving when expected.

This project investigates four key business questions:

1. Which products sell the most, by units and revenue, and how does revenue change over time?
2. Which products experience the most unfulfilled demand, and what potential revenue does this represent?
3. Which suppliers deliver late most frequently, and how consistent are their delivery schedules?
4. What should purchasing and replenishment decisions prioritise based on the findings?

## Dataset

The analysis uses a consolidated transactional dataset containing **13,495 records and 37 columns**, covering 1 January 2024 to 31 December 2025.

Each record represents a transaction involving one product at one warehouse. Transaction types include sales, purchases, customer returns and stock adjustments.

The dataset contains information relating to:

- Transaction identifiers, dates, types and statuses.
- Product identifiers, names, categories and subcategories.
- Warehouse locations and provinces.
- Supplier names, locations, countries and lead times.
- Customer identifiers, types and locations.
- Ordered quantities, actual quantities and stock movements.
- Opening stock, stock on hand and reorder thresholds.
- Unit costs, selling prices, total revenue and gross profit.
- Expected and actual delivery dates.
- Unfulfilled quantities and delivery statuses.

The data was designed to represent realistic wholesale distribution operations. It includes incomplete orders, cancelled transactions, partial deliveries, returns and stock adjustments, allowing the analysis to account for common operational data challenges.

*Umzi Wholesale & Distribution and its transactional dataset are fictional and were created for portfolio and analytical demonstration purposes.*

## Data Preparation

Before conducting the analysis, I inspected the dataset to understand its structure, data types, missing values and potential inconsistencies.

The preparation process included:

- **Missing values:** Investigated missing values across individual fields, distinguishing legitimate blanks from incomplete records. For example, delivery dates may be blank for purchases that have not yet been received.
- **Duplicates:** Checked transaction identifiers for duplicate records. No duplicate transaction IDs were identified.
- **Standardisation:** Cleaned inconsistent product names, supplier naming conventions and product category labels by addressing whitespace, capitalisation and naming variations.
- **Date conversion:** Converted transaction and delivery dates into consistent datetime formats to support monthly aggregation and delivery-delay calculations.
- **Transaction filtering:** Separated completed sales and purchase transactions for the relevant analyses, excluding cancelled and pending transactions where appropriate.

The cleaned dataset was exported and reused throughout the SQL, Excel and Power BI stages to maintain consistency across the project.

## Analysis Approach

### Sales Performance

Completed sales transactions were aggregated by product and month to calculate units sold and total revenue.

This analysis identifies high-performing products by sales volume and revenue, while the monthly aggregation provides an overview of revenue trends across the two-year reporting period.

### Unfulfilled Demand and Estimated Lost Revenue

Unfulfilled customer demand was analysed using the `unfilled_quantity` field.

To estimate the financial value associated with stock shortages, I calculated:

> **Estimated Lost Revenue = Unfulfilled Quantity × Unit Selling Price**

This calculation was applied at transaction level before aggregating results by product.

The result represents an estimated revenue opportunity rather than confirmed financial loss. It assumes that unfulfilled demand could have converted into sales at the listed selling price and does not account for customers purchasing substitute products.

The measure is primarily used to compare the financial exposure associated with different products and support replenishment prioritisation.

### Supplier Reliability

Supplier performance was evaluated using completed purchase transactions with valid expected and actual delivery dates.

Delivery delays were calculated by subtracting the expected delivery date from the actual delivery date. Any positive delay was classified as late.

The following metrics were calculated for each supplier:

- Total completed deliveries.
- Average delivery delay in days.
- Number of late deliveries.
- Late delivery rate.
- Number of partial deliveries.

A partial delivery was identified where the quantity received was lower than the quantity ordered.

Partial deliveries were evaluated separately from late deliveries because an order may arrive on time but still contain fewer units than requested.

### SQL Analysis

PostgreSQL was used to independently query and aggregate the cleaned transactional dataset.

The SQL analysis covered:

- Product-level sales and revenue aggregation.
- Ranking products by unfulfilled demand and estimated lost revenue.
- Supplier delivery performance and late-delivery rates.
- Monthly revenue aggregation using date functions.

Queries were structured around the project's business questions, making the analysis reproducible and allowing results to be retrieved directly from the database.

## Findings

### Unfulfilled Demand and Estimated Lost Revenue

Completed sales records contained **6,935 unfulfilled units**.

Estimated lost revenue was calculated across all completed sales transactions, with the highest product-level estimates shown below.

| Product | Estimated Lost Revenue |
|---|---:|
| Glass Food Container Set | R34,775.89 |
| Plastic Laundry Basket | R34,037.50 |
| Aux Cable 3.5mm | R31,906.32 |
| Disinfectant Spray 500ml | R24,945.24 |
| Bleach 2L | R22,204.75 |

**Total estimated lost revenue: R790389.53**

The ranking by estimated lost revenue differs from the ranking by unfulfilled units. A product with fewer unfulfilled units can represent a greater revenue opportunity if its selling price is higher.

This distinction is important when prioritising replenishment. Ordering decisions based solely on the number of missing units may overlook products with greater financial exposure.

### Supplier Reliability

The supplier analysis examined **1,600 completed deliveries** with valid expected and actual delivery dates.

Of these, **790 deliveries were late**, resulting in an overall late-delivery rate of approximately **49.4%**.

The suppliers with the highest late-delivery rates were:

| Supplier | Late Delivery Rate |
|---|---:|
| Hanoi Plastics JSC | 67.96% |
| Gauteng Hardware Co Pty Ltd | 67.95% |
| Mumbai Household Imports Pvt Ltd | 51.14% |
| Shenzhen Star Electronics Ltd | 50.00% |

Hanoi Plastics JSC recorded the highest late-delivery rate, closely followed by Gauteng Hardware Co Pty Ltd.

Late-delivery rates alone, however, do not capture the full extent of supplier risk. Hanoi Plastics JSC also recorded the highest number of partial deliveries, with 99 transactions.

This combination highlights a procurement concern: deliveries may arrive late and still contain fewer units than originally ordered.

### Monthly Revenue

Monthly revenue was aggregated across the 2024 and 2025 reporting periods to examine changes in sales performance over time.

The monthly analysis provides a basis for identifying changes in revenue performance and considering how purchasing and inventory planning could respond to variations in demand.

## Business Recommendations

Based on the analytical findings, the following recommendations could support improved inventory and procurement decisions.

1. **Prioritise replenishment using demand and financial exposure.** Products with high unfulfilled demand and high estimated lost revenue should receive greater attention. Replenishment decisions should also account for current stock levels, sales volumes and supplier lead times.

2. **Review supplier delivery performance.** Hanoi Plastics JSC and Gauteng Hardware Co Pty Ltd should be prioritised for supplier performance reviews to investigate recurring delays. Where performance does not improve, alternative sourcing arrangements or revised delivery agreements could be considered.

3. **Monitor actual quantities received.** Purchasing teams should compare quantities ordered against quantities received rather than relying solely on purchase order completion statuses. This helps identify partial deliveries that could otherwise contribute to unexpected stock shortages.

4. **Balance stock availability against holding costs.** Sales trends, supplier lead times and reorder thresholds should be considered together when making inventory decisions. This can help reduce unnecessary stockholding while maintaining availability for products with consistent demand.

5. **Introduce regular performance monitoring.** The Power BI dashboard provides a consolidated view of revenue, units sold, unfulfilled demand and supplier delivery performance. Reviewing these indicators regularly can help management identify emerging operational problems and investigate them earlier.

## Dashboard

The Power BI dashboard consolidates the main analytical findings into an interactive reporting interface.

It includes:

- **KPI cards:** Total revenue, units sold, unfulfilled demand, estimated lost revenue and late-delivery rate.
- **Monthly revenue trend:** Revenue performance across the 2024–2025 reporting period.
- **Product sales performance:** Units sold across the product portfolio.
- **Supplier performance:** Comparison of supplier late-delivery rates.
- **Date slicer:** Filtering of dashboard metrics and visuals by reporting period.

The dashboard allows users to explore the data from an operational perspective and compare performance across products, suppliers and time periods.


## Limitations and Next Steps

The dataset is synthetic. The findings demonstrate the analytical methods and business questions that can be addressed using transactional data; they do not represent the actual performance of a real wholesale business.

There are also opportunities to extend the analysis with access to more detailed operational data.

With real business data, further investigation could include:

- Comparing supplier lead times with the time between purchase order creation and delivery to distinguish supplier delays from internal ordering delays.
- Introducing historical stock-on-hand snapshots to measure stockout duration and frequency more directly.
- Evaluating whether existing reorder thresholds trigger replenishment early enough to prevent shortages.
- Incorporating inventory holding costs and product margins to evaluate the financial trade-off between stock availability and excess inventory.
- Developing demand forecasting models to support more proactive purchasing decisions.

## Skills Demonstrated

**Data Preparation and Analysis**
- Python and Pandas.
- Data inspection and validation.
- Missing-value assessment.
- Data standardisation and transformation.
- Exploratory data analysis.
- Data visualisation.

**Database and Querying**
- PostgreSQL.
- SQL aggregation and filtering.
- Conditional calculations.
- Grouping and ranking.
- Date-based analysis.

**Reporting and Business Intelligence**
- Microsoft Excel PivotTables.
- Summary reporting.
- Power BI dashboard development.
- DAX measures.
- KPI reporting and interactive filtering.

**Business Analysis**
- Sales performance evaluation.
- Inventory demand analysis.
- Estimated revenue opportunity assessment.
- Supplier performance measurement.
- Operational recommendations.

## Author

Mvelo Asanda Mthembu

[LinkedIn Profile](YOUR-LINKEDIN-URL) · [Email](mailto:YOUR-EMAIL-ADDRESS)

---

*Developed as an independent data analytics portfolio project using a fictional South African wholesale distribution business and simulated transactional data.*
