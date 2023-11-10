import 'package:nobest_tag_app/app_theme.dart';
import 'package:nobest_tag_app/model/food.dart';
import 'components/nav_bar.dart';
import 'package:flutter/material.dart';

import 'item_update_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final Food product;

  const ProductDetailScreen({super.key, required this.product});

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NavBar(pageTitle: '製品詳細', showBack: true),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: Image.network(
                              product.image,
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
                                item('品名', product.title),
                                item('SKU', product.sku),
                                item('値段', '¥' + product.price.toString()),
                                item('説明', product.description),
                                item('作成日時', product.createdAt),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 48,
                                        height: 48,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.nearlyWhite,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(16.0),
                                            ),
                                            border: Border.all(
                                                color: AppTheme.grey
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent
                                                .withOpacity(0.8),
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push<dynamic>(
                                              context,
                                              MaterialPageRoute<dynamic>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          ProductUpdateScreen(
                                                              product:
                                                                  product)),
                                            );
                                          },
                                          child: Container(
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: AppTheme.nearlyBlack,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(16.0),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '編集',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  letterSpacing: 0.0,
                                                  color: AppTheme.nearlyWhite,
                                                ),
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
                  ),
                ],
              ),
            );
          }
        },
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
            width: 100,
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
            width: 240,
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
