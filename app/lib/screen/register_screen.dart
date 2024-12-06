import 'package:flutter/material.dart';
import 'package:english_master_uet/controller/register_controller.dart';
import 'package:english_master_uet/screen/login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController = TextEditingController();
  final RegisterController _registerController = RegisterController();
  // String? _verificationId;

  Future<void> _register() async {
    if (_passwordController.text != _passwordAgainController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không khớp.')),
      );
      return;
    }
    String? result = await _registerController.register(
      _emailController.text,
      _passwordController.text,
    );

    if (result != null) {
      print("UID: $result");
      if (result.length == 28) {
        Navigator.pushNamed(context, '/home_screen', arguments: result);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công. UID: $result')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  Future<void> _registerWithGoogle() async {
    String? result = await _registerController.registerWithGoogle();

    if (result != null) {
      print("UID: $result");
      if (result.length == 28) {
        Navigator.pushNamed(context, '/home_screen', arguments: result);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công. UID: $result')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const LoginScreen()),
            // );
          },
        ),
      ),
      body: Center(
        child: Padding(
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
                width: 300.0,
                height: 50.0,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                width: 300.0,
                height: 50.0,
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16.0),
              // nhập lai mat khau
              Container(
                width: 300.0,
                height: 50.0,
                child: TextField(
                  controller: _passwordAgainController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Nhập lại mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Đăng ký'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () async {
                  await _registerWithGoogle();
                },
                icon: SvgPicture.network(
                  'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                  height: 24.0,
                  width: 24.0,
                ),
                label: const Text(
                  'Đăng nhập bằng Google',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}