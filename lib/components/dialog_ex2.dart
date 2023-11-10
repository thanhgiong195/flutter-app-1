import 'package:flutter/material.dart';
import 'package:nobest_tag_app/app_theme.dart';

class Dialog2Example extends StatelessWidget {
  final itemData;

  const Dialog2Example({super.key, required this.itemData});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: Image.network(
                    itemData.image,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      // title
                      item('品名', itemData.title),
                      item('SKU', itemData.sku),
                      item('値段', '¥' + itemData.price.toString()),
                      item('説明', itemData.description),
                      item('作成日時', itemData.createdAt),
                      item('仕入れ日', '2023/10/06'),
                      item('最終棚卸年度', '2023'),

                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12, bottom: 12, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0),
                                  ),
                                  border: Border.all(
                                    color: AppTheme.nearlyBlack,
                                  ),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    '閉じる',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      letterSpacing: 0.0,
                                      color: AppTheme.nearlyBlack,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 95,
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
            width: 175,
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
