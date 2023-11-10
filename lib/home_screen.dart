import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nobest_tag_app/api/api_services.dart';
import 'package:nobest_tag_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:nobest_tag_app/components/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nobest_tag_app/components/my_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String uid = 'NULL TAGID';

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  void logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
  }

  void getNewId() async {
    var id = FirebaseAuth.instance.currentUser?.uid;

    if (id == null) {
      Fluttertoast.showToast(
        msg: "Please login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return;
    }

    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Random tagid 100000000~999999999
    var tagid = new Random().nextInt(900000000) + 100000000;
    var body = {'tagid': tagid.toString(), 'status': false};
    var resPost1 = await ApiServices().generateTag(body);

    Navigator.pop(context);

    // Show toast message
    Fluttertoast.showToast(
      msg: "Get ID successfully.\nPlease tap NFC tag to set ID.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[600],
      textColor: Colors.white,
      fontSize: 16.0,
    );

    _ndefWrite(tagid.toString(), resPost1['id']);
  }

  @override
  void initState() {
    super.initState();
    _tagRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NavBar(pageTitle: 'ホームページ'),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyButton(
                            text: uid,
                            onTap: getNewId,
                          )
                        ],
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

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];

      if (tagNdef['cachedMessage'] == null) {
        setState(() {
          uid = 'NULL TAGID';
        });
        return;
      }

      Map cachedMessages = tagNdef['cachedMessage'];

      String payloadAsString = '';
      String tagID = 'NULL TAGID';

      for (var i = 0; i < cachedMessages['records'].length; i++) {
        Map records = cachedMessages['records'][i];
        Uint8List payload = records['payload'];

        String data = utf8.decode(payload).replaceAll('en', '');

        payloadAsString = '$payloadAsString $data\n';

        // check data include TAGID_ set uid
        if (data.contains('TAGID_')) {
          tagID = data;
        }
      }

      // remote last \n
      payloadAsString =
          payloadAsString.substring(0, payloadAsString.length - 1);

      setState(() {
        uid = tagID;
      });

      // NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite(tagid, id) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        NfcManager.instance.stopSession();
        return;
      }

      try {
        String tagId = 'TAGID_' + tagid;
        NdefMessage message = NdefMessage([
          NdefRecord.createText(tagId),
        ]);

        await ndef.write(message);
        await ApiServices().activeTag(id, {'status': true});

        setState(() {
          uid = tagId;
        });

        Fluttertoast.showToast(
          msg: "Set ID successfully.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0,
        );

        NfcManager.instance.stopSession();

        _tagRead();
      } catch (e) {
        NfcManager.instance.stopSession();
        return;
      }
    });
  }
}
