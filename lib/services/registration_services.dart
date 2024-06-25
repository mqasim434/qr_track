import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_track/models/user_model.dart';
import 'package:qr_track/res/enums.dart';
import 'package:qr_track/res/utility_functions.dart';

class RegistrationServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> signInWithEmailPassword(
      {required String email,
      required String password,
      required UserRoles userRole}) async {
    try {
      EasyLoading.show(status: 'Signing in');
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection(UtilityFunctions.getCollectionName(userRole.name))
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userRole == UserRoles.Student) {
        UserModel.currentUser =
            StudentModel.fromJson(querySnapshot.docs.first.data());
      } else {
        UserModel.currentUser =
            TeacherModel.fromJson(querySnapshot.docs.first.data());
      }
      EasyLoading.dismiss();
      return true;
    } catch (e) {
      print('Error signing in: $e');
      EasyLoading.dismiss();
      return false;
    }
  }

  static Future<bool> signUpWithEmailPassword(
      {required String email,
      required String password,
      required String fullName,
      required UserRoles userRole}) async {
    try {
      EasyLoading.show(status: 'Registering');
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection(UtilityFunctions.getCollectionName(userRole.name))
          .doc(userCredential.user!.uid)
          .set({
        'fullName': fullName,
        'email': email,
      });
      EasyLoading.dismiss();
      return true;
    } catch (e) {
      print('Error signing up: $e');
      EasyLoading.dismiss();
      return false;
    }
  }

  static Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
    }
  }
}
