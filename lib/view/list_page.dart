import 'dart:convert';

import 'package:demo/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class SecondListViewPage extends StatefulWidget {
  const SecondListViewPage({super.key});

  @override
  State<SecondListViewPage> createState() => _SecondListViewPageState();
}

class _SecondListViewPageState extends State<SecondListViewPage> {
  final List<ListModel> _dataList = []; //列表数据
  List listData = []; //处理是否展开和展开动画的数据
  final bool _isRadio = true; //是否只展开一个，默认是
  final double _cellHeight = 40.0; //title的高度
  final double _itemHeight = 40.0; //展开的cell的高度

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    for (var listItem in listData) {
      listItem.animationController.dispose();
    }
    super.dispose();
  }

  _loadData() async {
    _dataList.clear();
    String jsonString = await rootBundle.loadString('assets/json/list.json');
    Map<String, dynamic> dict = jsonDecode(jsonString);
    _dataList.addAll(
        dict['data'].map<ListModel>((e) => ListModel.fromJson(e)).toList());

    for (var i = 0; i < _dataList.length; i++) {
      ListItem item = ListItem();
      //处理数据，给每个cell都新增一个isExpended属性
      item.isExpanded = i == 0 ? true : false; //默认第一个展开
      if (i == 0) {
        item.animationController.forward(); //第一个默认展开之后需要改变图片的旋转方向
      }
      listData.add(item);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义二级列表'),
      ),
      body: ListView.builder(
        itemCount: _dataList.length,
        itemBuilder: (context, index) {
          ListItem item = listData[index];
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    item.isExpanded = !item.isExpanded;
                    if (_isRadio) {
                      for (var i = 0; i < listData.length; i++) {
                        if (i != index) {
                          listData[i].isExpanded = false;
                        }
                        if (listData[i].isExpanded) {
                          listData[i].animationController.forward();
                        } else {
                          listData[i].animationController.reverse();
                        }
                      }
                    } else {
                      if (listData[index].isExpanded) {
                        listData[index].animationController.forward();
                      } else {
                        listData[index].animationController.reverse();
                      }
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  color: Colors.green,
                  height: _cellHeight,
                  child: Row(
                    children: [
                      // 显示title的widget，可以自定义
                      Text('${_dataList[index].title}'),
                      const SizedBox(width: 5.0),
                      AnimatedBuilder(
                        animation: item.animation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: item.animation.value * 3.14, // 180度对应的弧度值
                            child: const Icon(
                                Icons.arrow_drop_down), //这里可以替换成自定义的图片
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                color: Colors.yellow,
                duration: const Duration(milliseconds: 200),
                height: item.isExpanded
                    ? _dataList[index].subData!.length * _itemHeight
                    : 0.0,
                child: item.isExpanded
                    ? SingleChildScrollView(
                        child: Column(
                          children: _dataList[index].subData!.map((e) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              height: _itemHeight,
                              child: Text(e.title!),
                            );
                          }).toList(),
                        ),
                      )
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

class ListItem {
  bool isExpanded; //是否展开
  AnimationController animationController; //每个title展开或者关闭的时候，icon的旋转动画
  late Animation<double> animation; //

  ListItem({this.isExpanded = false})
      : animationController = AnimationController(
          duration: const Duration(milliseconds: 200),
          vsync: TickerProviderImpl(),
        ) {
    animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
}

class TickerProviderImpl extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}
