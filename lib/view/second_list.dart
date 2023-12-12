import 'dart:convert';

import 'package:demo/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondListPage extends StatefulWidget {
  const SecondListPage({super.key});

  @override
  State<SecondListPage> createState() => _SecondListPageState();
}

class _SecondListPageState extends State<SecondListPage> {
  final List<ListModel> _dataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    _dataList.clear();
    String jsonString = await rootBundle.loadString('assets/json/list.json');
    Map<String, dynamic> dict = jsonDecode(jsonString);
    _dataList.addAll(
        dict['data'].map<ListModel>((e) => ListModel.fromJson(e)).toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('系统二级列表'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildExpansionPanel(),
        ),
      ),
    );
  }

  Widget _buildExpansionPanel() {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: _dataList[0].id, //默认展开第一个
      expandIconColor:
          Colors.white, //设置icon的颜色，因为设置了canTapOnHeader: true，所以这里无效
      dividerColor: const Color.fromARGB(0, 233, 219, 219),
      expandedHeaderPadding: const EdgeInsets.all(0),
      materialGapSize: 0,
      // 设置底部阴影大小
      elevation: 0,
      children: _dataList.map<ExpansionPanelRadio>((item) {
        return ExpansionPanelRadio(
          canTapOnHeader: true, //点击区域
          backgroundColor: Colors.red,
          value: item.id!, //唯一标识
          headerBuilder: (context, isExpanded) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item.title!,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
          body: ListView.builder(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: item.subData!.length,
            itemExtent: 76.0,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.green,
                child: ListTile(
                  title: Text(item.subData![index].title!),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
