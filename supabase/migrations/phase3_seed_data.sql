-- =====================================================================
-- AASHA MEDIX — Diagnostics Catalog Seed Data
-- Run AFTER phase3_schema.sql
-- Project: https://wyytvrukflhphukmltvn.supabase.co
--
-- Inserts the diagnostic test catalog into the existing `tests` table.
-- Uses strict snake_case column names.
-- Prices are aligned with PRICELIST_50_TESTS.md.
-- =====================================================================

INSERT INTO tests (id, test_name, category, sample_type, reporting_time, price, mrp, description, status) VALUES
-- Blood Sugar Tests
('bs1','Fasting Blood Sugar (FBS)','Blood Sugar','Blood','Same Day',180.00,250.00,'Measures blood sugar level after 8-12 hours of fasting. Essential for diabetes screening.','active'),
('bs2','Post Prandial Blood Sugar (PPBS)','Blood Sugar','Blood','Same Day',180.00,250.00,'Checks blood sugar 2 hours after eating. Helps monitor post-meal glucose control.','active'),
('bs3','Random Blood Sugar (RBS)','Blood Sugar','Blood','Same Day',150.00,200.00,'Blood sugar test taken at any time, regardless of meals. Quick diabetes check.','active'),
('bs4','HbA1c (Glycated Hemoglobin)','Blood Sugar','Blood','24 Hours',400.00,500.00,'3-month average blood sugar control. Gold standard for diabetes monitoring.','active'),
('bs5','Glucose Tolerance Test (GTT)','Blood Sugar','Blood','24 Hours',300.00,450.00,'Comprehensive test for gestational diabetes and insulin resistance.','inactive'),
-- Hematology
('cbc1','Complete Blood Count (CBC)','Hematology','Blood','Same Day',299.00,400.00,'Comprehensive blood analysis including RBC, WBC, platelets, and hemoglobin levels.','active'),
('cbc2','Hemoglobin Test','Hematology','Blood','Same Day',150.00,250.00,'Measures oxygen-carrying protein in blood. Essential for anemia screening.','active'),
('cbc3','Blood Group & RH Factor','Hematology','Blood','Same Day',199.00,300.00,'Determines blood type and rhesus factor.','active'),
('cbc4','Peripheral Blood Smear (PBS)','Hematology','Blood','Same Day',250.00,350.00,'Microscopic examination of blood cells for morphological abnormalities.','active'),
('cbc5','Erythrocyte Sedimentation Rate (ESR)','Hematology','Blood','Same Day',180.00,250.00,'Inflammation marker. Helps diagnose infections, autoimmune diseases.','active'),
-- Liver Function Tests
('lft1','Liver Function Test (LFT)','Liver Function','Blood','Same Day',399.00,600.00,'Complete panel assessing total liver function and enzyme levels.','active'),
('lft6','Alkaline Phosphatase (ALP)','Liver Function','Blood','Same Day',199.00,300.00,'Bone and liver enzyme test. Elevated in liver diseases and bone disorders.','active'),
-- Kidney Function Tests
('kft1','Kidney Function Test (KFT)','Kidney Function','Blood','Same Day',399.00,600.00,'Complete panel assessing renal function and filtration rates.','active'),
('kft2','Serum Creatinine','Kidney Function','Blood','Same Day',150.00,250.00,'Most reliable kidney function marker. Essential for GFR calculation.','active'),
('kft3','Blood Urea Nitrogen (BUN)','Kidney Function','Blood','Same Day',150.00,250.00,'Nitrogen in blood urea. Used with creatinine for kidney function evaluation.','active'),
-- Lipid Profile
('lipid0','Lipid Profile (Complete)','Lipid Profile','Blood','Same Day',449.00,700.00,'Complete lipid analysis including Total, HDL, LDL, and Triglycerides.','active'),
('lipid1','Total Cholesterol','Lipid Profile','Blood','Same Day',249.00,350.00,'Overall cholesterol measurement for heart disease risk assessment.','active'),
('lipid2','HDL Cholesterol','Lipid Profile','Blood','Same Day',249.00,350.00,'"Good" cholesterol test. Higher levels protect against heart disease.','active'),
('lipid3','LDL Cholesterol','Lipid Profile','Blood','Same Day',249.00,350.00,'"Bad" cholesterol test. High levels increase heart disease risk.','active'),
('lipid4','Triglycerides','Lipid Profile','Blood','Same Day',199.00,300.00,'Blood fat test. Elevated levels linked to heart disease and diabetes.','active'),
-- Thyroid
('thyroid1','Total T3','Thyroid','Blood','24 Hours',399.00,550.00,'Active thyroid hormone test for hyperthyroidism and hypothyroidism.','active'),
('thyroid2','Total T4','Thyroid','Blood','24 Hours',399.00,550.00,'Main thyroid hormone test. Assesses thyroid gland function.','active'),
('thyroid3','TSH (Thyroid Stimulating Hormone)','Thyroid','Blood','24 Hours',299.00,450.00,'Pituitary thyroid control test. Most sensitive thyroid function indicator.','active'),
('thyroid4','Free T3','Thyroid','Blood','24 Hours',450.00,600.00,'Unbound active thyroid hormone. More accurate than total T3.','active'),
('thyroid5','Free T4','Thyroid','Blood','24 Hours',450.00,600.00,'Unbound thyroid hormone. Essential for thyroid disorder diagnosis.','active'),
-- Infection Markers
('inf1','C-Reactive Protein (CRP)','Infection Markers','Blood','Same Day',299.00,450.00,'Inflammation and infection marker. Helps diagnose bacterial infections.','active'),
('inf2','Rheumatoid Factor (RF)','Infection Markers','Blood','24 Hours',399.00,600.00,'Rheumatoid arthritis autoantibody test for joint inflammation diagnosis.','active'),
('inf3','Antinuclear Antibody (ANA)','Infection Markers','Blood','24 Hours',599.00,800.00,'Autoimmune disease screening test.','active'),
('inf4','Tuberculosis Gold Test (IGRA)','Infection Markers','Blood','48 Hours',1299.00,1800.00,'Highly specific test for active and latent TB infection.','active'),
-- Urine Analysis
('urine1','Routine Urine Test (Urinalysis)','Urine Analysis','Urine','Same Day',200.00,300.00,'Comprehensive urine analysis for infection, diabetes, and kidney function.','active'),
('urine2','Urine Microalbumin','Urine Analysis','Urine','48 Hours',299.00,400.00,'Detection of very small levels of blood protein (albumin) in urine.','active'),
('urine3','Urine 24-Hour Protein','Urine Analysis','Urine (24hr)','24 Hours',349.00,500.00,'Kidney damage assessment. Measures protein loss in urine over 24 hours.','active'),
-- Vitamins & Minerals
('vit1','Vitamin D (25-OH)','Vitamins','Blood','24 Hours',399.00,800.00,'Bone health and immune function vitamin. Deficiency causes rickets and osteomalacia.','active'),
('vit2','Vitamin B12','Vitamins','Blood','24 Hours',450.00,800.00,'Anemia and neurological function vitamin. Essential for red blood cell formation.','active'),
('iron1','Iron Studies (Serum Iron)','Iron Studies','Blood','24 Hours',399.00,600.00,'Complete iron metabolism assessment for anemia diagnosis and management.','active'),
('elec1','Serum Calcium','Bone Metamoblism','Blood','Same Day',199.00,350.00,'Measurement of calcium levels in blood.','active')
ON CONFLICT (id) DO UPDATE SET
  test_name      = EXCLUDED.test_name,
  price          = EXCLUDED.price,
  description    = EXCLUDED.description,
  status         = EXCLUDED.status;


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 2: HEALTH PACKAGES SEED
-- ─────────────────────────────────────────────────────────────────────

