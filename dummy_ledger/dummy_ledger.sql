--Create database & schema
--Use database & schema
CREATE DATABASE IF NOT EXISTS dummy_datasets;
USE DATABASE dummy_datasets;
CREATE SCHEMA IF NOT EXISTS schema_for_dummy_data;
USE SCHEMA schema_for_dummy_data;

--Create dummy ledger table
CREATE TABLE IF NOT EXISTS dummy_ledger_debit (
    "date" DATETIME,
    "account_description" VARCHAR(50),
    "reference" VARCHAR(10),
    "debit" FLOAT,
    "credit"  FLOAT,
    "accountant_id" INTEGER
);

--Set these values as variables so that they can be altered
SET number_of_rows_to_be_generated = 1000;
SET year_to_begin_generation_from = '2025';
SET maximum_debit_credit_value = 1000000;

--Populate the table, debit side first
INSERT INTO dummy_ledger_debit
SELECT 
    DATEADD(minute, seq1(), ($year_to_begin_generation_from || '-01-01')::DATE),
    ARRAY_CONSTRUCT(
            'Cash',
            'Bank',
            'Accounts Receivable',
            'Accounts Payable',
            'Sales Revenue',
            'Purchase Expense',
            'Office Supplies',
            'Utilities Expense',
            'Rent Expense',
            'Salaries Expense',
            'Inventory',
            'Cost of Goods Sold',
            'Marketing Expense',
            'Insurance Expense',
            'Maintenance Expense',
            'Travel Expense',
            'Telephone Expense',
            'Internet Expense',
            'Equipment',
            'Depreciation Expense',
            'Interest Expense',
            'Interest Income',
            'Capital',
            'Drawings',
            'Taxes Payable',
            'Loans Payable',
            'Consulting Revenue',
            'Service Revenue',
            'Freight Expense',
            'Miscellaneous Expense'
            )[UNIFORM(0, 29, RANDOM())],
    'REF' || UNIFORM(0, 999, RANDOM()),
    UNIFORM(0.1::FLOAT, $maximum_debit_credit_value::FLOAT, RANDOM()) as debit,
    NULL,
    UNIFORM(0, 999, RANDOM())
FROM TABLE(GENERATOR(ROWCOUNT => $number_of_rows_to_be_generated));

--Create credit side as debit side
--Alter debit accordingly
CREATE TABLE IF NOT EXISTS dummy_ledger_credit CLONE dummy_ledger_debit;
UPDATE dummy_ledger_credit SET "credit" = "debit";
UPDATE dummy_ledger_credit SET "debit" = NULL;

--Create main table: dummy_ledger
CREATE TABLE IF NOT EXISTS dummy_ledger AS
SELECT * FROM dummy_ledger_credit UNION ALL SELECT * FROM dummy_ledger_debit;

--Separate tables debit & credit are no longer needed so they're dropped
DROP TABLE dummy_ledger_credit;
DROP TABLE dummy_ledger_debit;

--Result
SELECT * FROM dummy_ledger;
