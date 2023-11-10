import 'package:flutter/material.dart';
import 'package:nobest_tag_app/app_theme.dart';

class PItem extends StatelessWidget {
  final String title;
  final String value;

  const PItem({super.key, required this.title, required this.value});

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 70,
            child: Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.nearlyBlack,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 160,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: AppTheme.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
