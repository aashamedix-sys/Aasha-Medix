import '../models/diagnostics_models.dart';

class DiagnosticsData {
  static List<TestItem> getCommonTests() {
    return [
      // Blood Sugar Tests
      const TestItem(
        testId: 'bs1',
        testName: 'Fasting Blood Sugar (FBS)',
        category: 'Blood Sugar',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 150.0,
        description:
            'Measures blood sugar level after 8-12 hours of fasting. Essential for diabetes screening.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'bs2',
        testName: 'Post Prandial Blood Sugar (PPBS)',
        category: 'Blood Sugar',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 150.0,
        description:
            'Checks blood sugar 2 hours after eating. Helps monitor post-meal glucose control.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'bs3',
        testName: 'Random Blood Sugar (RBS)',
        category: 'Blood Sugar',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 120.0,
        description:
            'Blood sugar test taken at any time, regardless of meals. Quick diabetes check.',
      ),
      const TestItem(
        testId: 'bs4',
        testName: 'HbA1c (Glycated Hemoglobin)',
        category: 'Blood Sugar',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 400.0,
        description:
            '3-month average blood sugar control. Gold standard for diabetes monitoring.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'bs5',
        testName: 'Glucose Tolerance Test (GTT)',
        category: 'Blood Sugar',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 300.0,
        description:
            'Comprehensive test for gestational diabetes and insulin resistance.',
      ),

      // CBC & Hematology
      const TestItem(
        testId: 'cbc1',
        testName: 'Complete Blood Count (CBC)',
        category: 'Hematology',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 250.0,
        description:
            'Comprehensive blood analysis including RBC, WBC, platelets, and hemoglobin levels.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'cbc2',
        testName: 'Hemoglobin (Hb)',
        category: 'Hematology',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 100.0,
        description:
            'Measures oxygen-carrying protein in blood. Essential for anemia screening.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'cbc3',
        testName: 'Total Leukocyte Count (TLC)',
        category: 'Hematology',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 120.0,
        description:
            'White blood cell count to assess immune system and detect infections.',
      ),
      const TestItem(
        testId: 'cbc4',
        testName: 'Platelet Count',
        category: 'Hematology',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 150.0,
        description:
            'Blood clotting cell count. Important for bleeding disorders and thrombosis.',
      ),
      const TestItem(
        testId: 'cbc5',
        testName: 'ESR (Erythrocyte Sedimentation Rate)',
        category: 'Hematology',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 180.0,
        description:
            'Inflammation marker. Helps diagnose infections, autoimmune diseases.',
      ),

      // Liver Function Tests
      const TestItem(
        testId: 'lft1',
        testName: 'SGOT (AST)',
        category: 'Liver Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 200.0,
        description:
            'Liver enzyme test for liver damage and heart muscle injury detection.',
      ),
      const TestItem(
        testId: 'lft2',
        testName: 'SGPT (ALT)',
        category: 'Liver Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 200.0,
        description:
            'Primary liver enzyme test. Most specific indicator of liver cell damage.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'lft3',
        testName: 'Serum Bilirubin Total',
        category: 'Liver Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 180.0,
        description:
            'Yellow pigment test for liver function and jaundice assessment.',
      ),
      const TestItem(
        testId: 'lft4',
        testName: 'Serum Bilirubin Direct',
        category: 'Liver Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 180.0,
        description:
            'Conjugated bilirubin test for liver and bile duct function.',
      ),
      const TestItem(
        testId: 'lft5',
        testName: 'Serum Bilirubin Indirect',
        category: 'Liver Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 180.0,
        description:
            'Unconjugated bilirubin test for hemolytic anemia and liver function.',
      ),
      const TestItem(
        testId: 'lft6',
        testName: 'Alkaline Phosphatase (ALP)',
        category: 'Liver Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 200.0,
        description:
            'Bone and liver enzyme test. Elevated in liver diseases and bone disorders.',
      ),
      const TestItem(
        testId: 'lft7',
        testName: 'Total Protein',
        category: 'Liver Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 150.0,
        description:
            'Total protein measurement for nutritional status and liver function.',
      ),
      const TestItem(
        testId: 'lft8',
        testName: 'Serum Albumin',
        category: 'Liver Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 150.0,
        description:
            'Liver protein test for liver synthetic function and nutritional assessment.',
      ),

      // Kidney Function Tests
      const TestItem(
        testId: 'kft1',
        testName: 'Blood Urea',
        category: 'Kidney Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 120.0,
        description:
            'Waste product test for kidney function and protein metabolism assessment.',
      ),
      const TestItem(
        testId: 'kft2',
        testName: 'Serum Creatinine',
        category: 'Kidney Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 150.0,
        description:
            'Most reliable kidney function marker. Essential for GFR calculation.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'kft3',
        testName: 'Blood Urea Nitrogen (BUN)',
        category: 'Kidney Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 120.0,
        description:
            'Nitrogen in blood urea. Used with creatinine for kidney function evaluation.',
      ),
      const TestItem(
        testId: 'kft4',
        testName: 'Serum Uric Acid',
        category: 'Kidney Function',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 150.0,
        description:
            'Gout and kidney stone risk assessment. Elevated in kidney dysfunction.',
      ),

      // Lipid Profile Tests
      const TestItem(
        testId: 'lipid1',
        testName: 'Total Cholesterol',
        category: 'Lipid Profile',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 180.0,
        description:
            'Overall cholesterol measurement for heart disease risk assessment.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'lipid2',
        testName: 'HDL Cholesterol',
        category: 'Lipid Profile',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 200.0,
        description:
            '"Good" cholesterol test. Higher levels protect against heart disease.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'lipid3',
        testName: 'LDL Cholesterol',
        category: 'Lipid Profile',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 200.0,
        description:
            '"Bad" cholesterol test. High levels increase heart disease risk.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'lipid4',
        testName: 'Triglycerides',
        category: 'Lipid Profile',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 180.0,
        description:
            'Blood fat test. Elevated levels linked to heart disease and diabetes.',
      ),
      const TestItem(
        testId: 'lipid5',
        testName: 'VLDL Cholesterol',
        category: 'Lipid Profile',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 200.0,
        description:
            'Very low density lipoprotein test for detailed lipid analysis.',
      ),

      // Thyroid Tests
      const TestItem(
        testId: 'thyroid1',
        testName: 'T3 (Triiodothyronine)',
        category: 'Thyroid',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 250.0,
        description:
            'Active thyroid hormone test for hyperthyroidism and hypothyroidism.',
      ),
      const TestItem(
        testId: 'thyroid2',
        testName: 'T4 (Thyroxine)',
        category: 'Thyroid',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 250.0,
        description:
            'Main thyroid hormone test. Assesses thyroid gland function.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'thyroid3',
        testName: 'TSH (Thyroid Stimulating Hormone)',
        category: 'Thyroid',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 300.0,
        description:
            'Pituitary thyroid control test. Most sensitive thyroid function indicator.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'thyroid4',
        testName: 'Free T3',
        category: 'Thyroid',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 350.0,
        description:
            'Unbound active thyroid hormone. More accurate than total T3.',
      ),
      const TestItem(
        testId: 'thyroid5',
        testName: 'Free T4',
        category: 'Thyroid',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 350.0,
        description:
            'Unbound thyroid hormone. Essential for thyroid disorder diagnosis.',
      ),

      // Infection Markers
      const TestItem(
        testId: 'inf1',
        testName: 'CRP (C-Reactive Protein)',
        category: 'Infection Markers',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 400.0,
        description:
            'Inflammation and infection marker. Helps diagnose bacterial infections.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'inf2',
        testName: 'RA Factor',
        category: 'Infection Markers',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 300.0,
        description:
            'Rheumatoid arthritis autoantibody test for joint inflammation diagnosis.',
      ),
      const TestItem(
        testId: 'inf3',
        testName: 'ASO Titre',
        category: 'Infection Markers',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 350.0,
        description:
            'Streptococcal infection marker. Used for rheumatic fever diagnosis.',
      ),
      const TestItem(
        testId: 'inf4',
        testName: 'VDRL',
        category: 'Infection Markers',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 250.0,
        description:
            'Syphilis screening test. Detects antibodies against syphilis bacteria.',
      ),

      // Urine Routine Tests
      const TestItem(
        testId: 'urine1',
        testName: 'Urine Routine Examination',
        category: 'Urine Analysis',
        sampleType: 'Urine',
        reportingTime: 'Same Day',
        price: 120.0,
        description:
            'Comprehensive urine analysis for infection, diabetes, and kidney function.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'urine2',
        testName: 'Urine Culture & Sensitivity',
        category: 'Urine Analysis',
        sampleType: 'Urine',
        reportingTime: '48 Hours',
        price: 500.0,
        description:
            'Urinary tract infection diagnosis and antibiotic sensitivity testing.',
      ),
      const TestItem(
        testId: 'urine3',
        testName: '24 Hour Urine Protein',
        category: 'Urine Analysis',
        sampleType: 'Urine',
        reportingTime: '24 Hours',
        price: 300.0,
        description:
            'Kidney damage assessment. Measures protein loss in urine over 24 hours.',
      ),

      // Additional Common Tests
      const TestItem(
        testId: 'vit1',
        testName: 'Vitamin D3',
        category: 'Vitamins',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 1200.0,
        description:
            'Bone health and immune function vitamin. Deficiency causes rickets and osteomalacia.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'vit2',
        testName: 'Vitamin B12',
        category: 'Vitamins',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 800.0,
        description:
            'Anemia and neurological function vitamin. Essential for red blood cell formation.',
        isPopular: true,
      ),
      const TestItem(
        testId: 'elec1',
        testName: 'Serum Electrolytes',
        category: 'Electrolytes',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 400.0,
        description:
            'Sodium, potassium, chloride levels for hydration and kidney function.',
      ),
      const TestItem(
        testId: 'iron1',
        testName: 'Iron Studies (Iron, TIBC, Ferritin)',
        category: 'Iron Studies',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 600.0,
        description:
            'Complete iron metabolism assessment for anemia diagnosis and management.',
      ),
      const TestItem(
        testId: 'horm1',
        testName: 'Cortisol',
        category: 'Hormones',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 500.0,
        description:
            'Stress hormone test for adrenal gland function and Cushing\'s syndrome.',
      ),
      const TestItem(
        testId: 'card1',
        testName: 'Troponin I',
        category: 'Cardiac Markers',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 800.0,
        description:
            'Heart attack marker. Most specific test for myocardial infarction.',
      ),
      const TestItem(
        testId: 'card2',
        testName: 'CK-MB',
        category: 'Cardiac Markers',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 600.0,
        description: 'Heart muscle enzyme test for cardiac injury assessment.',
      ),
      const TestItem(
        testId: 'preg1',
        testName: 'Beta HCG',
        category: 'Pregnancy',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 300.0,
        description:
            'Pregnancy hormone test. Most accurate early pregnancy detection.',
      ),
      const TestItem(
        testId: 'stool1',
        testName: 'Stool Routine Examination',
        category: 'Stool Analysis',
        sampleType: 'Stool',
        reportingTime: '24 Hours',
        price: 150.0,
        description:
            'Digestive health and infection screening. Checks for parasites and blood.',
      ),
      const TestItem(
        testId: 'hepa1',
        testName: 'HBsAg (Hepatitis B Surface Antigen)',
        category: 'Hepatitis',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 400.0,
        description:
            'Hepatitis B infection screening. Detects active or chronic HBV infection.',
      ),
      const TestItem(
        testId: 'hepa2',
        testName: 'Anti HCV (Hepatitis C Antibody)',
        category: 'Hepatitis',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 500.0,
        description:
            'Hepatitis C infection screening. Detects past or present HCV exposure.',
      ),
      const TestItem(
        testId: 'mal1',
        testName: 'Malaria Parasite',
        category: 'Infectious Diseases',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 200.0,
        description:
            'Malaria diagnosis by microscopic examination of blood smear.',
      ),
      const TestItem(
        testId: 'dengue1',
        testName: 'Dengue NS1 Antigen',
        category: 'Infectious Diseases',
        sampleType: 'Blood',
        reportingTime: 'Same Day',
        price: 600.0,
        description:
            'Early dengue fever detection. Most accurate in first 5 days of symptoms.',
      ),
      const TestItem(
        testId: 'tb1',
        testName: 'Mantoux Test',
        category: 'Tuberculosis',
        sampleType: 'Skin Test',
        reportingTime: '48 Hours',
        price: 150.0,
        description:
            'TB infection screening. Measures skin reaction to TB proteins.',
      ),
      const TestItem(
        testId: 'cancer1',
        testName: 'PSA (Prostate Specific Antigen)',
        category: 'Cancer Markers',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 700.0,
        description:
            'Prostate cancer screening. Elevated levels may indicate prostate issues.',
      ),
      const TestItem(
        testId: 'cancer2',
        testName: 'CA-125 (Ovarian Cancer Marker)',
        category: 'Cancer Markers',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 800.0,
        description:
            'Ovarian cancer monitoring. Used for diagnosis and treatment follow-up.',
      ),
      const TestItem(
        testId: 'cancer3',
        testName: 'CEA (Carcinoembryonic Antigen)',
        category: 'Cancer Markers',
        sampleType: 'Blood',
        reportingTime: '24 Hours',
        price: 600.0,
        description:
            'General cancer marker. Monitors colorectal and other cancers.',
      ),
    ];
  }

