-- =====================================================================
-- AASHA MEDIX — Diagnostics Catalog Seed Data
-- Run AFTER phase3_schema.sql
-- Project: https://wyytvrukflhphukmltvn.supabase.co
--
-- Inserts the full diagnostic test catalog into diagnostic_tests.
-- Uses ON CONFLICT DO NOTHING — safe to re-run.
-- =====================================================================

INSERT INTO diagnostic_tests ("testId","testName",category,"sampleType","reportingTime",price,description,"isPopular","isActive") VALUES
-- Blood Sugar Tests
('bs1','Fasting Blood Sugar (FBS)','Blood Sugar','Blood','Same Day',150.00,'Measures blood sugar level after 8-12 hours of fasting. Essential for diabetes screening.',true,true),
('bs2','Post Prandial Blood Sugar (PPBS)','Blood Sugar','Blood','Same Day',150.00,'Checks blood sugar 2 hours after eating. Helps monitor post-meal glucose control.',true,true),
('bs3','Random Blood Sugar (RBS)','Blood Sugar','Blood','Same Day',120.00,'Blood sugar test taken at any time, regardless of meals. Quick diabetes check.',false,true),
('bs4','HbA1c (Glycated Hemoglobin)','Blood Sugar','Blood','24 Hours',400.00,'3-month average blood sugar control. Gold standard for diabetes monitoring.',true,true),
('bs5','Glucose Tolerance Test (GTT)','Blood Sugar','Blood','24 Hours',300.00,'Comprehensive test for gestational diabetes and insulin resistance.',false,false),
-- Hematology
('cbc1','Complete Blood Count (CBC)','Hematology','Blood','Same Day',250.00,'Comprehensive blood analysis including RBC, WBC, platelets, and hemoglobin levels.',true,true),
('cbc2','Hemoglobin (Hb)','Hematology','Blood','Same Day',100.00,'Measures oxygen-carrying protein in blood. Essential for anemia screening.',true,true),
('cbc3','Total Leukocyte Count (TLC)','Hematology','Blood','Same Day',120.00,'White blood cell count to assess immune system and detect infections.',false,true),
('cbc4','Platelet Count','Hematology','Blood','Same Day',150.00,'Blood clotting cell count. Important for bleeding disorders and thrombosis.',false,true),
('cbc5','ESR (Erythrocyte Sedimentation Rate)','Hematology','Blood','Same Day',180.00,'Inflammation marker. Helps diagnose infections, autoimmune diseases.',false,true),
-- Liver Function Tests
('lft1','SGOT (AST)','Liver Function','Blood','Same Day',200.00,'Liver enzyme test for liver damage and heart muscle injury detection.',false,true),
('lft2','SGPT (ALT)','Liver Function','Blood','Same Day',200.00,'Primary liver enzyme test. Most specific indicator of liver cell damage.',true,true),
('lft3','Serum Bilirubin Total','Liver Function','Blood','Same Day',180.00,'Yellow pigment test for liver function and jaundice assessment.',false,true),
('lft4','Serum Bilirubin Direct','Liver Function','Blood','Same Day',180.00,'Conjugated bilirubin test for liver and bile duct function.',false,true),
('lft5','Serum Bilirubin Indirect','Liver Function','Blood','Same Day',180.00,'Unconjugated bilirubin test for hemolytic anemia and liver function.',false,true),
('lft6','Alkaline Phosphatase (ALP)','Liver Function','Blood','Same Day',200.00,'Bone and liver enzyme test. Elevated in liver diseases and bone disorders.',false,true),
('lft7','Total Protein','Liver Function','Blood','Same Day',150.00,'Total protein measurement for nutritional status and liver function.',false,true),
('lft8','Serum Albumin','Liver Function','Blood','Same Day',150.00,'Liver protein test for liver synthetic function and nutritional assessment.',false,true),
-- Kidney Function Tests
('kft1','Blood Urea','Kidney Function','Blood','Same Day',120.00,'Waste product test for kidney function and protein metabolism assessment.',false,true),
('kft2','Serum Creatinine','Kidney Function','Blood','Same Day',150.00,'Most reliable kidney function marker. Essential for GFR calculation.',true,true),
('kft3','Blood Urea Nitrogen (BUN)','Kidney Function','Blood','Same Day',120.00,'Nitrogen in blood urea. Used with creatinine for kidney function evaluation.',false,true),
('kft4','Serum Uric Acid','Kidney Function','Blood','Same Day',150.00,'Gout and kidney stone risk assessment. Elevated in kidney dysfunction.',false,true),
-- Lipid Profile
('lipid1','Total Cholesterol','Lipid Profile','Blood','Same Day',180.00,'Overall cholesterol measurement for heart disease risk assessment.',true,true),
('lipid2','HDL Cholesterol','Lipid Profile','Blood','Same Day',200.00,'"Good" cholesterol test. Higher levels protect against heart disease.',true,true),
('lipid3','LDL Cholesterol','Lipid Profile','Blood','Same Day',200.00,'"Bad" cholesterol test. High levels increase heart disease risk.',true,true),
('lipid4','Triglycerides','Lipid Profile','Blood','Same Day',180.00,'Blood fat test. Elevated levels linked to heart disease and diabetes.',false,true),
('lipid5','VLDL Cholesterol','Lipid Profile','Blood','Same Day',200.00,'Very low density lipoprotein test for detailed lipid analysis.',false,true),
-- Thyroid
('thyroid1','T3 (Triiodothyronine)','Thyroid','Blood','24 Hours',250.00,'Active thyroid hormone test for hyperthyroidism and hypothyroidism.',false,true),
('thyroid2','T4 (Thyroxine)','Thyroid','Blood','24 Hours',250.00,'Main thyroid hormone test. Assesses thyroid gland function.',true,true),
('thyroid3','TSH (Thyroid Stimulating Hormone)','Thyroid','Blood','24 Hours',300.00,'Pituitary thyroid control test. Most sensitive thyroid function indicator.',true,true),
('thyroid4','Free T3','Thyroid','Blood','24 Hours',350.00,'Unbound active thyroid hormone. More accurate than total T3.',false,true),
('thyroid5','Free T4','Thyroid','Blood','24 Hours',350.00,'Unbound thyroid hormone. Essential for thyroid disorder diagnosis.',false,true),
-- Infection Markers
('inf1','CRP (C-Reactive Protein)','Infection Markers','Blood','Same Day',400.00,'Inflammation and infection marker. Helps diagnose bacterial infections.',true,true),
('inf2','RA Factor','Infection Markers','Blood','24 Hours',300.00,'Rheumatoid arthritis autoantibody test for joint inflammation diagnosis.',false,true),
('inf3','ASO Titre','Infection Markers','Blood','24 Hours',350.00,'Streptococcal infection marker. Used for rheumatic fever diagnosis.',false,true),
('inf4','VDRL','Infection Markers','Blood','24 Hours',250.00,'Syphilis screening test. Detects antibodies against syphilis bacteria.',false,true),
-- Urine Analysis
('urine1','Urine Routine Examination','Urine Analysis','Urine','Same Day',120.00,'Comprehensive urine analysis for infection, diabetes, and kidney function.',true,true),
('urine2','Urine Culture & Sensitivity','Urine Analysis','Urine','48 Hours',500.00,'Urinary tract infection diagnosis and antibiotic sensitivity testing.',false,true),
('urine3','24 Hour Urine Protein','Urine Analysis','Urine','24 Hours',300.00,'Kidney damage assessment. Measures protein loss in urine over 24 hours.',false,true),
-- Vitamins & Minerals
('vit1','Vitamin D3','Vitamins','Blood','24 Hours',1200.00,'Bone health and immune function vitamin. Deficiency causes rickets and osteomalacia.',true,true),
('vit2','Vitamin B12','Vitamins','Blood','24 Hours',800.00,'Anemia and neurological function vitamin. Essential for red blood cell formation.',true,true),
('elec1','Serum Electrolytes','Electrolytes','Blood','Same Day',400.00,'Sodium, potassium, chloride levels for hydration and kidney function.',false,true),
('iron1','Iron Studies (Iron, TIBC, Ferritin)','Iron Studies','Blood','24 Hours',600.00,'Complete iron metabolism assessment for anemia diagnosis and management.',false,true),
-- Hormones & Cardiac
('horm1','Cortisol','Hormones','Blood','24 Hours',500.00,'Stress hormone test for adrenal gland function and Cushing''s syndrome.',false,true),
('card1','Troponin I','Cardiac Markers','Blood','Same Day',800.00,'Heart attack marker. Most specific test for myocardial infarction.',false,true),
('card2','CK-MB','Cardiac Markers','Blood','Same Day',600.00,'Heart muscle enzyme test for cardiac injury assessment.',false,true),
-- Pregnancy & Other
('preg1','Beta HCG','Pregnancy','Blood','Same Day',300.00,'Pregnancy hormone test. Most accurate early pregnancy detection.',false,true),
('stool1','Stool Routine Examination','Stool Analysis','Stool','24 Hours',150.00,'Digestive health and infection screening. Checks for parasites and blood.',false,true),
-- Hepatitis & Infectious
('hepa1','HBsAg (Hepatitis B Surface Antigen)','Hepatitis','Blood','24 Hours',400.00,'Hepatitis B infection screening. Detects active or chronic HBV infection.',false,true),
('hepa2','Anti HCV (Hepatitis C Antibody)','Hepatitis','Blood','24 Hours',500.00,'Hepatitis C infection screening. Detects past or present HCV exposure.',false,true),
('mal1','Malaria Parasite','Infectious Diseases','Blood','Same Day',200.00,'Malaria diagnosis by microscopic examination of blood smear.',false,true),
('dengue1','Dengue NS1 Antigen','Infectious Diseases','Blood','Same Day',600.00,'Early dengue fever detection. Most accurate in first 5 days of symptoms.',false,true),
('tb1','Mantoux Test','Tuberculosis','Skin Test','48 Hours',150.00,'TB infection screening. Measures skin reaction to TB proteins.',false,true),
-- Cancer Markers
('cancer1','PSA (Prostate Specific Antigen)','Cancer Markers','Blood','24 Hours',700.00,'Prostate cancer screening. Elevated levels may indicate prostate issues.',false,true),
('cancer2','CA-125 (Ovarian Cancer Marker)','Cancer Markers','Blood','24 Hours',800.00,'Ovarian cancer monitoring. Used for diagnosis and treatment follow-up.',false,true),
('cancer3','CEA (Carcinoembryonic Antigen)','Cancer Markers','Blood','24 Hours',600.00,'General cancer marker. Monitors colorectal and other cancers.',false,true)
ON CONFLICT ("testId") DO UPDATE SET
  "testName"      = EXCLUDED."testName",
  price           = EXCLUDED.price,
  description     = EXCLUDED.description,
  "isActive"      = EXCLUDED."isActive";


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 2: HEALTH PACKAGES SEED
-- ─────────────────────────────────────────────────────────────────────