INSERT INTO health_packages (package_id, package_name, included_tests, original_price, discounted_price, description, is_active) VALUES
('pkg1','Basic Health Checkup',ARRAY['cbc1','bs1','lft1','kft1','lipid0'],1749.00,1299.00,'Essential health screening including CBC, blood sugar, liver & kidney function, and lipid profile.',true),
('pkg2','Comprehensive Health Checkup',ARRAY['cbc1','bs1','lft1','kft1','lipid0','thyroid3','vit1','vit2'],2898.00,2199.00,'Basic Checkup + TSH, Vitamin B12, and Vitamin D assessments.',true),
('pkg3','Women''s Health Checkup',ARRAY['cbc1','bs1','lft1','kft1','lipid0','thyroid3','vit1','vit2','thyroid1','thyroid2','iron1'],3549.00,2699.00,'Comprehensive Checkup + Thyroid Panel + Iron Studies.',true),
('pkg4','Diabetes Management Panel',ARRAY['bs1','bs2','bs4','lipid0','kft1','lft1','thyroid3','urine1'],2249.00,1699.00,'Complete diabetes monitoring package including HbA1c, lipid profile, kidney function, and inflammation markers.',true),
('pkg5','Thyroid Health Checkup',ARRAY['thyroid1','thyroid2','thyroid3','thyroid4','thyroid5'],1996.00,1999.00,'Complete thyroid function assessment including all thyroid hormones.',true),
('pkg6','Immunity Check',ARRAY['cbc1','inf1','vit1'],997.00,999.00,'Rapid assessment of infection markers and vital systemic immunity components.',true),
('pkg7','Pre-Pregnancy Checkup',ARRAY['cbc1','thyroid3','cbc3'],797.00,1599.00,'Basic blood profile assessment alongside Thyroid and Blood Group mapping.',true)
ON CONFLICT (package_id) DO UPDATE SET
  package_name     = EXCLUDED.package_name,
  original_price   = EXCLUDED.original_price,
  discounted_price = EXCLUDED.discounted_price,
  description      = EXCLUDED.description;


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 3: INITIAL ZONES SEED
-- ─────────────────────────────────────────────────────────────────────

INSERT INTO zones (city, zone_name, pincode, status, capacity_limit) VALUES
('Suryapet','Central Suryapet','508213','active',100),
('Nalgonda','Nalgonda Main','508001','active',50),
('Khammam','Khammam West','507001','paused',30)
ON CONFLICT (city, zone_name) DO NOTHING;
