import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/test_model.dart';
import '../models/booking_model.dart';
import '../models/report_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tests
  Future<List<TestModel>> getAllTests() async {
    QuerySnapshot snapshot = await _firestore.collection('tests').get();
    return snapshot.docs
        .map((doc) => TestModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<TestModel?> getTestById(String testId) async {
    DocumentSnapshot doc = await _firestore
        .collection('tests')
        .doc(testId)
        .get();
    if (doc.exists) {
      return TestModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Bookings
  Future<String> createBooking(BookingModel booking) async {
    DocumentReference docRef = await _firestore
        .collection('bookings')
        .add(booking.toMap());
    return docRef.id;
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => BookingModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status,
    });
  }

  // Reports
  Future<List<ReportModel>> getUserReports(String userId) async {
    QuerySnapshot snapshot = await _firestore
        .collection('reports')
        .where('userId', isEqualTo: userId)
        .orderBy('uploadDate', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ReportModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addReport(ReportModel report) async {
    await _firestore.collection('reports').add(report.toMap());
  }
}
