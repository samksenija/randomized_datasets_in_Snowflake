--Create database & schema
--Use database & schema
CREATE DATABASE IF NOT EXISTS dummy_datasets;
USE DATABASE dummy_datasets;
CREATE SCHEMA IF NOT EXISTS schema_for_dummy_data;
USE SCHEMA schema_for_dummy_data;

--Create dummy medical results information table
CREATE TABLE IF NOT EXISTS dummy_medical_results (
    "patient_id" INTEGER,
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
    "notes" VARCHAR(150)
);

-- Declare number of rows to be generated
SET number_of_rows_to_be_generated = 1000;
SET patient_number_count = (SELECT COUNT("patient_id") FROM dummy_patient_information);
SET doctor_number_count = (SELECT COUNT("doctor_id") FROM dummy_doctor_information);
SET current_year = YEAR(CURRENT_DATE());

--Insert values into table
INSERT INTO dummy_medical_results("patient_id", "doctor_id", "test_date", "test_name", "test_type", "test_result", "unit", "reference_range_low", "reference_range_high", "result_flag", "lab_id", "notes")
SELECT
    UNIFORM(0, $patient_number_count, RANDOM()),
    UNIFORM(0, $doctor_number_count, RANDOM()),
    DATE_FROM_PARTS(
        UNIFORM(2020, $current_year, RANDOM()),
        UNIFORM(1, 12, RANDOM()),
        UNIFORM(1, 28, RANDOM())
    ),
    ARRAY_CONSTRUCT('Complete Blood Count',
        'Blood Glucose Test',
        'Lipid Panel',
        'Liver Function Test',
        'Kidney Function Test',
        'Thyroid Stimulating Hormone Test',
        'HbA1c Test',
        'Urinalysis',
        'Electrolyte Panel',
        'C-Reactive Protein Test',
        'Vitamin D Test',
        'Calcium Test',
        'Magnesium Test',
        'Iron Test',
        'Ferritin Test',
        'Prothrombin Time Test',
        'D-Dimer Test',
        'Troponin Test',
        'Blood Urea Nitrogen Test',
        'Creatinine Test',
        'Prostate Specific Antigen Test',
        'Pregnancy Test',
        'COVID-19 PCR Test',
        'Influenza Test',
        'Allergy Panel Test',
        'Stool Occult Blood Test',
        'Hormone Panel',
        'Cortisol Test',
        'Insulin Test',
        'Lactate Test')[UNIFORM(0, 29, RANDOM())] as test_name,
        CASE 
            WHEN test_name = 'Complete Blood Count' THEN 'Hematology'
            WHEN test_name = 'Blood Glucose Test' THEN 'Chemistry'
            WHEN test_name = 'Lipid Panel' THEN 'Chemistry'
            WHEN test_name = 'Liver Function Test' THEN 'Chemistry'
            WHEN test_name = 'Kidney Function Test' THEN 'Chemistry'
            WHEN test_name = 'Thyroid Stimulating Hormone Test' THEN 'Endocrinology'
            WHEN test_name = 'HbA1c Test' THEN 'Endocrinology'
            WHEN test_name = 'Urinalysis' THEN 'Urine Analysis'
            ELSE 'Other' END AS test_type,  
        CASE
            WHEN test_name = 'Complete Blood Count' THEN UNIFORM(4000,11000,RANDOM())
            WHEN test_name = 'Blood Glucose Test' THEN UNIFORM(70,140,RANDOM())
            WHEN test_name = 'Lipid Panel' THEN UNIFORM(120,250,RANDOM())
            WHEN test_name = 'Liver Function Test' THEN UNIFORM(10,50,RANDOM())
            WHEN test_name = 'Kidney Function Test' THEN UNIFORM(0.5,1.5,RANDOM())
            WHEN test_name = 'Thyroid Stimulating Hormone Test' THEN UNIFORM(0.4,4.0,RANDOM())
            WHEN test_name = 'HbA1c Test' THEN UNIFORM(4.0,6.0,RANDOM())
            WHEN test_name = 'Urinalysis' THEN UNIFORM(1,2,RANDOM())
            ELSE UNIFORM(0,100,RANDOM())
        END AS test_result,
        CASE
            WHEN test_name = 'Complete Blood Count' THEN 'cells/uL'
            WHEN test_name = 'Blood Glucose Test' THEN 'mg/dL'
            WHEN test_name = 'Lipid Panel' THEN 'mg/dL'
            WHEN test_name = 'Liver Function Test' THEN 'U/L'
            WHEN test_name = 'Kidney Function Test' THEN 'mg/dL'
            WHEN test_name = 'Thyroid Stimulating Hormone Test' THEN 'uIU/mL'
            WHEN test_name = 'HbA1c Test' THEN '%'
            WHEN test_name = 'Urinalysis' THEN 'pH'
            ELSE ''
        END AS test_unit,
        CASE
            WHEN test_name = 'Complete Blood Count' THEN 4000
            WHEN test_name = 'Blood Glucose Test' THEN 70
            WHEN test_name = 'Lipid Panel' THEN 120
            WHEN test_name = 'Liver Function Test' THEN 10
            WHEN test_name = 'Kidney Function Test' THEN 0.5
            WHEN test_name = 'Thyroid Stimulating Hormone Test' THEN 0.4
            WHEN test_name = 'HbA1c Test' THEN 4.0
            WHEN test_name = 'Urinalysis' THEN 1
            ELSE 0
        END AS reference_range_low,
        CASE
            WHEN test_name = 'Complete Blood Count' THEN 11000
            WHEN test_name = 'Blood Glucose Test' THEN 140
            WHEN test_name = 'Lipid Panel' THEN 250
            WHEN test_name = 'Liver Function Test' THEN 50
            WHEN test_name = 'Kidney Function Test' THEN 1.5
            WHEN test_name = 'Thyroid Stimulating Hormone Test' THEN 4.0
            WHEN test_name = 'HbA1c Test' THEN 6.0
            WHEN test_name = 'Urinalysis' THEN 2
            ELSE 100
        END AS reference_range_high,
        CASE 
            WHEN test_result < reference_range_low THEN 'Low'
            WHEN test_result > reference_range_high THEN 'High'
            ELSE 'Normal'
        END AS result_flag,
        UNIFORM(0, 450, RANDOM()),
        ARRAY_CONSTRUCT(
            'Patient fasting before test',
            'No known allergies',
            'Repeat test in 6 months',
            'Patient taking medication affecting results',
            'Abnormal reading, needs follow-up',
            'Patient advised to hydrate well',
            'Specimen hemolyzed, retest recommended',
            'Sample collected in morning',
            'Patient reports mild symptoms',
            'Routine annual checkup',
            'Patient instructed to avoid caffeine',
            'Test performed post-exercise',
            'Result within expected range',
            'Patient recently vaccinated',
            'Follow-up recommended if symptoms persist',
            'Patient on special diet',
            'Test delayed due to instrument calibration',
            'Specimen collected under fasting conditions',
            'Patient advised to rest before test',
            'Repeat test recommended for confirmation',
            'Patient experiencing mild fatigue',
            'Patient reports headache',
            'Specimen stored at incorrect temperature',
            'Patient instructed to fast 8 hours prior',
            'Sample quality verified',
            'Lab technician noted difficulty collecting sample',
            'Patient taking vitamin supplements',
            'Patient has recent surgery',
            'Specimen slightly hemolyzed',
            'Patient advised to avoid exercise before test',
            'Follow-up with primary physician',
            'Patient reports no symptoms',
            'Patient advised to take medication as usual',
            'Repeat sample collected due to clotting',
            'Patient recently traveled',
            'Sample transported overnight',
            'Patient shows elevated stress levels',
            'Results compared with previous visit',
            'Patient advised to monitor diet',
            'Patient instructed to avoid alcohol prior to test')[UNIFORM(0,39, RANDOM())]
FROM TABLE(GENERATOR(ROWCOUNT => $number_of_rows_to_be_generated));

--Result
SELECT * FROM dummy_medical_results;