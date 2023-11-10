import 'package:nobest_tag_app/app_theme.dart';
import 'package:nobest_tag_app/navigation_home_screen.dart';
import 'package:nobest_tag_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nobest_tag_app/components/square_tile.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({superKey});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {
    // check if username and password are not empty
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      return;
    }

    // show loading
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException {
      Navigator.pop(context);
      showMessageError('Email or password is incorrect');
    }
  }

  void showMessageError(message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                      color: AppTheme.nearlyBlack,
                    ),

                    // Text(
                    //   'Welcome back you\'ve been missed!',
                    //   style: TextStyle(
                    //     color: Colors.grey[700],
                    //     fontSize: 16,
                    //   ),
                    // ),

                    // const SizedBox(height: 25),

                    // // username textfield
                    // MyTextField(
                    //   controller: usernameController,
                    //   hintText: 'Username',
                    //   obscureText: false,
                    // ),

                    // const SizedBox(height: 10),

                    // // password textfield
                    // MyTextField(
                    //   controller: passwordController,
                    //   hintText: 'Password',
                    //   obscureText: true,
                    // ),

                    // const SizedBox(height: 10),

                    // // forgot password?
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Text(
                    //         'Forgot Password?',
                    //         style: TextStyle(color: Colors.grey[600]),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const SizedBox(height: 25),

                    // // sign in button
                    // MyButton(
                    //   text: 'Sign In',
                    //   onTap: signUserIn,
                    // ),

                    const SizedBox(height: 40),

                    // or continue with
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Login with',
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 20),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // google + apple sign in buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // google button
                        SquareTile(
                            onTap: () async => {
                                  await AuthService().signInWithGoogle(),
                                  Navigator.push<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          NavigationHomeScreen(),
                                    ),
                                  ),
                                },
                            imagePath: 'assets/images/google.png'),

                        SizedBox(width: 25),

                        // apple button
                        SquareTile(
                            onTap: () async => {
                                  await AuthService().signInWithApple(),
                                  Navigator.push<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          NavigationHomeScreen(),
                                    ),
                                  ),
                                },
                            imagePath: 'assets/images/apple.png')
                      ],
                    ),

                    // const SizedBox(height: 20),

                    // not a member? register now
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       'Not a member?',
                    //       style: TextStyle(color: Colors.grey[700]),
                    //     ),
                    //     const SizedBox(width: 4),
                    //     GestureDetector(
                    //       onTap: widget.onTap,
                    //       child: const Text(
                    //         'Register now',
                    //         style: TextStyle(
                    //           color: Colors.blue,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
