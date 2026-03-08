-- =====================================================================
-- AASHA MEDIX — Phase 3 Migration Script
-- Run this in the Supabase SQL Editor for the project:
-- https://wyytvrukflhphukmltvn.supabase.co
--
-- This script is IDEMPOTENT — safe to run multiple times.
-- It uses IF NOT EXISTS / ON CONFLICT DO NOTHING throughout.
-- =====================================================================

-- ─────────────────────────────────────────────────────────────────────
-- SECTION 1: VERIFY CORE TABLES EXIST (Phase 3 schema audit)
-- Run these SELECT statements to check which tables are present.
-- ─────────────────────────────────────────────────────────────────────

-- Check existing tables:
-- SELECT table_name FROM information_schema.tables
-- WHERE table_schema = 'public'
-- ORDER BY table_name;


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 2: ENSURE CORE TABLES EXIST
-- (patients, diagnostic_tests, health_packages, bookings,
--  doctors, nursing_requests, medicine_orders, reports)
-- These may already exist — creating only if missing.
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS patients (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  name          TEXT NOT NULL,
  email         TEXT,
  phone         TEXT,
  date_of_birth DATE,
  gender        TEXT CHECK (gender IN ('male', 'female', 'other')),
  address       TEXT,
  blood_group   TEXT,
  emergency_contact TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS diagnostic_tests (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "testId"      TEXT UNIQUE NOT NULL,
  "testName"    TEXT NOT NULL,
  category      TEXT NOT NULL,
  "sampleType"  TEXT NOT NULL,
  "reportingTime" TEXT NOT NULL,
  price         NUMERIC(10,2) NOT NULL,
  description   TEXT,
  "isPopular"   BOOLEAN DEFAULT FALSE,
  "isActive"    BOOLEAN DEFAULT TRUE,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS health_packages (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "packageId"       TEXT UNIQUE NOT NULL,
  "packageName"     TEXT NOT NULL,
  "includedTests"   TEXT[] NOT NULL,
  "originalPrice"   NUMERIC(10,2) NOT NULL,
  "discountedPrice" NUMERIC(10,2) NOT NULL,
  description       TEXT,
  "isActive"        BOOLEAN DEFAULT TRUE,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS bookings (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id      UUID REFERENCES patients(id) ON DELETE SET NULL,
  service_type    TEXT NOT NULL CHECK (service_type IN ('diagnostics','doctor','nursing','medicine','home_sample')),
  test_or_package TEXT,
  scheduled_time  TIMESTAMPTZ,
  address         TEXT,
  status          TEXT NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','confirmed','in_progress','completed','cancelled')),
  notes           TEXT,
  total_amount    NUMERIC(10,2),
  payment_status  TEXT DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid','paid','refunded')),
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS doctors (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            TEXT NOT NULL,
  specialization  TEXT NOT NULL,
  qualification   TEXT,
  experience_years INT DEFAULT 0,
  consultation_fee NUMERIC(10,2),
  profile_image   TEXT,
  bio             TEXT,
  is_active       BOOLEAN DEFAULT TRUE,
  phone           TEXT,
  email           TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Ensure the column exists if the table was created in an earlier migration (e.g. as is_available)
ALTER TABLE doctors ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;


CREATE TABLE IF NOT EXISTS nursing_requests (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id        UUID REFERENCES bookings(id) ON DELETE CASCADE,
  assigned_nurse_id UUID,
  care_type         TEXT NOT NULL,
  visit_status      TEXT DEFAULT 'pending'
                    CHECK (visit_status IN ('pending','assigned','in_progress','completed','cancelled')),
  visit_notes       TEXT,
  scheduled_at      TIMESTAMPTZ,
  completed_at      TIMESTAMPTZ,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS medicine_orders (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id       UUID REFERENCES patients(id) ON DELETE SET NULL,
  prescription_url TEXT,
  items            JSONB DEFAULT '[]',
  delivery_address TEXT NOT NULL,
  status           TEXT DEFAULT 'pending'
                   CHECK (status IN ('pending','confirmed','dispatched','delivered','cancelled')),
  total_amount     NUMERIC(10,2),
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  updated_at       TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reports (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id       UUID REFERENCES patients(id) ON DELETE CASCADE,
  booking_id       UUID REFERENCES bookings(id) ON DELETE SET NULL,
  report_type      TEXT NOT NULL,
  report_url       TEXT NOT NULL,
  lab_name         TEXT,
  doctor_name      TEXT,
  test_name        TEXT,
  report_date      DATE,
  notes            TEXT,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 3: NEW TABLES — CHAT SYSTEM
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS chat_rooms (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id  UUID REFERENCES patients(id) ON DELETE CASCADE,
  doctor_id   UUID REFERENCES doctors(id) ON DELETE SET NULL,
  room_type   TEXT DEFAULT 'patient_doctor'
              CHECK (room_type IN ('patient_doctor','support','ai')),
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS chat_messages (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id     UUID REFERENCES chat_rooms(id) ON DELETE CASCADE NOT NULL,
  sender_id   UUID NOT NULL,
  sender_role TEXT NOT NULL CHECK (sender_role IN ('patient','doctor','ai','admin')),
  message     TEXT NOT NULL,
  message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text','image','file','ai')),
  file_url    TEXT,
  is_read     BOOLEAN DEFAULT FALSE,
  timestamp   TIMESTAMPTZ DEFAULT NOW()
);

-- Enable realtime for chat tables
ALTER PUBLICATION supabase_realtime ADD TABLE chat_rooms;
ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 4: NEW TABLES — DOCTOR AVAILABILITY
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS doctor_availability (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  doctor_id      UUID REFERENCES doctors(id) ON DELETE CASCADE NOT NULL,
  day_of_week    INT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday
  start_time     TIME NOT NULL,
  end_time       TIME NOT NULL,
  slot_duration  INT NOT NULL DEFAULT 30, -- minutes
  is_active      BOOLEAN DEFAULT TRUE,
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (doctor_id, day_of_week, start_time)
);

CREATE TABLE IF NOT EXISTS consultation_slots (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  doctor_id    UUID REFERENCES doctors(id) ON DELETE CASCADE NOT NULL,
  slot_time    TIMESTAMPTZ NOT NULL,
  is_booked    BOOLEAN DEFAULT FALSE,
  booking_id   UUID REFERENCES bookings(id) ON DELETE SET NULL,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (doctor_id, slot_time)
);


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 5: NEW TABLES — REGIONAL OPERATIONS
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS zones (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  city            TEXT NOT NULL,
  zone_name       TEXT NOT NULL,
  pincode         TEXT,
  status          TEXT DEFAULT 'active' CHECK (status IN ('active','paused','closed')),
  capacity_limit  INT DEFAULT 100,
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (city, zone_name)
);


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 6: NEW TABLES — ADMIN ANALYTICS
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS admin_kpis (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  metric_name   TEXT NOT NULL,
  metric_value  TEXT NOT NULL,
  metric_unit   TEXT,
  zone_id       UUID REFERENCES zones(id) ON DELETE SET NULL,
  recorded_at   TIMESTAMPTZ DEFAULT NOW(),
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS scale_readiness_metrics (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  zone_id           UUID REFERENCES zones(id) ON DELETE CASCADE,
  patient_volume    INT DEFAULT 0,
  completion_rate   NUMERIC(5,2) DEFAULT 0.0, -- percentage 0-100
  revenue           NUMERIC(12,2) DEFAULT 0.0,
  avg_tat_hours     NUMERIC(5,2),
  repeat_rate       NUMERIC(5,2),
  created_at        TIMESTAMPTZ DEFAULT NOW()
);


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 7: NURSES TABLE (referenced by nursing_requests)
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS nurses (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name             TEXT NOT NULL,
  specialization   TEXT,
  qualification    TEXT,
  experience_years INT DEFAULT 0,
  phone            TEXT,
  email            TEXT,
  zone_id          UUID REFERENCES zones(id) ON DELETE SET NULL,
  is_active        BOOLEAN DEFAULT TRUE,
  created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- Fix the nursing_requests FK now that nurses table exists
ALTER TABLE nursing_requests
  DROP CONSTRAINT IF EXISTS nursing_requests_assigned_nurse_id_fkey;

ALTER TABLE nursing_requests
  ADD CONSTRAINT nursing_requests_assigned_nurse_id_fkey
  FOREIGN KEY (assigned_nurse_id) REFERENCES nurses(id) ON DELETE SET NULL;


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 8: ROW LEVEL SECURITY (RLS) POLICIES
-- ─────────────────────────────────────────────────────────────────────

-- Enable RLS on all tables
ALTER TABLE patients             ENABLE ROW LEVEL SECURITY;
ALTER TABLE diagnostic_tests     ENABLE ROW LEVEL SECURITY;
ALTER TABLE health_packages      ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings             ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctors              ENABLE ROW LEVEL SECURITY;
ALTER TABLE nursing_requests     ENABLE ROW LEVEL SECURITY;
ALTER TABLE medicine_orders      ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports              ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_rooms           ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages        ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_availability  ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultation_slots   ENABLE ROW LEVEL SECURITY;
ALTER TABLE zones                ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_kpis           ENABLE ROW LEVEL SECURITY;
ALTER TABLE scale_readiness_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE nurses               ENABLE ROW LEVEL SECURITY;

-- ──────────────────────────────────────────────────────────────────────
-- diagnostic_tests — publicly readable
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Public read diagnostic_tests" ON diagnostic_tests;
CREATE POLICY "Public read diagnostic_tests"
  ON diagnostic_tests FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────────────────
-- health_packages — publicly readable
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Public read health_packages" ON health_packages;
CREATE POLICY "Public read health_packages"
  ON health_packages FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────────────────
-- doctors — public read for active doctors
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Public read active doctors" ON doctors;
CREATE POLICY "Public read active doctors"
  ON doctors FOR SELECT USING (is_active = true);

-- ──────────────────────────────────────────────────────────────────────
-- doctor_availability — public read
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Public read doctor availability" ON doctor_availability;
CREATE POLICY "Public read doctor availability"
  ON doctor_availability FOR SELECT USING (is_active = true);

-- ──────────────────────────────────────────────────────────────────────
-- consultation_slots — public read
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Public read consultation slots" ON consultation_slots;
CREATE POLICY "Public read consultation slots"
  ON consultation_slots FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────────────────
-- zones — public read
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Public read zones" ON zones;
CREATE POLICY "Public read zones"
  ON zones FOR SELECT USING (true);

-- ──────────────────────────────────────────────────────────────────────
-- patients — own row only
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Patients: own row select" ON patients;
CREATE POLICY "Patients: own row select"
  ON patients FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Patients: own row insert" ON patients;
CREATE POLICY "Patients: own row insert"
  ON patients FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Patients: own row update" ON patients;
CREATE POLICY "Patients: own row update"
  ON patients FOR UPDATE USING (auth.uid() = user_id);

-- ──────────────────────────────────────────────────────────────────────
-- bookings — patient owns their bookings only
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Bookings: read own" ON bookings;
CREATE POLICY "Bookings: read own"
  ON bookings FOR SELECT
  USING (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

DROP POLICY IF EXISTS "Bookings: insert own" ON bookings;
CREATE POLICY "Bookings: insert own"
  ON bookings FOR INSERT
  WITH CHECK (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

-- ──────────────────────────────────────────────────────────────────────
-- nursing_requests — patient can view their own via bookings
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Nursing requests: read own" ON nursing_requests;
CREATE POLICY "Nursing requests: read own"
  ON nursing_requests FOR SELECT
  USING (
    booking_id IN (
      SELECT id FROM bookings
      WHERE patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid())
    )
  );

DROP POLICY IF EXISTS "Nursing requests: insert own" ON nursing_requests;
CREATE POLICY "Nursing requests: insert own"
  ON nursing_requests FOR INSERT
  WITH CHECK (
    booking_id IN (
      SELECT id FROM bookings
      WHERE patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid())
    )
  );

-- ──────────────────────────────────────────────────────────────────────
-- medicine_orders — patient-owned
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Medicine orders: read own" ON medicine_orders;
CREATE POLICY "Medicine orders: read own"
  ON medicine_orders FOR SELECT
  USING (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

DROP POLICY IF EXISTS "Medicine orders: insert own" ON medicine_orders;
CREATE POLICY "Medicine orders: insert own"
  ON medicine_orders FOR INSERT
  WITH CHECK (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

-- ──────────────────────────────────────────────────────────────────────
-- reports — patient-owned
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Reports: read own" ON reports;
CREATE POLICY "Reports: read own"
  ON reports FOR SELECT
  USING (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

-- ──────────────────────────────────────────────────────────────────────
-- chat_rooms — patient participants only
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Chat rooms: participants read" ON chat_rooms;
CREATE POLICY "Chat rooms: participants read"
  ON chat_rooms FOR SELECT
  USING (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

DROP POLICY IF EXISTS "Chat rooms: patient create" ON chat_rooms;
CREATE POLICY "Chat rooms: patient create"
  ON chat_rooms FOR INSERT
  WITH CHECK (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

-- ──────────────────────────────────────────────────────────────────────
-- chat_messages — room participants only
-- ──────────────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS "Chat messages: read by room participant" ON chat_messages;
CREATE POLICY "Chat messages: read by room participant"
  ON chat_messages FOR SELECT
  USING (
    room_id IN (
      SELECT id FROM chat_rooms
      WHERE patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid())
    )
  );

DROP POLICY IF EXISTS "Chat messages: insert by sender" ON chat_messages;
CREATE POLICY "Chat messages: insert by sender"
  ON chat_messages FOR INSERT
  WITH CHECK (sender_id = auth.uid());


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 9: INDEXES FOR PERFORMANCE
-- ─────────────────────────────────────────────────────────────────────

CREATE INDEX IF NOT EXISTS idx_bookings_patient_id       ON bookings(patient_id);
CREATE INDEX IF NOT EXISTS idx_bookings_status            ON bookings(status);
CREATE INDEX IF NOT EXISTS idx_bookings_service_type      ON bookings(service_type);
CREATE INDEX IF NOT EXISTS idx_nursing_requests_booking   ON nursing_requests(booking_id);
CREATE INDEX IF NOT EXISTS idx_medicine_orders_patient    ON medicine_orders(patient_id);
CREATE INDEX IF NOT EXISTS idx_reports_patient_id         ON reports(patient_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_room         ON chat_messages(room_id);
CREATE INDEX IF NOT EXISTS idx_chat_messages_timestamp    ON chat_messages(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_consultation_slots_doctor  ON consultation_slots(doctor_id, slot_time);
CREATE INDEX IF NOT EXISTS idx_doctor_availability_doctor ON doctor_availability(doctor_id);
CREATE INDEX IF NOT EXISTS idx_scale_readiness_zone       ON scale_readiness_metrics(zone_id, created_at DESC);
