import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:nobest_tag_app/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:nobest_tag_app/components/dialog_ex2.dart';
import 'package:nobest_tag_app/components/item.dart';
import 'components/nav_bar.dart';
import 'package:nobest_tag_app/model/food.dart';
import 'package:http/http.dart' as http;

import 'model/filter_list.dart';

class InventoryScreen extends StatefulWidget {
  InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  List<Food> foods = [];

  List selectedFoods = [];

  bool showFilter = false;

  List<FilterListData> filterList = [
    FilterListData(
      titleTxt: '画像',
      value: 'image',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: '品名',
      value: 'title',
      isSelected: true,
    ),
    FilterListData(
      titleTxt: '値段',
      value: 'price',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'SKU',
      value: 'sku',
      isSelected: true,
    ),
    FilterListData(
      titleTxt: '説明',
      value: 'description',
      isSelected: true,
    ),
    FilterListData(
      titleTxt: '作成日時',
      value: 'created_at',
      isSelected: false,
    ),
  ];

  final searchController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setShowFilter() {
    setState(() {
      showFilter = !showFilter;
    });
  }

  void updateFoodSelected(id) {
    setState(() {
      if (selectedFoods.contains(id)) {
        selectedFoods.remove(id);
      } else {
        selectedFoods.add(id);
      }
    });
  }

  // get list foods
  Future getFoods() async {
    var url = Uri.parse('https://5e75b1629dff12001635417e.mockapi.io/GMovie');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });
    var jsonData = json.decode(utf8.decode(response.bodyBytes));

    // clear list
    foods.clear();

    for (var food in jsonData) {
      DateTime parseDate = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
          .parse(food['createdAt']);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputFormat = DateFormat('yyyy/MM/dd hh:mm');

      final item = Food(
        id: food['id'],
        date: food['date'],
        image: food['image'],
        title: food['title'],
        price: food['price'],
        sku: food['sku'],
        description: food['description'],
        createdAt: outputFormat.format(inputDate).toString(),
      );

      foods.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.white,
        body: FutureBuilder(
          future: getFoods(),
          builder: (context, snapshot) {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NavBar(pageTitle: '棚卸する'),
                  filterBarUI(),
                  showFilter ? popularFilter() : Container(),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 8, top: 8, bottom: 8),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(24.0),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  // open dialog choose year
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("棚卸年度選択"),
                                        content: Container(
                                          // Need to use container to add size constraint.
                                          width: 300,
                                          height: 300,
                                          child: YearPicker(
                                            firstDate: DateTime(
                                                DateTime.now().year - 100, 1),
                                            lastDate: DateTime(
                                                DateTime.now().year + 100, 1),
                                            initialDate: DateTime.now(),
                                            // save the selected date to _selectedDate DateTime variable.
                                            // It's used to set the previous selected date when
                                            // re-showing the dialog.
                                            selectedDate: _selectedDate,
                                            onChanged: (DateTime dateTime) {
                                              // close the dialog when year is selected.
                                              Navigator.pop(context);

                                              // Do something with the dateTime selected.
                                              // Remember that you need to use dateTime.year to get the year
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    '棚卸年度選択',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 16, top: 8, bottom: 8),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue[400],
                              borderRadius: const BorderRadius.all(
                                Radius.circular(24.0),
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(24.0)),
                                highlightColor: Colors.transparent,
                                onTap: () {},
                                child: Center(
                                  child: Text(
                                    '棚卸完了',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: foods.length,
                        padding: const EdgeInsets.only(top: 8),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      Dialog2Example(itemData: foods[index]));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 12, left: 16, right: 16),
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                padding: EdgeInsets.only(left: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4.0)),
                                        onTap: () {
                                          updateFoodSelected(foods[index].id);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                selectedFoods.contains(
                                                        foods[index].id)
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                color: selectedFoods.contains(
                                                        foods[index].id)
                                                    ? Colors.blue[400]
                                                    : Colors.grey
                                                        .withOpacity(0.6),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (filterList[0].isSelected) ...[
                                          SizedBox(
                                            height: 4,
                                          ),
                                          FittedBox(
                                              child: Image.network(
                                                foods[index].image,
                                                width: 100,
                                                height: 100,
                                              ),
                                              fit: BoxFit.cover),
                                        ],
                                        FittedBox(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 4,
                                              ),
                                              if (filterList[1].isSelected)
                                                PItem(
                                                    title:
                                                        filterList[1].titleTxt,
                                                    value: foods[index].title),
                                              if (filterList[2].isSelected)
                                                PItem(
                                                    title:
                                                        filterList[2].titleTxt,
                                                    value: '¥' +
                                                        foods[index].price),
                                              if (filterList[3].isSelected)
                                                PItem(
                                                    title:
                                                        filterList[3].titleTxt,
                                                    value: foods[index].sku),
                                              if (filterList[4].isSelected)
                                                PItem(
                                                    title:
                                                        filterList[4].titleTxt,
                                                    value: foods[index]
                                                        .description),
                                              if (filterList[5].isSelected)
                                                PItem(
                                                    title:
                                                        filterList[5].titleTxt,
                                                    value:
                                                        foods[index].createdAt),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget filterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
          ),
        ),
        Container(
          color: AppTheme.nearlyWhite,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      foods.length.toString() +
                          '製品' +
                          "  |  " +
                          selectedFoods.length.toString() +
                          '選択中',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      setShowFilter();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(showFilter ? Icons.close : Icons.sort,
                                color: Colors.blue[400]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
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

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 8),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    for (int idx = 0; idx < filterList.length; idx += 2) {
      final List<Widget> listUI = <Widget>[];
      listUI.add(
        Expanded(
          child: Row(
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  onTap: () {
                    setState(() {
                      filterList[idx].isSelected = !filterList[idx].isSelected;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          filterList[idx].isSelected
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: filterList[idx].isSelected
                              ? Colors.blue[400]
                              : Colors.grey.withOpacity(0.6),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          filterList[idx].titleTxt,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      if (idx + 1 < filterList.length)
        listUI.add(
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        filterList[idx + 1].isSelected =
                            !filterList[idx + 1].isSelected;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            filterList[idx + 1].isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: filterList[idx + 1].isSelected
                                ? Colors.blue[400]
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            filterList[idx + 1].titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }
}
