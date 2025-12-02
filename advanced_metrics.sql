-- ======================
-- ADVANCED HEALTHCARE METRICS & ANALYSIS
-- ======================


-- 1. No-show rate per doctor
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(*) AS total_appointments,
    SUM(CASE WHEN a.status = 'no_show' THEN 1 ELSE 0 END) AS no_shows,
    ROUND(
        SUM(CASE WHEN a.status = 'no_show' THEN 1 ELSE 0 END) 
        / COUNT(*) * 100, 2
    ) AS no_show_rate
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, doctor_name
ORDER BY no_show_rate DESC;


-- 2. Revenue generated per doctor (based on treatments linked to appointments)
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    ROUND(SUM(t.cost), 2) AS total_revenue
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, doctor_name
ORDER BY total_revenue DESC;


-- 3. Patient lifetime value (total billing per patient)
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    ROUND(SUM(b.amount), 2) AS lifetime_value
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
GROUP BY p.patient_id, patient_name
ORDER BY lifetime_value DESC;


-- 4. Repeat visit rate (patients with >1 appointment)
SELECT 
    COUNT(*) AS repeat_patients,
    (
        COUNT(*) / (SELECT COUNT(*) FROM patients) * 100
    ) AS repeat_rate_percent
FROM (
    SELECT patient_id
    FROM appointments
    GROUP BY patient_id
    HAVING COUNT(*) > 1
) AS repeated;


-- 5. Doctor workload ranking using window functions
SELECT 
    doctor_id,
    COUNT(*) AS total_appointments,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS workload_rank
FROM appointments
GROUP BY doctor_id
ORDER BY workload_rank;


-- 6. Rolling 30-day appointment volume (window function)
SELECT 
    appointment_date,
    COUNT(*) AS daily_total,
    SUM(COUNT(*)) OVER (
        ORDER BY appointment_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS rolling_30d_volume
FROM appointments
GROUP BY appointment_date
ORDER BY appointment_date;


-- 7. Most profitable treatment types (based on billing)
SELECT 
    t.treatment_type,
    ROUND(SUM(b.amount), 2) AS total_revenue,
    COUNT(*) AS num_treatments
FROM billing b
JOIN treatments t ON b.treatment_id = t.treatment_id
GROUP BY t.treatment_type
ORDER BY total_revenue DESC;


-- 8. Average wait time between registration and first appointment
SELECT 
    p.patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    DATEDIFF(MIN(a.appointment_date), p.registration_date) AS days_until_first_appointment
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, patient_name
ORDER BY days_until_first_appointment;


-- 9. Doctor efficiency: average treatments per appointment
SELECT 
    d.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    ROUND(COUNT(t.treatment_id) / COUNT(DISTINCT a.appointment_id), 2) AS avg_treatments_per_appointment
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
LEFT JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.doctor_id, doctor_name
ORDER BY avg_treatments_per_appointment DESC;


-- 10. Peak appointment days (busiest weekdays ranked)
SELECT 
    DAYNAME(appointment_date) AS weekday,
    COUNT(*) AS total_appointments,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_busiest
FROM appointments
GROUP BY weekday
ORDER BY rank_busiest;
