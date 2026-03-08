-- =====================================================================
-- AASHA MEDIX — Phase 3.5 Schema Alignment Script
-- Run this in the Supabase SQL Editor for the project:
-- https://wyytvrukflhphukmltvn.supabase.co
--
-- This script only creates the MISSING infrastructure tables
-- and uses strict snake_case columns. 
-- It DOES NOT modify tests, doctors, bookings, reports, or patients.
-- =====================================================================

-- ─────────────────────────────────────────────────────────────────────
-- NEW TABLES
-- ─────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS health_packages (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  package_id        TEXT UNIQUE NOT NULL,
  package_name      TEXT NOT NULL,
  included_tests    TEXT[] NOT NULL,
  original_price    NUMERIC(10,2) NOT NULL,
  discounted_price  NUMERIC(10,2) NOT NULL,
  description       TEXT,
  is_active         BOOLEAN DEFAULT TRUE,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS nursing_requests (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id        UUID REFERENCES bookings(id) ON DELETE CASCADE,
  -- assigned_nurse_id UUID REFERENCES nurses(id) ON DELETE SET NULL, -- defined below after nurses table
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
-- ROW LEVEL SECURITY (RLS) POLICIES for the newly created tables
-- ─────────────────────────────────────────────────────────────────────

ALTER TABLE health_packages      ENABLE ROW LEVEL SECURITY;
ALTER TABLE nursing_requests     ENABLE ROW LEVEL SECURITY;
ALTER TABLE medicine_orders      ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctor_availability  ENABLE ROW LEVEL SECURITY;
ALTER TABLE consultation_slots   ENABLE ROW LEVEL SECURITY;
ALTER TABLE zones                ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_kpis           ENABLE ROW LEVEL SECURITY;
ALTER TABLE scale_readiness_metrics ENABLE ROW LEVEL SECURITY;
ALTER TABLE nurses               ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read health_packages" ON health_packages;
CREATE POLICY "Public read health_packages"
  ON health_packages FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read doctor_availability" ON doctor_availability;
CREATE POLICY "Public read doctor_availability"
  ON doctor_availability FOR SELECT USING (is_active = true);

DROP POLICY IF EXISTS "Public read consultation_slots" ON consultation_slots;
CREATE POLICY "Public read consultation_slots"
  ON consultation_slots FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read zones" ON zones;
CREATE POLICY "Public read zones"
  ON zones FOR SELECT USING (true);

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

DROP POLICY IF EXISTS "Medicine orders: read own" ON medicine_orders;
CREATE POLICY "Medicine orders: read own"
  ON medicine_orders FOR SELECT
  USING (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

DROP POLICY IF EXISTS "Medicine orders: insert own" ON medicine_orders;
CREATE POLICY "Medicine orders: insert own"
  ON medicine_orders FOR INSERT
  WITH CHECK (patient_id IN (SELECT id FROM patients WHERE user_id = auth.uid()));

-- ─────────────────────────────────────────────────────────────────────
-- INDEXES FOR PERFORMANCE
-- ─────────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_nursing_requests_booking   ON nursing_requests(booking_id);
CREATE INDEX IF NOT EXISTS idx_medicine_orders_patient    ON medicine_orders(patient_id);
CREATE INDEX IF NOT EXISTS idx_consultation_slots_doctor  ON consultation_slots(doctor_id, slot_time);
CREATE INDEX IF NOT EXISTS idx_doctor_availability_doctor ON doctor_availability(doctor_id);
CREATE INDEX IF NOT EXISTS idx_scale_readiness_zone       ON scale_readiness_metrics(zone_id, created_at DESC);
