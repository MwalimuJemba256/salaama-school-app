import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Phone OTP Login - Job Application Number
  Future<void> verifyPhone(String phone, Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential cred) async {
        await _auth.signInWithCredential(cred);
      },
      verificationFailed: (e) {
        throw e.message ?? "Verification failed";
      },
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<UserCredential> signInWithOTP(String verificationId, String smsCode) async {
    PhoneAuthCredential cred = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    return await _auth.signInWithCredential(cred);
  }

  // Check role: admin or teacher
  Future<Map<String, dynamic>?> getUserRole(String phone) async {
    try {
      // Check admins
      var adminDoc = await _firestore.collection('admins').doc(phone).get();
      if (adminDoc.exists) return {'role': 'admin', 'data': adminDoc.data()};

      // Check teachers
      var teacherDoc = await _firestore.collection('teachers').doc(phone).get();
      if (teacherDoc.exists) return {'role': 'teacher', 'data': teacherDoc.data()};

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}