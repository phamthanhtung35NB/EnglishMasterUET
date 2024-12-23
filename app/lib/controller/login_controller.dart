import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future<String?> login(String email, String password) async {
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        //in uid ra log
        return userCredential.user?.uid;
        //không đăng nhập được
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'Không tìm thấy người dùng cho email đó.';
        } else if (e.code == 'wrong-password') {
          return 'Mật khẩu cung cấp không chính xác.';
        } else {
          return 'Đã xảy ra lỗi. Vui lòng thử lại: ${e.message}';
        }
      } catch (e) {
        return 'Đã xảy ra lỗi. Vui lòng thử lại: ${e.toString()}';
      }


  }
  Future<String> loginWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // Đăng nhập bị hủy
        return"";
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Sau khi đăng nhập, lấy UID và thông tin người dùng từ Firestore
      String uid = userCredential.user!.uid;

      return uid;
    } catch (e) {
      print('Lỗi đăng nhập: ${e.toString()}');
      return '';
    }
    return '';
  }

  Future<void> logout() async {
    await _auth.signOut();
  }


  Future<String?> changePassword(String currentPassword, String newPassword) async {
    User? user = _auth.currentUser;

    if (user == null) {
      return 'No user is currently signed in.';
    }

    try {
      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(newPassword);
      return 'Mật khẩu đã được cập nhật thành công.';
    } on FirebaseAuthException catch (e) {
      return 'Error: ${e.message}';
    } catch (e) {
      return 'An error occurred: ${e.toString()}';
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Password reset email has been sent.';
    } on FirebaseAuthException catch (e) {
      return 'Error: ${e.message}';
    } catch (e) {
      return 'An error occurred: ${e.toString()}';
    }
  }
}