INSERT INTO health_packages ("packageId","packageName","includedTests","originalPrice","discountedPrice",description,"isActive") VALUES
('pkg1','Basic Health Checkup',ARRAY['cbc1','bs1','lft1','lft2','kft2','lipid1','urine1'],1500.00,1200.00,'Essential health screening including CBC, blood sugar, liver & kidney function, lipid profile, and urine analysis.',true),
('pkg2','Full Body Checkup',ARRAY['cbc1','bs1','bs4','lft1','lft2','lft3','kft1','kft2','lipid1','lipid2','lipid3','lipid4','thyroid3','vit1','vit2','urine1','elec1'],3500.00,2800.00,'Comprehensive full body health checkup covering all major organ systems and vitamin deficiencies.',true),
('pkg3','Diabetes Care Package',ARRAY['bs1','bs2','bs4','lft1','lft2','kft2','kft4','lipid1','lipid2','lipid3','lipid4','urine1','inf1'],2200.00,1800.00,'Complete diabetes monitoring package including HbA1c, lipid profile, kidney function, and inflammation markers.',true),
('pkg4','Heart Health Package',ARRAY['cbc1','bs1','lipid1','lipid2','lipid3','lipid4','lipid5','card1','card2','lft1','lft2','kft2','elec1'],2800.00,2200.00,'Comprehensive cardiac health assessment including lipid profile, cardiac markers, and metabolic parameters.',true),
('pkg5','Women Wellness Package',ARRAY['cbc1','bs1','lft1','lft2','kft2','lipid1','thyroid3','vit1','vit2','preg1','cancer2','iron1','urine1'],2500.00,2000.00,'Specialized wellness package for women including cancer markers, iron studies, and hormonal assessment.',true),
('pkg6','Senior Citizen Package',ARRAY['cbc1','bs1','bs4','lft1','lft2','lft3','kft1','kft2','lipid1','lipid2','lipid3','lipid4','thyroid3','vit1','vit2','elec1','card1','cancer1','cancer3'],3200.00,2500.00,'Comprehensive health screening package designed specifically for senior citizens with age-related health concerns.',true),
('pkg7','Thyroid Package',ARRAY['thyroid1','thyroid2','thyroid3','thyroid4','thyroid5','cbc1','bs1'],1800.00,1400.00,'Complete thyroid function assessment including all thyroid hormones and basic health parameters.',true),
('pkg8','Fever Panel',ARRAY['cbc1','cbc5','inf1','inf3','mal1','dengue1','urine1','hepa1'],1600.00,1300.00,'Comprehensive fever investigation panel including CBC, infection markers, and tropical disease screening.',true),
('pkg9','Pre-Employment Package',ARRAY['cbc1','bs1','lft1','lft2','kft2','lipid1','urine1','stool1','hepa1','hepa2'],2000.00,1600.00,'Standard pre-employment health checkup package covering all essential parameters for employment screening.',true),
('pkg10','Lifestyle Package',ARRAY['cbc1','bs1','bs4','lipid1','lipid2','lipid3','lipid4','lft1','lft2','kft2','vit1','vit2','elec1','iron1'],2400.00,1900.00,'Modern lifestyle health package focusing on metabolic health, vitamin deficiencies, and preventive screening.',true),
('pkg11','Liver Package',ARRAY['lft1','lft2','lft3','lft4','lft5','lft6','lft7','lft8','hepa1','hepa2','cbc1'],1800.00,1400.00,'Detailed liver function assessment including all liver enzymes, proteins, and hepatitis screening.',true),
('pkg12','Kidney Package',ARRAY['kft1','kft2','kft3','kft4','elec1','cbc1','bs1','urine1','urine2'],1600.00,1300.00,'Comprehensive kidney function evaluation including electrolytes, urine analysis, and culture sensitivity.',true),
('pkg13','Cardiac Risk Package',ARRAY['lipid1','lipid2','lipid3','lipid4','lipid5','card1','card2','horm1','bs1','cbc1'],2200.00,1800.00,'Advanced cardiac risk assessment including detailed lipid profile, cardiac markers, and stress hormones.',true),
('pkg14','Cancer Screening Package',ARRAY['cbc1','cancer1','cancer2','cancer3','lft1','lft2','kft2','bs1'],2800.00,2200.00,'Essential cancer screening markers for early detection and monitoring of common cancers.',true)
ON CONFLICT ("packageId") DO UPDATE SET
  "packageName"     = EXCLUDED."packageName",
  "originalPrice"   = EXCLUDED."originalPrice",
  "discountedPrice" = EXCLUDED."discountedPrice",
  description       = EXCLUDED.description;


-- ─────────────────────────────────────────────────────────────────────
-- SECTION 3: INITIAL ZONES SEED
-- ─────────────────────────────────────────────────────────────────────

INSERT INTO zones (city, zone_name, pincode, status, capacity_limit) VALUES
('Suryapet','Central Suryapet','508213','active',100),
('Nalgonda','Nalgonda Main','508001','active',50),
('Khammam','Khammam West','507001','paused',30)
ON CONFLICT (city, zone_name) DO NOTHING;


-- ─────────────────────────────────────────────────────────────────────
-- Verification — run these to confirm all tables are populated
-- ─────────────────────────────────────────────────────────────────────
-- SELECT COUNT(*) FROM diagnostic_tests;  -- expect: 59+
-- SELECT COUNT(*) FROM health_packages;   -- expect: 14
-- SELECT COUNT(*) FROM zones;             -- expect: 3
