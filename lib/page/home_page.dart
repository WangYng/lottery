import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottery/entity/store_entity.dart';
import 'package:lottery/event/data_change_event.dart';
import 'package:lottery/page/home_sub_page.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

EventBus eventBus = EventBus();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late StreamSubscription dataChangeSubscription;

  LotteryTableEntity doubleColorBall = LotteryTableEntity();

  LotteryTableEntity lotto = LotteryTableEntity();

  late TabController controller;

  @override
  void initState() {
    super.initState();

    // 恢复数据
    restoreData();

    dataChangeSubscription = eventBus.on<DataChangeEvent>().listen((event) {
      setState(() {});

      saveData();
    });

    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    dataChangeSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: controller,
          labelColor: Colors.red,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          indicatorColor: Colors.red,
          tabs: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text("双色球"),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text("乐透"),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              HomeSubPage(subPageIndex: 0, redBallMax: 33, blueBallMax: 16, tableEntity: doubleColorBall),
              HomeSubPage(subPageIndex: 1, redBallMax: 35, blueBallMax: 12, tableEntity: lotto),
            ],
          ),
        ),
      ],
    );
  }

  void saveData() async {
    final path = await getSavePath();
    if (path != null) {
      final file = await File(path).create(recursive: true);

      final entity = StoreEntity();
      entity.doubleColorBall = doubleColorBall;
      entity.lotto = lotto;

      final jsonString = await compute(jsonEncode, entity.toJson());

      await file.writeAsString(jsonString);
    }
  }

  void restoreData() async {
    final path = await getSavePath();
    if (path != null) {
      final file = File(path);
      if (file.existsSync()) {
        String content = await file.readAsString();
        try {
          final json = await compute(jsonDecode, content);
          if (json != null) {
            final entity = StoreEntity().fromJson(json);
            setState(() {
              doubleColorBall = entity.doubleColorBall;
              lotto = entity.lotto;
            });
          }
        } catch (_) {}
      }
    }
  }

  Future<String?> getSavePath() async {
    Directory? dir;
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      dir = await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows) {
      dir = await getDownloadsDirectory();
    }

    if (dir != null) {
      return join(dir.path, "双色球数据.txt");
    }

    return null;
  }
}
