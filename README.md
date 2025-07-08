# 💳 Credit Card Transactions Analysis (India)

This SQL project analyzes credit card transactions across various cities and card types in India. The analysis focuses on user spending patterns, trends across expense types, and interesting business questions.

## 📦 Dataset

**Source**: [Kaggle Dataset](https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india)

- Columns cleaned: lowercase + spaces replaced with underscores
- Imported into SQL Server table: `credit_card_transcations`

## 🛠 Tools

- SQL Server 
- GitHub for version control

## 🧹 Data Preparation

- Removed nulls and cleaned column names
- Converted data types appropriately (e.g., `amount` to `FLOAT`, `date` to `DATETIME`)

## 📊 Key Business Questions Solved

| # | Question |
|---|----------|
| 1 | Top 5 cities with highest spends and % contribution |
| 2 | Highest spend month for each card type |
| 3 | Transaction when each card reached ₹1M cumulative |
| 4 | City with lowest % gold card spend |
| 5 | City-wise highest and lowest expense types |
| 6 | Female spend contribution by expense type |
| 7 | Highest MoM growth (Jan 2014) by card + expense type |
| 8 | Weekend city with highest spend/transaction ratio |
| 9 | City that reached 500th transaction fastest |

> All solutions are available in `sql/credit_card_analysis.sql`.

## 📈 Summary of Findings

- **Mumbai** contributes the most to total credit card spends.
- **Fuel** is the most common expense type.
- **Platinum cards** saw the highest growth in Jan 2014.
- **Delhi** has the highest weekend spend efficiency.
- **Chennai** reached 500 transactions the fastest after first txn.
