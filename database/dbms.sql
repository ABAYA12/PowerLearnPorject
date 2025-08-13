-- Clinic Booking System (MySQL 8.0+) – DDL Only
-- Description: Core tables + constraints showing 1–1, 1–M, M–M relations
-- Notes:
--   * Uses InnoDB + utf8mb4 for modern MySQL defaults.
--   * Includes CHECK constraints (supported/enforced in MySQL 8.0.16+).
--   * Only CREATE TABLE statements, as requested.


-- Specializations (e.g., Cardiology, Pediatrics)
CREATE TABLE specialization (
  specialization_id     BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name                  VARCHAR(100) NOT NULL UNIQUE,
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Rooms (consulting, lab, etc.)
CREATE TABLE room (
  room_id               BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name                  VARCHAR(50) NOT NULL UNIQUE,
  room_type             ENUM('CONSULT','LAB','PROCEDURE','ADMIN') NOT NULL DEFAULT 'CONSULT',
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Medications (catalog)
CREATE TABLE medication (
  medication_id         BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  name                  VARCHAR(150) NOT NULL,
  strength              VARCHAR(50) NULL, -- e.g., "500 mg", "10 mg/ml"
  UNIQUE KEY uq_med_name_strength (name, strength),
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- People
-- =========================================================

-- Patients
CREATE TABLE patient (
  patient_id            BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  first_name            VARCHAR(80)  NOT NULL,
  last_name             VARCHAR(80)  NOT NULL,
  sex                   ENUM('M','F','O') NOT NULL,
  date_of_birth         DATE NOT NULL,
  phone                 VARCHAR(30) NOT NULL,
  email                 VARCHAR(120) NULL UNIQUE,
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  CHECK (date_of_birth <= CURRENT_DATE())
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 1:1 extension of patient (encapsulation of sensitive details)
CREATE TABLE patient_profile (
  patient_id            BIGINT UNSIGNED PRIMARY KEY,
  emergency_contact_name  VARCHAR(120) NULL,
  emergency_contact_phone VARCHAR(30)  NULL,
  blood_type            ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-') NULL,
  insurance_number      VARCHAR(60) NULL UNIQUE,
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Doctors
CREATE TABLE doctor (
  doctor_id             BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  first_name            VARCHAR(80)  NOT NULL,
  last_name             VARCHAR(80)  NOT NULL,
  email                 VARCHAR(120) NOT NULL UNIQUE,
  phone                 VARCHAR(30)  NOT NULL,
  hired_date            DATE NOT NULL,
  active                TINYINT(1) NOT NULL DEFAULT 1,
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (hired_date <= CURRENT_DATE())
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- M:M doctor <-> specialization
CREATE TABLE doctor_specialization (
  doctor_id             BIGINT UNSIGNED NOT NULL,
  specialization_id     BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (doctor_id, specialization_id),
  FOREIGN KEY (doctor_id)         REFERENCES doctor(doctor_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (specialization_id) REFERENCES specialization(specialization_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- Appointments & Clinical
-- =========================================================

-- Appointments (basic scheduling)
CREATE TABLE appointment (
  appointment_id        BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  patient_id            BIGINT UNSIGNED NOT NULL,
  doctor_id             BIGINT UNSIGNED NOT NULL,
  room_id               BIGINT UNSIGNED NULL,
  start_time            DATETIME NOT NULL,
  end_time              DATETIME NOT NULL,
  status                ENUM('SCHEDULED','CHECKED_IN','COMPLETED','CANCELLED','NO_SHOW') NOT NULL DEFAULT 'SCHEDULED',
  notes                 TEXT NULL,
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (room_id)   REFERENCES room(room_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  -- Prevent inverted times
  CHECK (end_time > start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Prevent exact double-booking of a doctor at the same start time
CREATE UNIQUE INDEX uq_appt_doctor_start
  ON appointment(doctor_id, start_time);

-- Prescriptions (1:M from appointment)
CREATE TABLE prescription (
  prescription_id       BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  appointment_id        BIGINT UNSIGNED NOT NULL,
  prescribed_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes                 TEXT NULL,
  FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- M:M prescription <-> medication with extra attributes
CREATE TABLE prescription_item (
  prescription_id       BIGINT UNSIGNED NOT NULL,
  medication_id         BIGINT UNSIGNED NOT NULL,
  dosage                VARCHAR(50)  NOT NULL,  
  frequency             VARCHAR(50)  NOT NULL,   
  duration_days         INT NOT NULL,
  instructions          TEXT NULL,
  PRIMARY KEY (prescription_id, medication_id),
  FOREIGN KEY (prescription_id) REFERENCES prescription(prescription_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (medication_id)   REFERENCES medication(medication_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CHECK (duration_days > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Billing

-- Invoices (one per appointment or manual bill for a patient)
CREATE TABLE invoice (
  invoice_id            BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  patient_id            BIGINT UNSIGNED NOT NULL,
  appointment_id        BIGINT UNSIGNED NULL UNIQUE, 
  issued_at             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  due_at                DATETIME NULL,
  total_amount          DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status                ENUM('DUE','PAID','VOID') NOT NULL DEFAULT 'DUE',
  notes                 TEXT NULL,
  FOREIGN KEY (patient_id)     REFERENCES patient(patient_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CHECK (total_amount >= 0),
  CHECK (due_at IS NULL OR due_at >= issued_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Payments (1:M to invoice)
CREATE TABLE payment (
  payment_id            BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  invoice_id            BIGINT UNSIGNED NOT NULL,
  amount                DECIMAL(10,2) NOT NULL,
  method                ENUM('CASH','CARD','MOBILE_MONEY','TRANSFER') NOT NULL,
  paid_at               DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  reference             VARCHAR(100) NULL,
  FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CHECK (amount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Helpful index to see payments per invoice chronologically
CREATE INDEX ix_payment_invoice_paidat ON payment(invoice_id, paid_at);

simple address model (1:M per patient)

CREATE TABLE patient_address (
  address_id            BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  patient_id            BIGINT UNSIGNED NOT NULL,
  address_line1         VARCHAR(120) NOT NULL,
  address_line2         VARCHAR(120) NULL,
  city                  VARCHAR(80)  NOT NULL,
  region                VARCHAR(80)  NULL,
  postal_code           VARCHAR(20)  NULL,
  country               VARCHAR(80)  NOT NULL,
  is_primary            TINYINT(1) NOT NULL DEFAULT 0,
  created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE UNIQUE INDEX uq_patient_primary_address
  ON patient_address(patient_id, is_primary)
  WHERE is_primary = 1;