  static List<HealthPackage> getHealthPackages() {
    return [
      const HealthPackage(
        packageId: 'pkg1',
        packageName: 'Basic Health Checkup',
        includedTests: [
          'cbc1',
          'bs1',
          'lft1',
          'lft2',
          'kft2',
          'lipid1',
          'urine1',
        ],
        originalPrice: 1500.0,
        discountedPrice: 1200.0,
        description:
            'Essential health screening including CBC, blood sugar, liver & kidney function, lipid profile, and urine analysis.',
      ),
      const HealthPackage(
        packageId: 'pkg2',
        packageName: 'Full Body Checkup',
        includedTests: [
          'cbc1',
          'bs1',
          'bs4',
          'lft1',
          'lft2',
          'lft3',
          'kft1',
          'kft2',
          'lipid1',
          'lipid2',
          'lipid3',
          'lipid4',
          'thyroid3',
          'vit1',
          'vit2',
          'urine1',
          'elec1',
        ],
        originalPrice: 3500.0,
        discountedPrice: 2800.0,
        description:
            'Comprehensive full body health checkup covering all major organ systems and vitamin deficiencies.',
      ),
      const HealthPackage(
        packageId: 'pkg3',
        packageName: 'Diabetes Care Package',
        includedTests: [
          'bs1',
          'bs2',
          'bs4',
          'lft1',
          'lft2',
          'kft2',
          'kft4',
          'lipid1',
          'lipid2',
          'lipid3',
          'lipid4',
          'urine1',
          'inf1',
        ],
        originalPrice: 2200.0,
        discountedPrice: 1800.0,
        description:
            'Complete diabetes monitoring package including HbA1c, lipid profile, kidney function, and inflammation markers.',
      ),
      const HealthPackage(
        packageId: 'pkg4',
        packageName: 'Heart Health Package',
        includedTests: [
          'cbc1',
          'bs1',
          'lipid1',
          'lipid2',
          'lipid3',
          'lipid4',
          'lipid5',
          'card1',
          'card2',
          'lft1',
          'lft2',
          'kft2',
          'elec1',
        ],
        originalPrice: 2800.0,
        discountedPrice: 2200.0,
        description:
            'Comprehensive cardiac health assessment including lipid profile, cardiac markers, and metabolic parameters.',
      ),
      const HealthPackage(
        packageId: 'pkg5',
        packageName: 'Women Wellness Package',
        includedTests: [
          'cbc1',
          'bs1',
          'lft1',
          'lft2',
          'kft2',
          'lipid1',
          'thyroid3',
          'vit1',
          'vit2',
          'preg1',
          'cancer2',
          'iron1',
          'urine1',
        ],
        originalPrice: 2500.0,
        discountedPrice: 2000.0,
        description:
            'Specialized wellness package for women including cancer markers, iron studies, and hormonal assessment.',
      ),
      const HealthPackage(
        packageId: 'pkg6',
        packageName: 'Senior Citizen Package',
        includedTests: [
          'cbc1',
          'bs1',
          'bs4',
          'lft1',
          'lft2',
          'lft3',
          'kft1',
          'kft2',
          'lipid1',
          'lipid2',
          'lipid3',
          'lipid4',
          'thyroid3',
          'vit1',
          'vit2',
          'elec1',
          'card1',
          'cancer1',
          'cancer3',
        ],
        originalPrice: 3200.0,
        discountedPrice: 2500.0,
        description:
            'Comprehensive health screening package designed specifically for senior citizens with age-related health concerns.',
      ),
      const HealthPackage(
        packageId: 'pkg7',
        packageName: 'Thyroid Package',
        includedTests: [
          'thyroid1',
          'thyroid2',
          'thyroid3',
          'thyroid4',
          'thyroid5',
          'cbc1',
          'bs1',
        ],
        originalPrice: 1800.0,
        discountedPrice: 1400.0,
        description:
            'Complete thyroid function assessment including all thyroid hormones and basic health parameters.',
      ),
      const HealthPackage(
        packageId: 'pkg8',
        packageName: 'Fever Panel',
        includedTests: [
          'cbc1',
          'cbc5',
          'inf1',
          'inf3',
          'mal1',
          'dengue1',
          'urine1',
          'hepa1',
        ],
        originalPrice: 1600.0,
        discountedPrice: 1300.0,
        description:
            'Comprehensive fever investigation panel including CBC, infection markers, and tropical disease screening.',
      ),
      const HealthPackage(
        packageId: 'pkg9',
        packageName: 'Pre-Employment Package',
        includedTests: [
          'cbc1',
          'bs1',
          'lft1',
          'lft2',
          'kft2',
          'lipid1',
          'urine1',
          'stool1',
          'hepa1',
          'hepa2',
        ],
        originalPrice: 2000.0,
        discountedPrice: 1600.0,
        description:
            'Standard pre-employment health checkup package covering all essential parameters for employment screening.',
      ),
      const HealthPackage(
        packageId: 'pkg10',
        packageName: 'Lifestyle Package',
        includedTests: [
          'cbc1',
          'bs1',
          'bs4',
          'lipid1',
          'lipid2',
          'lipid3',
          'lipid4',
          'lft1',
          'lft2',
          'kft2',
          'vit1',
          'vit2',
          'elec1',
          'iron1',
        ],
        originalPrice: 2400.0,
        discountedPrice: 1900.0,
        description:
            'Modern lifestyle health package focusing on metabolic health, vitamin deficiencies, and preventive screening.',
      ),
      const HealthPackage(
        packageId: 'pkg11',
        packageName: 'Liver Package',
        includedTests: [
          'lft1',
          'lft2',
          'lft3',
          'lft4',
          'lft5',
          'lft6',
          'lft7',
          'lft8',
          'hepa1',
          'hepa2',
          'cbc1',
        ],
        originalPrice: 1800.0,
        discountedPrice: 1400.0,
        description:
            'Detailed liver function assessment including all liver enzymes, proteins, and hepatitis screening.',
      ),
      const HealthPackage(
        packageId: 'pkg12',
        packageName: 'Kidney Package',
        includedTests: [
          'kft1',
          'kft2',
          'kft3',
          'kft4',
          'elec1',
          'cbc1',
          'bs1',
          'urine1',
          'urine2',
        ],
        originalPrice: 1600.0,
        discountedPrice: 1300.0,
        description:
            'Comprehensive kidney function evaluation including electrolytes, urine analysis, and culture sensitivity.',
      ),
      const HealthPackage(
        packageId: 'pkg13',
        packageName: 'Cardiac Risk Package',
        includedTests: [
          'lipid1',
          'lipid2',
          'lipid3',
          'lipid4',
          'lipid5',
          'card1',
          'card2',
          'horm1',
          'bs1',
          'cbc1',
        ],
        originalPrice: 2200.0,
        discountedPrice: 1800.0,
        description:
            'Advanced cardiac risk assessment including detailed lipid profile, cardiac markers, and stress hormones.',
      ),
      const HealthPackage(
        packageId: 'pkg14',
        packageName: 'Cancer Screening Package',
        includedTests: [
          'cbc1',
          'cancer1',
          'cancer2',
          'cancer3',
          'lft1',
          'lft2',
          'kft2',
          'bs1',
        ],
        originalPrice: 2800.0,
        discountedPrice: 2200.0,
        description:
            'Essential cancer screening markers for early detection and monitoring of common cancers.',
      ),
      const HealthPackage(
        packageId: 'pkg15',
        packageName: 'Pregnancy Care Package',
        includedTests: [
          'preg1',
          'cbc1',
          'bs1',
          'lft1',
          'lft2',
          'kft2',
          'vit1',
          'vit2',
          'iron1',
          'thyroid3',
          'urine1',
        ],
        originalPrice: 2000.0,
        discountedPrice: 1600.0,
        description:
            'Complete pregnancy wellness package including essential prenatal screening and nutritional assessment.',
      ),
    ];
  }
}
