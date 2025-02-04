import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send OTP
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 120),
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP
  Future<void> verifyOTP({
    required String verificationId,
    required String otp,
    required Function(User) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      onSuccess(userCredential.user!);
    } catch (e) {
      onError('Invalid OTP');
    }
  }
}
