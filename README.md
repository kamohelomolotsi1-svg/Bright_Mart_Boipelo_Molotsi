# Bright Mart Express ETL Pipeline

This repository contains the full end-to-end SQL Server ETL pipeline I built for Bright Mart Express. I took raw retail transaction data, transformed it into a structured warehouse model, and created a reporting-ready analytics environment that supports business questions around sales, customer loyalty, store performance, inventory, and revenue trends.

## Project overview

I designed and implemented a layered data warehouse solution with the following flow:

1. Raw source data intake
2. Staging layer for raw and standardized data
3. Clean layer for validated and business-ready dimensions
4. Data warehouse layer with dimensional tables and a fact table
5. Audit logging and stored procedures for repeatable ETL execution
6. Analytical SQL queries for business reporting

This project reflects the full data engineering workflow I followed: ingest, structure, clean, load, validate, and report.

## What I built

I built a retail analytics solution in SQL Server that includes:

- A staging database for raw source data
- A clean database for standardized dimension data
- A data warehouse database for analytics-ready dimensions and facts
- A star-schema-style structure with dimensions such as customer, product, store, date, payment, and employment
- A fact table for sales transactions
- Audit logging for ETL monitoring
- Stored procedures to automate loading and maintain data quality

## Architecture diagram

![Bright Mart Express ETL architecture](6.0.%20ETL_Pipeline_Screenshots/bright_mart_express_diagram.PNG)

## Step-by-step ETL pipeline I implemented

### 1. Database setup
I created the supporting databases for the pipeline:

- stg_brightlearn_express for staging data
- clean_brightlearn_express for cleaned and standardized dimensions
- dwh_brightlearn_express for the final warehouse model

These databases were created so the data could move through separate layers rather than being loaded directly into the final reporting environment.

### 2. Raw data staging
I created a staging table to hold the incoming source data from the recovered BrightLearn raw dataset. This staging layer acts as the initial landing zone for raw transaction information before any transformation or validation takes place.

The staging structure includes fields such as:

- transaction date
- payment method
- customer details
- store details
- product details
- quantities and financial values
- stock and reorder information

This stage was important because it preserved the original source structure before the business logic was applied.

### 3. Dimension staging tables
I then created separate staging dimension tables for the main business entities:

- stg_dim_customer
- stg_dim_date
- stg_dim_product
- stg_dim_store
- stg_dim_payment
- stg_dim_employment

Each staging dimension was built to extract the relevant business attributes from the raw data and prepare them for the next transformation step.

### 4. Audit logging for staging loads
To make the ETL process traceable, I implemented audit tables and logging mechanisms for each staging load. These logs capture:

- batch identifiers
- procedure names
- table names
- layer names
- start and end times
- load status
- row counts
- error messages when failures occur

This gave the pipeline operational visibility and made it easier to debug problems during loading.

### 5. Clean layer design
I created a clean layer to prepare dimension tables in a more business-ready form. In this layer, I focused on creating tables that were easier to load into the warehouse and more consistent for downstream reporting.

The clean dimensions included:

- clean_dim_customer
- clean_dim_date
- clean_dim_product
- clean_dim_store
- clean_dim_payment
- clean_dim_employment

This stage helped standardize the shape of the data before it entered the final warehouse tables.

### 6. Loading the clean dimensions
I loaded the clean dimension tables from the staging dimension tables using SQL scripts and stored procedures. These loads were designed to be repeatable and controlled, which is essential in an ETL pipeline that may need to be rerun or maintained later.

### 7. Creating the warehouse model
I built the final warehouse structure in the dwh_brightlearn_express database. The warehouse contains:

- dwh_dim_customer
- dwh_dim_date
- dwh_dim_product
- dwh_dim_store
- dwh_dim_payment
- dwh_dim_employment
- dwh_fact_sales

The fact table stores sales transaction facts and links to the dimensions through foreign keys. This makes the warehouse suitable for analytical reporting and star-schema-style queries.

### 8. Slowly Changing Dimension handling
For customer history, I implemented SCD Type 2 logic in the warehouse layer. This means that when a customer's attributes change, the system preserves historical records while marking the previous record as no longer current.

This was important because it allows the business to analyse customer history over time rather than losing prior values when a customer profile changes.

