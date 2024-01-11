import 'package:flutter/material.dart';
import 'package:lottery/entity/store_entity.dart';
import 'package:lottery/entity/ticket_entity.dart';
import 'package:lottery/event/data_change_event.dart';
import 'package:lottery/page/home_page.dart';
import 'package:lottery/page/widget/table_content_widget.dart';

enum StatisticType {
  redBallAppear,
  redBallDoubleNumAppear,
  redBallContinueNumAppear,
  redBallSideNumAppear,
  blueBallAppear,
  blueBallDoubleNumAppear,
  blueBallContinueNumAppear,
  blueBallSideNumAppear,
}

class StatisticWidget extends StatefulWidget {
  final List<TicketEntity> ticketList;
  final List<StatisticColorEntity> statisticColorList;

  final int redBallMax;
  final int blueBallMax;

  final bool showRedColor;
  final bool showYellowColor;
  final bool showGreenColor;
  final bool showBlueColor;
  final bool showPurpleColor;

  const StatisticWidget({
    super.key,
    required this.ticketList,
    required this.statisticColorList,
    required this.redBallMax,
    required this.blueBallMax,
    required this.showRedColor,
    required this.showYellowColor,
    required this.showGreenColor,
    required this.showBlueColor,
    required this.showPurpleColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _StatisticWidgetState();
  }
}

class _StatisticWidgetState extends State<StatisticWidget> {
  TapDownDetails? tapDownDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildAppear(),
        Container(constraints: BoxConstraints.expand(height: 1), color: Colors.white),
        buildDoubleNumAppear(),
        Container(constraints: BoxConstraints.expand(height: 1), color: Colors.white),
        buildContinueNumAppear(),
        Container(constraints: BoxConstraints.expand(height: 1), color: Colors.white),
        buildSideNumAppear(),
      ],
    );
  }

  // 出现次数
  Widget buildAppear() {
    List<int> redBallDataList = [];
    List<int> blueBallDataList = [];

    for (int num = 1; num <= widget.redBallMax; num++) {
      int time = 0;
      for (final ticket in widget.ticketList) {
        if (ticket.isContainRedBall(num)) {
          time = time + 1;
        }
      }
      redBallDataList.add(time);
    }

    for (int num = 1; num <= widget.blueBallMax; num++) {
      int time = 0;
      for (final ticket in widget.ticketList) {
        if (ticket.isContainBlueBall(num)) {
          time = time + 1;
        }
      }
      blueBallDataList.add(time);
    }

    Map<int, Color> redBallColorMap = {};
    for (final entity in widget.statisticColorList) {
      if (entity.type == StatisticType.values.indexOf(StatisticType.redBallAppear)) {
        redBallColorMap[entity.num] = Color(entity.color);
      }
    }

    Map<int, Color> blueBallColorMap = {};
    for (final entity in widget.statisticColorList) {
      if (entity.type == StatisticType.values.indexOf(StatisticType.blueBallAppear)) {
        blueBallColorMap[entity.num] = Color(entity.color);
      }
    }

    return Container(
      constraints: BoxConstraints.expand(height: 20),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints.tightFor(width: 80, height: 20),
            child: Text("出现次数", style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return buildCount(StatisticType.redBallAppear, index + 1, redBallDataList[index], customColor: redBallColorMap[index + 1]);
            },
            itemCount: redBallDataList.length,
          ),
          Container(constraints: BoxConstraints.expand(width: 5), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return buildCount(StatisticType.blueBallAppear, index + 1, blueBallDataList[index], customColor: blueBallColorMap[index + 1]);
            },
            itemCount: blueBallDataList.length,
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
        ],
      ),
    );
  }

  // 重号次数
  Widget buildDoubleNumAppear() {
    List<int> redBallDataList = [];
    List<int> blueBallDataList = [];

    for (int num = 1; num <= widget.redBallMax; num++) {
      int time = 0;

      TicketEntity? previousTicket;
      for (final ticket in widget.ticketList) {
        if (ticket.isContainRedBall(num)) {
          if (previousTicket != null) {
            time = time + 1;
          }

          previousTicket = ticket;
        } else {
          previousTicket = null;
        }
      }
      redBallDataList.add(time);
    }

    for (int num = 1; num <= widget.blueBallMax; num++) {
      int time = 0;

      TicketEntity? previousTicket;
      for (final ticket in widget.ticketList) {
        if (ticket.isContainBlueBall(num)) {
          if (previousTicket != null) {
            time = time + 1;
          }

          previousTicket = ticket;
        } else {
          previousTicket = null;
        }
      }
      blueBallDataList.add(time);
    }

    Map<int, Color> redBallColorMap = {};
    for (final entity in widget.statisticColorList) {
      if (entity.type == StatisticType.values.indexOf(StatisticType.redBallDoubleNumAppear)) {
        redBallColorMap[entity.num] = Color(entity.color);
      }
    }

    Map<int, Color> blueBallColorMap = {};
    for (final entity in widget.statisticColorList) {
      if (entity.type == StatisticType.values.indexOf(StatisticType.blueBallDoubleNumAppear)) {
        blueBallColorMap[entity.num] = Color(entity.color);
      }
    }

    return Container(
      constraints: BoxConstraints.expand(height: 20),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints.tightFor(width: 80, height: 20),
            child: Text("重号次数", style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return buildCount(StatisticType.redBallDoubleNumAppear, index + 1, redBallDataList[index], customColor: redBallColorMap[index + 1]);
            },
            itemCount: redBallDataList.length,
          ),
          Container(constraints: BoxConstraints.expand(width: 5), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return buildCount(StatisticType.blueBallDoubleNumAppear, index + 1, blueBallDataList[index], customColor: blueBallColorMap[index + 1]);
            },
            itemCount: blueBallDataList.length,
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
        ],
      ),
    );
  }

  // 连号次数
  Widget buildContinueNumAppear() {
    List<int> redBallDataList = [0];
    List<int> blueBallDataList = [0];

    for (int num = 2; num <= widget.redBallMax; num++) {
      int time = 0;

      for (final ticket in widget.ticketList) {
        if (ticket.isContainRedBall(num) && ticket.isContainRedBall(num - 1)) {
          time = time + 1;
        }
      }
      redBallDataList.add(time);
    }

    for (int num = 2; num <= widget.blueBallMax; num++) {
      int time = 0;

      for (final ticket in widget.ticketList) {
        if (ticket.isContainBlueBall(num) && ticket.isContainBlueBall(num - 1)) {
          time = time + 1;
        }
      }
      blueBallDataList.add(time);
    }

    Map<int, Color> redBallColorMap = {};
    for (final entity in widget.statisticColorList) {
      if (entity.type == StatisticType.values.indexOf(StatisticType.redBallContinueNumAppear)) {
        redBallColorMap[entity.num] = Color(entity.color);
      }
    }

    Map<int, Color> blueBallColorMap = {};
    for (final entity in widget.statisticColorList) {
      if (entity.type == StatisticType.values.indexOf(StatisticType.blueBallContinueNumAppear)) {
        blueBallColorMap[entity.num] = Color(entity.color);
      }
    }

    return Container(
      constraints: BoxConstraints.expand(height: 20),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints.tightFor(width: 80, height: 20),
            child: Text("连号次数", style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return buildCount(StatisticType.redBallContinueNumAppear, index + 1, redBallDataList[index], customColor: redBallColorMap[index + 1]);
            },
            itemCount: redBallDataList.length,
          ),
          Container(constraints: BoxConstraints.expand(width: 5), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return buildCount(StatisticType.blueBallContinueNumAppear, index + 1, blueBallDataList[index], customColor: blueBallColorMap[index + 1]);
            },
            itemCount: blueBallDataList.length,
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
        ],
      ),
    );
  }

  // 边号次数
  Widget buildSideNumAppear() {
    List<int> redBallDataList = [];
    List<int> blueBallDataList = [];

    for (int num = 1; num <= widget.redBallMax; num++) {
      int time = 0;

      TicketEntity? previousTicket;
      for (final ticket in widget.ticketList) {
        if (ticket.isContainRedBall(num) && previousTicket != null) {
          if (num > 1 && previousTicket.isContainRedBall(num - 1)) {
            time = time + 1;
          } else if (num < widget.redBallMax && previousTicket.isContainRedBall(num + 1)) {
            time = time + 1;
          }
        }

        previousTicket = ticket;
      }

      redBallDataList.add(time);
    }

    for (int num = 1; num <= widget.blueBallMax; num++) {
      int time = 0;

      TicketEntity? previousTicket;
      for (final ticket in widget.ticketList) {
        if (ticket.isContainBlueBall(num) && previousTicket != null) {
          if (num > 1 && previousTicket.isContainBlueBall(num - 1)) {
            time = time + 1;
          } else if (num < widget.redBallMax && previousTicket.isContainBlueBall(num + 1)) {
            time = time + 1;
          }
        }

        previousTicket = ticket;
      }

      blueBallDataList.add(time);
    }

    Map<int, Color> redBallColorMap = {};
    for (final entity in widget.statisticColorList) {
      if (entity.type == StatisticType.values.indexOf(StatisticType.redBallSideNumAppear)) {
        redBallColorMap[entity.num] = Color(entity.color);
      }
    }

    Map<int, Color> blueBallColorMap = {};
    for (final entity in widget.statisticColorList) {
      if (entity.type == StatisticType.values.indexOf(StatisticType.blueBallSideNumAppear)) {
        blueBallColorMap[entity.num] = Color(entity.color);
      }
    }

    return Container(
      constraints: BoxConstraints.expand(height: 20),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints.tightFor(width: 80, height: 20),
            child: Text("边号次数", style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return buildCount(StatisticType.redBallSideNumAppear, index + 1, redBallDataList[index], customColor: redBallColorMap[index + 1]);
            },
            itemCount: redBallDataList.length,
          ),
          Container(constraints: BoxConstraints.expand(width: 5), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int index) {
              return buildCount(StatisticType.blueBallSideNumAppear, index + 1, blueBallDataList[index], customColor: blueBallColorMap[index + 1]);
            },
            itemCount: blueBallDataList.length,
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
        ],
      ),
    );
  }

  // 数据
  Widget buildCount(StatisticType type, int num, int count, {Color? customColor}) {

    Color? specialColor;
    if (widget.showRedColor && customColor?.value == redColor.value) {
      specialColor ??= redColor;
    }
    if (widget.showYellowColor && customColor?.value == yellowColor.value) {
      specialColor ??= yellowColor;
    }
    if (widget.showGreenColor && customColor?.value == greenColor.value) {
      specialColor ??= greenColor;
    }
    if (widget.showBlueColor && customColor?.value == blueColor.value) {
      specialColor ??= blueColor;
    }
    if (widget.showPurpleColor && customColor?.value == purpleColor.value) {
      specialColor ??= purpleColor;
    }

    Color textColor = specialColor == null ? Color(0xFFCDB1B1) : Colors.white;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTap: () => onSecondaryTap(type, num, count, color: customColor),
      child: Container(
        color: specialColor,
        alignment: Alignment.center,
        constraints: BoxConstraints.tightFor(width: 20, height: 20),
        child: Text("$count", style: TextStyle(color: textColor, fontSize: 14, height: 1.1)),
      ),
    );
  }

  Widget buildColorItem(dynamic value, Color color, {bool checked = true}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Navigator.pop(context, checked ? "defaultColor" : "$value"),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: checked ? Theme(data: ThemeData(), child: Icon(Icons.check, size: 14, color: Colors.white)) : null,
        ),
      ),
    );
  }

  void onSecondaryTapDown(TapDownDetails details) {
    setState(() {
      tapDownDetails = details;
    });
  }

  void onSecondaryTap(StatisticType type, int num, int count, {Color? color}) async {
    if (tapDownDetails != null) {
      final dx = tapDownDetails!.globalPosition.dx;
      final dy = tapDownDetails!.globalPosition.dy;

      final result = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx, dy),
        items: [
          PopupMenuItem(
            height: 30,
            enabled: false,
            child: Row(
              children: const [
                Icon(Icons.color_lens, color: Colors.black, size: 20),
                SizedBox(width: 10),
                Text("选择颜色", style: TextStyle(color: Colors.black, fontSize: 12)),
              ],
            ),
          ),
          PopupMenuItem(
            height: 30,
            enabled: false,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildColorItem(redColor.value, redColor, checked: redColor.value == color?.value),
                SizedBox(width: 10),
                buildColorItem(yellowColor.value, yellowColor, checked: yellowColor.value == color?.value),
                SizedBox(width: 10),
                buildColorItem(greenColor.value, greenColor, checked:greenColor.value == color?.value),
                SizedBox(width: 10),
                buildColorItem(blueColor.value, blueColor, checked: blueColor.value == color?.value),
                SizedBox(width: 10),
                buildColorItem(purpleColor.value, purpleColor, checked: purpleColor.value == color?.value),
              ],
            ),
          ),
        ],
      );

      setState(() {
        tapDownDetails = null;
      });

      if (result == null) {
        return;
      }

      widget.statisticColorList.removeWhere((e) {
        return e.type == StatisticType.values.indexOf(type) && e.num == num;
      });

      if (result != 'defaultColor') {
        final entity = StatisticColorEntity();
        entity.type = StatisticType.values.indexOf(type);
        entity.num = num;
        entity.color = int.parse(result.toString());

        widget.statisticColorList.add(entity);
      }

      eventBus.fire(DataChangeEvent());
    }
  }
}
