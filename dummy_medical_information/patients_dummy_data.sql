--Create database & schema
--Use database & schema
CREATE DATABASE IF NOT EXISTS dummy_datasets;
USE DATABASE dummy_datasets;
CREATE SCHEMA IF NOT EXISTS schema_for_dummy_data;
USE SCHEMA schema_for_dummy_data;

SET doctor_number_count = (SELECT COUNT("doctor_id") FROM dummy_doctor_information);
SET number_of_rows_to_be_generated = 1000;

--Create dummy patient information table
CREATE TABLE IF NOT EXISTS dummy_patient_information (
    "patient_id" NUMBER(38,0) AUTOINCREMENT START 1 INCREMENT 1 UNIQUE PRIMARY KEY,
    "primary_doctor_id" INTEGER,
    CONSTRAINT fk_doctor_id FOREIGN KEY ("primary_doctor_id") REFERENCES dummy_doctor_information ("doctor_id"),
    "first_name" VARCHAR(50),
    "last_name" VARCHAR(50),
    "gender" VARCHAR(1),
    "date_of_birth" DATE,
    "blood_type" VARCHAR(3),
    "phone_number"  VARCHAR(20),
    "email" VARCHAR(50),
    "address" VARCHAR(30),
    "city" VARCHAR(30),
    "country" VARCHAR(30),
    "insurance_provider" VARCHAR(30),
    "insurance_id" VARCHAR(30),
    "registration_date" DATE
);

--Populate the table
INSERT INTO dummy_patient_information("primary_doctor_id", "first_name", "last_name", "gender", "date_of_birth",
"blood_type", "phone_number", "email", "address", "city", "country", "insurance_provider",
"insurance_id", "registration_date")
SELECT 
    UNIFORM(0, $doctor_number_count, RANDOM()),
    NULL,
    NULL,
    ARRAY_CONSTRUCT('M', 'F')[UNIFORM(0, 1, RANDOM())],
    DATE_FROM_PARTS(
        UNIFORM(1940, 2026, RANDOM()),
        UNIFORM(1, 12, RANDOM()),
        UNIFORM(1, 28, RANDOM())
    ),
    ARRAY_CONSTRUCT('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')[UNIFORM(0, 7, RANDOM())],
    UNIFORM(0, 999, RANDOM()) || '-' || UNIFORM(100000,999999, RANDOM()),
    NULL,
     ARRAY_CONSTRUCT(
        '123 Maple St',
        '456 Oak Ave',
        '789 Pine Rd',
        '321 Cedar Blvd',
        '654 Birch Ln',
        '987 Spruce Dr',
        '159 Elm St',
        '753 Walnut Ave',
        '852 Chestnut Rd',
        '963 Hickory Blvd',
        '147 Aspen Ln',
        '258 Poplar St',
        '369 Sycamore Ave',
        '741 Willow Rd',
        '852 Magnolia Blvd',
        '963 Fir Ln',
        '159 Redwood St',
        '753 Sequoia Ave',
        '852 Alder Rd',
        '963 Larch Blvd',
        '135 Cypress Ln',
        '246 Dogwood St',
        '357 Beech Ave',
        '468 Cherry Rd',
        '579 Maple Blvd',
        '680 Oak Ln',
        '791 Pine St',
        '802 Cedar Ave',
        '913 Birch Rd',
        '024 Spruce Blvd'
    )[UNIFORM(0, 29, RANDOM())],
    ARRAY_CONSTRUCT(
        'Springfield',
        'Fairview',
        'Riverside',
        'Greenville',
        'Madison',
        'Georgetown',
        'Salem',
        'Clinton',
        'Franklin',
        'Bristol',
        'Arlington',
        'Ashland',
        'Milton',
        'Oakland',
        'Winchester',
        'Centerville',
        'Newport',
        'Clayton',
        'Hudson',
        'Kingston',
        'Lexington',
        'Jackson',
        'Dayton',
        'Auburn',
        'Cleveland',
        'Lancaster',
        'Burlington',
        'Manchester',
        'Richmond',
        'Danville'
    )[UNIFORM(0, 29, RANDOM())],
    ARRAY_CONSTRUCT(
        'California',
        'Texas',
        'Florida',
        'New York',
        'Illinois',
        'Pennsylvania',
        'Ohio',
        'Georgia',
        'North Carolina',
        'Michigan',
        'New Jersey',
        'Virginia',
        'Washington',
        'Arizona',
        'Massachusetts',
        'Tennessee',
        'Indiana',
        'Missouri',
        'Maryland',
        'Wisconsin',
        'Colorado',
        'Minnesota',
        'South Carolina',
        'Alabama',
        'Louisiana',
        'Kentucky',
        'Oregon',
        'Oklahoma',
        'Connecticut',
        'Iowa'
    )[UNIFORM(0, 29, RANDOM())],
    ARRAY_CONSTRUCT('HealthGuard Insurance',
        'PrimeCare Assurance',
        'MedSecure Insurance',
        'LifeShield Health',
        'WellTrust Insurance',
        'SafeLife Coverage',
        'CarePlus Health Insurance',
        'VitalProtect Insurance',
        'Unity Health Assurance',
        'GuardianCare Insurance',
        'SecureLife Health',
        'BluePeak Insurance',
        'EverHealth Assurance',
        'NovaCare Insurance',
        'ShieldPlus Health',
        'Optima Health Insurance',
        'GoldenLife Assurance',
        'TrustMed Insurance',
        'SafeGuard Health',
        'HorizonCare Insurance')[UNIFORM(0, 19, RANDOM())],
    'IN' || '-' ||  RANDSTR(10, RANDOM()),
    DATE_FROM_PARTS(
        UNIFORM(2020, 2026, RANDOM()),
        UNIFORM(1, 12, RANDOM()),
        UNIFORM(1, 28, RANDOM())
    )
FROM TABLE(GENERATOR(ROWCOUNT => $number_of_rows_to_be_generated));

--Populate name, surname & email using dummy user data table
UPDATE dummy_patient_information a
    SET a."first_name" = b."first_name" , a."last_name" = b."last_name" , a."email" = b."email"
FROM dummy_user_data b;

--Result
SELECT * FROM dummy_patient_information;