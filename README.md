# 🥦 Post-Harvest Food Loss & Waste (FLW) & Scope 3 Carbon Diagnostic

## 📌 Executive Project Overview
This repository contains a comprehensive Post-Harvest Food Loss & Waste (FLW) & Scope 3 Carbon Accounting Pipeline auditing 1,000 perishable shipment logs (22,326.00 Tonnes) across 6 key agricultural hubs in India (Nashik, Ratnagiri, Jalgaon, Kolar, Guntur, and Lasalgaon).

The project quantifies physical spoilage tonnage, financial gross margin write-offs, and embodied greenhouse gas emissions lost across 4 supply chain nodes: Farmgate Loading, Packhouse Sorting, Cold Storage, and Port Distribution Terminals.

### Top-Line Diagnostic Summary:
- Total Dispatched Tonnage: 22,326.00 Tonnes
- Total Spoilage Loss: 2,659.21 Tonnes (11.91% physical loss rate)
- Total Financial Loss: ₹26.59 Crores (₹265.90 Million)
- Embodied Scope 3 Carbon Loss: 4,382.09 Tonnes CO2e
- CapEx Payback Period (Solar Packhouse): 0.6 Months (~18 Days)
- Audit Reconciliation Variance: ₹0.00 / 0.00 Tons

---

## 🗂️ Repository Directory Structure

```text
food-loss-waste-cold-chain-carbon-diagnostic/
│
├── README.md                             <-- Master project documentation & architecture
├── EXECUTIVE_REPORT_FOOD_LOSS_CARBON.md  <-- Executive brief & ESG carbon audit
│
├── data/
│   ├── food_loss_waste_raw.csv           <-- Raw 1,000 shipment logs with messy records
│   ├── food_loss_waste_clean.csv         <-- Cleaned dataset with loss & carbon metrics
│   ├── flw_node_summary.csv              <-- Node & crop aggregation export for BI
│   └── food_loss_carbon.db               <-- SQLite relational database warehouse
│
├── sql/
│   └── 02_flw_carbon_queries.sql         <-- Production SQL queries (CTEs, RANK() OVER)
│
├── excel/
│   └── flw_carbon_payback_reconciliation.xlsx <-- Audit-ready Excel payback workbook
│
└── notebooks/
    └── 01_food_loss_waste_analysis.ipynb <-- Jupyter notebook covering Pandas & carbon logic
```

---

## ⚙️ Multi-Tool Pipeline Architecture

### 🐍 Phase 1: Python Data Cleaning & Carbon Accounting (Pandas)
* Ingested 1,000 raw shipment records (`food_loss_waste_raw.csv`), handled duplicate receipts, standardized text casing, and imputed missing temperature parameters.
* Computed physical loss percentage, financial loss (INR), and embodied Scope 3 carbon footprint.

### 🗄️ Phase 2: Relational SQL Warehousing (SQLite)
* Constructed `food_loss_carbon.db` with relational tables (`shipment_loss_logs`, `node_summary`, `crop_emission_factors`).
* Executed advanced SQL queries utilizing Window Functions (`RANK() OVER`) to identify high-temperature breach clusters and quantify regional loss mitigation potential.

### 📊 Phase 3: Excel Audit & CapEx Payback Model
* Built `flw_carbon_payback_reconciliation.xlsx` featuring dynamic `SUMIF`, `XLOOKUP`, and `IF` verification tags.
* Proved zero financial variance (₹0.00) between SQL queries and spreadsheet log sums.

---

## 🚀 How to Reproduce

1. Python Environment: Run the Jupyter Notebook in `notebooks/01_food_loss_waste_analysis.ipynb`.
2. SQLite Database: Query the relational database `data/food_loss_carbon.db`.
3. Excel Workbook: Open `excel/flw_carbon_payback_reconciliation.xlsx`.
