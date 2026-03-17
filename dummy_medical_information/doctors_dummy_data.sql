--Create database & schema
--Use database & schema
CREATE DATABASE IF NOT EXISTS dummy_datasets;
USE DATABASE dummy_datasets;
CREATE SCHEMA IF NOT EXISTS schema_for_dummy_data;
USE SCHEMA schema_for_dummy_data;

--Create dummy doctor information table
CREATE TABLE IF NOT EXISTS dummy_doctor_information (
    "doctor_id" NUMBER(38,0) AUTOINCREMENT START 1 INCREMENT 1 UNIQUE PRIMARY KEY,
    "hospital_id" INTEGER,
     CONSTRAINT fk_hospital_id FOREIGN KEY ("hospital_id") REFERENCES dummy_hospital_infromation ("hospital_id"),
    "first_name" VARCHAR(50),
    "last_name" VARCHAR(50),
    "gender" VARCHAR(1),
    "date_of_birth" DATE,
    "specialization" VARCHAR(30),
    "department"  VARCHAR(30),
    "license_number" VARCHAR(10),
    "phone_number" VARCHAR(30),
    "email" VARCHAR(50),
    "years_of_experience" INTEGER,
    "employment_type" VARCHAR(30),
    "registration_date" DATE,
    "status" VARCHAR(30)
);

--Set variables for data generation
SET hospital_number_count = (SELECT COUNT("hospital_id") FROM dummy_hospital_infromation);
SET number_of_rows_to_be_generated = 1000;
SET doctors_birthdate_start = 1950;
SET doctors_birthdate_end = 2000;
SET years_needed_for_graduation = 26;

--Populate the table
INSERT INTO dummy_doctor_information("hospital_id", "first_name", "last_name", "gender", "date_of_birth", "specialization",
    "department", "license_number", "phone_number", "email", "years_of_experience", "employment_type",
    "registration_date", "status")
SELECT 
    UNIFORM(0, $hospital_number_count, RANDOM()),
    NULL,
    NULL,
    ARRAY_CONSTRUCT('M', 'F')[UNIFORM(0, 1, RANDOM())],
    DATE_FROM_PARTS(
        UNIFORM($doctors_birthdate_start, $doctors_birthdate_end, RANDOM()),
        UNIFORM(1, 12, RANDOM()),
        UNIFORM(1, 29, RANDOM())
    ) AS birth_date,
    ARRAY_CONSTRUCT(
        'Cardiology',
        'Dermatology',
        'Neurology',
        'Orthopedics',
        'Pediatrics',
        'Psychiatry',
        'Radiology',
        'Oncology',
        'Gastroenterology',
        'Endocrinology',
        'Nephrology',
        'Pulmonology',
        'Rheumatology',
        'Hematology',
        'Infectious Disease',
        'Allergy and Immunology',
        'Anesthesiology',
        'Emergency Medicine',
        'Family Medicine',
        'Internal Medicine',
        'Obstetrics',
        'Gynecology',
        'Urology',
        'Ophthalmology',
        'Otolaryngology',
        'Pathology',
        'Plastic Surgery',
        'General Surgery',
        'Geriatrics',
        'Sports Medicine'
    )[UNIFORM(0, 29, RANDOM())],
    ARRAY_CONSTRUCT(
        'Cardiology',
        'Neurology',
        'Orthopedics',
        'Pediatrics',
        'Psychiatry',
        'Radiology',
        'Oncology',
        'Emergency',
        'Internal Medicine',
        'General Surgery',
        'Obstetrics',
        'Gynecology',
        'Dermatology',
        'Ophthalmology',
        'Otolaryngology',
        'Urology',
        'Endocrinology',
        'Nephrology',
        'Pulmonology',
        'Gastroenterology',
        'Infectious Diseases',
        'Hematology',
        'Rheumatology',
        'Allergy and Immunology',
        'Anesthesiology'
    )[UNIFORM(0, 25, RANDOM())],
    'LIC-' || RANDSTR(6, RANDOM()),
    UNIFORM(0, 999, RANDOM()) || '-' || UNIFORM(100000,999999, RANDOM()),
    NULL,
    YEAR(CURRENT_DATE()) - YEAR(birth_date) - $years_needed_for_graduation as experience,
    CASE 
        WHEN experience >= 0 AND experience < 5 THEN
            ARRAY_CONSTRUCT('Intern', 'Resident')[UNIFORM(0, 1, RANDOM())]
        WHEN experience >= 5 AND experience < 10 THEN
            ARRAY_CONSTRUCT('Part-Time', 'Contract', 'Fellow')[UNIFORM(0, 2, RANDOM())]
        WHEN experience >= 10 AND experience < 20 THEN
            ARRAY_CONSTRUCT('Full-Time', 'Consultant', 'Visiting Specialist')[UNIFORM(0, 2, RANDOM())]
        WHEN experience >= 20 THEN
            ARRAY_CONSTRUCT('Full-Time', 'Consultant', 'On-Call')[UNIFORM(0, 2, RANDOM())]
    ELSE NULL END,
    DATE_FROM_PARTS(
        YEAR(birth_date) + $years_needed_for_graduation,
        UNIFORM(1, 12, RANDOM()),
        UNIFORM(1, 28, RANDOM())
    ), 
    ARRAY_CONSTRUCT('full-time', 'part-time', 'inactive')[UNIFORM(0, 2, RANDOM())]
FROM TABLE(GENERATOR(ROWCOUNT => $number_of_rows_to_be_generated));

--Populate name, surname & email using dummy user data table
UPDATE dummy_doctor_information a
    SET a."first_name" = b."first_name" , a."last_name" = b."last_name" , a."email" = b."email"
FROM dummy_user_data b;

--Result
SELECT * FROM dummy_doctor_information;