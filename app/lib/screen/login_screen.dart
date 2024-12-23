import 'package:flutter/material.dart';
import 'package:english_master_uet/controller/login_controller.dart';
import 'package:english_master_uet/screen/home_screen.dart';
import 'package:english_master_uet/screen/register_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../model/user_progress.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController = LoginController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = 'test@gmail.com';
    _passwordController.text = '123456';
  }

  Future<void> _login() async {
    String? result = await _loginController.login(
      _usernameController.text,
      _passwordController.text,
    );

    if (result != null) {
      print("UID: $result");
      if (result.length == 28) {

        Provider.of<UserProgress>(context, listen: false).startStudyTime();
        // Lấy UserProgress từ context và cập nhật thời gian đăng nhập
        final userProgress = Provider.of<UserProgress>(context, listen: false);
        userProgress.updateLoginTime();

        // Trích xuất tên người dùng từ email (ví dụ)
        String userName = _usernameController.text.split('@')[0];
        userProgress.setUserName(userName);

        // Assuming UID is 28 characters long
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()), // Chuyển sang màn hình Home
        );
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Login successful. UID: $result')),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }
  Future<String> _loginWithGoogle(BuildContext context) async {
    String? result = await _loginController.loginWithGoogle(context);

    if (result != null) {
      print("UID: $result");
      if (result.length == 28) {


        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(uid: result), // Truyền UID của người dùng
        //   ),
        // );

        Navigator.pushNamed(context, '/home_screen', arguments: result);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Login successful. UID: $result')),
        // );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
    return result ?? '';
  }
  Future<void> _resetPassword() async {
    final TextEditingController emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset Password'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Enter your email',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String? result =
                    await _loginController.resetPassword(emailController.text);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result ?? 'An error occurred')),
                );
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //căn giữa
        title: const Center(
            child: Text('Đăng nhập',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black))),
      ),
      // set từ trên xuống
      body: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _resetPassword,
                  child: const Text('Bạn quên mật khẩu?'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register_screen');
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => RegisterScreen()),
                    // );
                  },
                  child: const Text('Đăng ký ngay?'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 150.0,
                  height: 150.0,
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                  ),
                ),
                const SizedBox(height: 50.0),
                Container(
                  width: 300.0, // Set the desired width
                  height: 50.0,
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: 300.0, // Set the desired width
                  height: 50.0,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    obscureText: !_isPasswordVisible, // Ẩn/hiện mật khẩu
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Đăng nhập'),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    await _loginWithGoogle(context);
                  },
                  icon: SvgPicture.network(
                    'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                    height: 24.0,
                    width: 24.0,
                  ),
                  label: const Text(
                    'Đăng nhập bằng Google',
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          )

        ],
      ),
    );
  }
}

