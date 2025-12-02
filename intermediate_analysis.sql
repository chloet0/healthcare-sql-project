-- ======================
-- INTERMEDIATE ANALYSIS QUERIES
-- ======================

-- 1. Appointment counts by doctor
SELECT doctor_id, COUNT(*) AS total_appointments
FROM appointments
GROUP BY doctor_id
ORDER BY total_appointments DESC;

-- 2. Patient age calculation
SELECT patient_id, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age
FROM patients;

-- 3. Monthly appointment trends
SELECT DATE_FORMAT(appointment_date, '%Y-%m') AS month, COUNT(*) AS num_appointments
FROM appointments
GROUP BY month
ORDER BY month;

-- 4. Most common reason for visit
SELECT reason_for_visit, COUNT(*) AS appointment_count
FROM appointments
GROUP BY reason_for_visit
ORDER BY appointment_count DESC;

-- 5. Total revenue by insurance provider
SELECT p.insurance_provider, ROUND(SUM(b.amount), 2) AS total_revenue
FROM billing b
JOIN patients p USING (patient_id)
GROUP BY insurance_provider;

-- 6. Patients with unpaid/failed bills
SELECT p.first_name, p.last_name, b.amount, b.bill_date
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
WHERE b.payment_status = 'failed';

-- 7. Doctors by specialization with average experience
SELECT specialization, AVG(years_experience) AS avg_experience, COUNT(*) AS num_doctors
FROM doctors
GROUP BY specialization
ORDER BY avg_experience DESC;

-- 8. Total treatment cost per patient
SELECT p.patient_id, p.first_name, p.last_name, ROUND(SUM(t.cost), 2) AS total_cost
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY total_cost DESC;

-- 9. Most frequent patients
SELECT p.first_name, p.last_name, COUNT(*) AS visit_count
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY a.patient_id, p.first_name, p.last_name
ORDER BY visit_count DESC
LIMIT 5;

-- 10. Treatments by type with avg cost
SELECT treatment_type, COUNT(*) AS total_treatments, ROUND(AVG(cost),2) AS avg_cost
FROM treatments
GROUP BY treatment_type
ORDER BY total_treatments DESC;
