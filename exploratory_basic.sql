-- ======================
-- BASIC EXPLORATORY QUERIES
-- ======================

-- 1. Total number of patients
SELECT COUNT(*) AS total_patients
FROM patients;

-- 2. Total number of appointments
SELECT COUNT(*) AS total_appointments
FROM appointments;

-- 3. Appointments by status
SELECT status, COUNT(*) AS total_status_type
FROM appointments
GROUP BY status;

-- 4. Doctor count by specialization
SELECT specialization, COUNT(*) AS num_doctors
FROM doctors
GROUP BY specialization;

-- 5. Top 5 most common reasons for visit
SELECT reason_for_visit, COUNT(*) AS count
FROM appointments
GROUP BY reason_for_visit
ORDER BY count DESC
LIMIT 5;
