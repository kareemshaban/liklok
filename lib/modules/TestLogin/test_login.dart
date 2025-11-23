import 'package:LikLok/layout/tabs_screen.dart';
import 'package:LikLok/models/AppUser.dart';
import 'package:LikLok/shared/network/remote/AppUserServices.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestLogin extends StatefulWidget {
  const TestLogin({super.key});

  @override
  State<TestLogin> createState() => _TestLoginState();
}

class _TestLoginState extends State<TestLogin> {
  bool isLoading1 = false;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Login to continue',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),

                  /// ---------------- EMAIL FIELD ----------------
                  _modernTextField(
                    label: "Email",
                    controller: emailController,
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 20),

                  /// ---------------- PASSWORD FIELD ----------------
                  _modernTextField(
                    label: "Password",
                    controller: passwordController,
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 40),

                  /// ---------------- LOGIN BUTTON ----------------
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isLoading1
                          ? null
                          : () {
                        setState(() {
                          isLoading1 = true;
                        });
                        postUser(
                            emailController.text, passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading1
                          ? const SizedBox(
                        height: 26,
                        width: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                          : const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Modern TextField Widget
  Widget _modernTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }

  postUser(email, password) async {
    print('postUser');
    AppUser? user = await AppUserServices().testAccountLogin(email, password);

    if (user != null && user.id > 0) {
      setState(() {
        isLoading1 = false;
      });

      FirebaseMessaging.instance.subscribeToTopic('all');
      Fluttertoast.showToast(
        msg: 'login_welcome_msg'.tr,
        backgroundColor: Colors.black26,
        textColor: Colors.orange,
      );

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);

      AppUserServices().userSetter(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TabsScreen()),
      );
    } else {
      setState(() {
        isLoading1 = false;
      });
      Fluttertoast.showToast(
        msg: "Invalid email or password",
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
    }
  }
}
