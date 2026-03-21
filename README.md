# Randomized Datasets in Snowflake
Here, a code for generation various different randomized dataset can be found.
<br/>
<br/>
These datasets consist of various randomized data structures generated in Snowflake and are intended for general use across different scenarios. The data is entirely synthetic and created using the randomization functions available in Snowflake. It does not reference, replicate, or rely on any real-world data.
<br/>
<br/>
The datasets are designed primarily for testing, training, and development purposes. Users are free to modify and extend the structure to suit their specific requirements, as the provided datasets serve only as a baseline example of randomized data.
<br/>
<br/>
All datasets have been created using Snowflake technologies, including Snowflake SQL and Snowpark.

## 1. Dummy Ledger
Dummy Ledger is a fully randomized ledger dataset generated using Snowflake SQL. It contains synthetic financial entries and is intended purely for demonstration, testing, or training purposes. All values are randomly generated and do not represent any real financial data.
<br/> 
<br/>
The dataset includes the following columns:
<br/> 
<br/>
`"date" DATETIME,
  "account_description" VARCHAR(50),
  "reference" VARCHAR(10),
  "debit" FLOAT,
  "credit"  FLOAT
  "accountant_id" INTEGER`
<br/>
<br/>
The debit and credit values are mirrored. First, the debit entries are generated, and the corresponding credit values are created by mirroring those debit amounts.
<br/>
<br/>

## 2. Randomized Medical General Information Dataset

### Hospitals, Patients, Doctors & Medical Results Randomized Dummy Data
Although the data in this dataset is completely randomized, the relationships between entities are preserved through the use of `hospital_id`, `patient_id`, and `doctor_id`. These fields function as `PRIMARY KEY` and `FOREIGN KEY` references, ensuring that the tables remain properly linked and maintain a consistent relational structure.
<br/>
<br/>
<br/>
Dummy medical results table consists of following columns:
<br/>
 `"patient_id" INTEGER,
 CONSTRAINT fk_patient_id FOREIGN KEY ("patient_id") REFERENCES dummy_patient_information ("patient_id"),
 "doctor_id" INTEGER,
 CONSTRAINT fk_doctor_id FOREIGN KEY ("doctor_id") REFERENCES dummy_doctor_information ("doctor_id"),
 "visit_id" NUMBER(38,0) AUTOINCREMENT START 1 INCREMENT 1,
 "test_date" DATE,
 "test_name" VARCHAR(100),
 "test_type" VARCHAR(30),
 "test_result" FLOAT,
 "unit" VARCHAR(15),
 "reference_range_low" FLOAT,
 "reference_range_high" FLOAT,
 "result_flag" VARCHAR(20),
 "lab_id" INTEGER,
 "notes" VARCHAR(150)`
<br/>
<br/>
The database architecture, including the column names and the defined `PRIMARY KEY` and `FOREIGN KEY` relationships, is illustrated below.
<br/>
<p align="center">
  <img src="dummy_medical_information\medical_info_architecture.png" width="650">
</p>
<br/>
Please note that in this beta version, the name, surname, and email fields are populated from the dummy user table (see section 3). Ensure that this table is created before adding any dummy doctor or patient data.
<br/>
<br/>
The order in which tables should be created is as follows:
<br/>
1. Dummy hospital data <br/>
2. Dummy user data <br/>
3. Dummy doctor data <br/>
4. Dummy patient data<br/>
<br/>

## 3. Randomized Users Dataset
This randomized dataset generates synthetic user information, including first name, last name, and email address:
<br/> 
<br/>
`"first_name" VARCHAR(30),
  "last_name" VARCHAR(30),
  "email" VARCHAR(30)`
<br/>
<br/>
The dataset is created using Snowflake Snowpark in combination with the Random User API (https://randomuser.me/
). The API allows a maximum of 5000 records per request, and the implemented code retrieves up to 5000 randomly generated users per call. For each user, the name, surname, and email address are generated and then stored in the corresponding Snowflake table, from which the data can be further accessed and utilized.
<br/>
<br/>
Connection details are stored in the `connections` folder (ensure that a `.env` file is created). The Snowpark and Python implementation used to retrieve and insert the data can be found in the `dummy_user` folder.