### 9. Fact table design
I created the sales fact table with measures and dimensions that allow business users to ask meaningful questions such as:

- how much revenue was generated
- which products sold best
- which stores performed best
- how customer loyalty tiers behave
- how inventory and reorder thresholds compare to stock on hand

### 10. Business reporting queries
I also wrote analytical SQL queries to answer key business questions. These queries use the warehouse dimensions and fact table to report on revenue, growth, loyalty, store performance, inventory, and product demand.

## Layer summary

| Layer | Purpose | Main objects |
|---|---|---|
| Source | Raw retail transaction data | BrightLearn raw dataset |
| Staging | Initial landing and structure for raw data | stg_BrightLearn_Data, stg_dim_* |
| Clean | Standardized and business-ready dimension data | clean_dim_* |
| Warehouse | Final analytics model | dwh_dim_*, dwh_fact_sales |
| Audit | ETL monitoring and traceability | etl_audit_log |

## Screenshots from the ETL pipeline

These screenshots illustrate the pipeline structure and the ETL outputs I created:

- Architecture and data flow overview
  ![Architecture overview](6.0.%20ETL_Pipeline_Screenshots/bright_mart_express_diagram.PNG)

- Staging and audit logging examples
  ![Staging audit log](6.0.%20ETL_Pipeline_Screenshots/audit_logging_stg_dim_customer.PNG)

- Clean dimension audit results
  ![Clean dimension audit](6.0.%20ETL_Pipeline_Screenshots/audit_logging_clean_dim_customer.PNG)

- Warehouse dimension audit results
  ![Warehouse audit example](6.0.%20ETL_Pipeline_Screenshots/audit_logging_dwh_dim_customer.PNG)

- Fact table and warehouse reporting outputs
  ![Warehouse fact sales audit](6.0.%20ETL_Pipeline_Screenshots/audit_logging_dwh_fact_sales.PNG)

- Data analysis and grouping examples
  ![Data analysis screenshot 1](6.0.%20ETL_Pipeline_Screenshots/data_analysis_group_related_data_1.PNG)
  ![Data analysis screenshot 2](6.0.%20ETL_Pipeline_Screenshots/data_analysis_group_related_data_2.PNG)
  ![Data analysis screenshot 3](6.0.%20ETL_Pipeline_Screenshots/data_analysis_group_related_data_3.PNG)

## Business questions I answered

The reporting SQL includes answers to the following business questions:

1. Top 5 best-selling products by revenue
2. Revenue per store by month
3. Month-over-month revenue growth
4. Top 10 loyalty customers by spend
5. Customers who have not purchased since a given date
6. Average transaction value by loyalty tier
7. Total quantity sold by product category and store
8. Store-product combinations near or below reorder thresholds

## Folder structure

The project is organized in numbered folders to reflect the ETL sequence:

- 0.1. create_brightlearn_express_db
- 0.2. import_brightlean_raw_data
- 0.3. create_stg_brightlearn_express_data
- 0.4. create_stg_dim
- 0.5. create_audit_stg_tables__stg_clean_dwh
- 0.6. create_audit_dim
- 0.7. create_clean_dim
- 0.8. create_audit_logging_clean_dim
- 0.9. load_clean_dim
- 1.0. clean_dim_stored_procedures
- 2.0. create_dwh_dim
- 3.0. load_dwh_dim
- 4.0. create_audit_logging_dwh_dim
- 5.0. dwh_scd_stored_procedure
- 6.0. ETL_Pipeline_Screenshots

## How to run the pipeline

1. Open SQL Server Management Studio.
2. Run the database creation scripts in the numbered order shown above.
3. Execute the staging scripts to create and populate the staging tables.
4. Run the clean-layer creation and load scripts.
5. Run the warehouse creation and load scripts.
6. Execute the stored procedures for the DWH dimension loads and SCD logic.
7. Run the analytics SQL queries to generate business insights.

## Reflection

This project helped me practise the core responsibilities of a data engineer: building a reliable ETL pipeline, managing data quality, designing warehouse structures, tracking load activity, and turning raw data into useful business information. It also gave me a strong foundation in SQL-based data modeling, dimensional design, and reporting.
