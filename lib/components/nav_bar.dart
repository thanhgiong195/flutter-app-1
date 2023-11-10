import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nobest_tag_app/components/dialog_login.dart';
import 'package:nobest_tag_app/navigation_home_screen.dart';
import 'package:nobest_tag_app/services/auth_service.dart';

class NavBar extends ConsumerWidget {
  final String pageTitle;
  final bool showBack;

  const NavBar({super.key, required this.pageTitle, this.showBack = false});

  void logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isSignedIn = AuthService().isSignedIn();

    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 4.0),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (showBack)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  pageTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, right: 8),
              child: Container(
                width: AppBar().preferredSize.height - 8,
                height: AppBar().preferredSize.height - 8,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (!showBack)
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(32.0),
                          ),
                          onTap: () => {
                            if (isSignedIn) ...[
                              logout(),
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NavigationHomeScreen()),
                                  (route) => false)
                            ] else
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogLogin(),
                              ),
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Icon(isSignedIn ? Icons.logout : Icons.login),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
