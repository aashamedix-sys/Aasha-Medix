// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'AASHA MEDIX';

  @override
  String get welcomeToAasha => 'Welcome to AASHA';

  @override
  String get yourHealthOurPriority => 'Your health, our priority';

  @override
  String get ourServices => 'Our Services';

  @override
  String get diagnostics => 'Diagnostics';

  @override
  String get labTests => 'Lab Tests';

  @override
  String get homeSample => 'Home Sample';

  @override
  String get collection => 'Collection';

  @override
  String get doctorConsult => 'Doctor Consult';

  @override
  String get onlineOffline => 'Online/Offline';

  @override
  String get reports => 'Reports';

  @override
  String get viewDownload => 'View & Download';

  @override
  String get medicineDelivery => 'Medicine Delivery';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get askAashaDost => 'Ask AASHA DOST';

  @override
  String get orderMedicines => 'Order Medicines';

  @override
  String get orderHistory => 'Order History';

  @override
  String get findNearestLab => 'Find Nearest Lab';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String featureComingSoon(Object feature) {
    return '$feature feature will be available soon!';
  }

  @override
  String get uploadPrescription => 'Upload Prescription';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get prescriptionDisclaimer =>
      'Medicines will be dispensed only as per valid doctor prescription.';

  @override
  String get previousPrescriptions => 'Previous Prescriptions';

  @override
  String get noPreviousPrescriptions => 'No previous prescriptions found';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get enterDeliveryAddress => 'Enter delivery address';

  @override
  String get preferredDeliveryTime => 'Preferred Delivery Time';

  @override
  String get selectTime => 'Select Time';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get orderPlaced => 'Order Placed Successfully!';

  @override
  String get orderId => 'Order ID';

  @override
  String get estimatedDelivery => 'Estimated Delivery';

  @override
  String get trackOrder => 'Track Order';

  @override
  String get orderStatus => 'Order Status';

  @override
  String get uploaded => 'Uploaded';

  @override
  String get verified => 'Verified';

  @override
  String get packed => 'Packed';

  @override
  String get outForDelivery => 'Out for Delivery';

  @override
  String get delivered => 'Delivered';

  @override
  String get prescriptionRequired => 'Prescription Required';

  @override
  String get prescriptionRequiredMessage =>
      'Please upload a valid prescription to proceed with medicine delivery.';

  @override
  String get invalidPrescription => 'Invalid Prescription';

  @override
  String get invalidPrescriptionMessage =>
      'The uploaded prescription appears to be unclear or expired. Please upload a clear, valid prescription.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get home => 'Home';

  @override
  String get services => 'Services';

  @override
  String get profile => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get telugu => 'Telugu';

  @override
  String get hindi => 'Hindi';

  @override
  String get selectLanguage => 'Select Language';
}
