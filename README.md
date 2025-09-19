Tables:
patients - Stores patient information

doctors - Stores doctor information

appointments - Manages appointment bookings

departments - Clinic departments/specialties

users - System users (doctors, admins)

Relationships:
One-to-Many: Doctor → Appointments

One-to-Many: Patient → Appointments

One-to-Many: Department → Doctors

Many-to-Many: Doctors ↔ Departments (through junction table)
