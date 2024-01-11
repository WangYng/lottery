import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lottery/entity/store_entity.dart';
import 'package:lottery/entity/ticket_entity.dart';
import 'package:lottery/event/data_change_event.dart';
import 'package:lottery/page/home_page.dart';
import 'package:lottery/page/widget/statistic_widget.dart';
import 'package:lottery/page/widget/table_content_widget.dart';

class HomeSubPage extends StatefulWidget {
  final int subPageIndex;
  final int redBallMax;
  final int blueBallMax;
  final LotteryTableEntity tableEntity;

  const HomeSubPage({
    super.key,
    required this.subPageIndex,
    required this.redBallMax,
    required this.blueBallMax,
    required this.tableEntity,
  });

  @override
  State<StatefulWidget> createState() {
    return _HomeSubPageState();
  }
}

class _HomeSubPageState extends State<HomeSubPage> with AutomaticKeepAliveClientMixin{
  List<TicketEntity> get ticketList {
    return widget.tableEntity.table;
  }

  List<StatisticColorEntity> get statisticColorList {
    return widget.tableEntity.statistic;
  }

  List<TicketEntity> editTicketList = [];

  bool showDoubleNum = false;
  bool showContinueNum = false;
  bool showSideNum = false;
  bool showRedColor = true;
  bool showYellowColor = true;
  bool showGreenColor = true;
  bool showBlueColor = true;
  bool showPurpleColor = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints.tightFor(width: double.infinity),
          decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
          child: FittedBox(
            child: Container(
              constraints: BoxConstraints.tightFor(width: 250 + (widget.redBallMax + widget.blueBallMax) * 21),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  buildFilterButton(),
                  SizedBox(height: 10),
                  Container(constraints: BoxConstraints.expand(height: 1), color: Colors.white),
                  buildTableHeader("期号", tail: "金额"),
                  Container(constraints: BoxConstraints.expand(height: 1), color: Colors.white),
                  TableContentWidget(
                    subPageIndex: widget.subPageIndex,
                    ticketList: ticketList,
                    redBallMax: widget.redBallMax,
                    blueBallMax: widget.blueBallMax,
                    editTicketList: editTicketList,
                    showDoubleNum: showDoubleNum,
                    showContinueNum: showContinueNum,
                    showSideNum: showSideNum,
                    showRedColor: showRedColor,
                    showYellowColor: showYellowColor,
                    showGreenColor: showGreenColor,
                    showBlueColor: showBlueColor,
                    showPurpleColor: showPurpleColor,
                  ),
                  Container(constraints: BoxConstraints.expand(height: 5), color: Colors.white),
                  StatisticWidget(
                    ticketList: ticketList,
                    statisticColorList: statisticColorList,
                    redBallMax: widget.redBallMax,
                    blueBallMax: widget.blueBallMax,
                    showRedColor: true,
                    showYellowColor: true,
                    showGreenColor: true,
                    showBlueColor: true,
                    showPurpleColor: true,
                  ),
                  Container(constraints: BoxConstraints.expand(height: 1), color: Colors.white),
                  buildTableHeader(""),
                  Container(constraints: BoxConstraints.expand(height: 20), color: Colors.white),
                  buildEditButton(),
                  Container(constraints: BoxConstraints.expand(height: 20), color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 过滤
  Widget buildFilterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildCheckBox(
          color: redColor,
          value: showRedColor,
          text: "红色",
          onChanged: (value) {
            setState(() => showRedColor = value);
          },
        ),
        SizedBox(width: 20),
        buildCheckBox(
          color: yellowColor,
          value: showYellowColor,
          text: "黄色",
          onChanged: (value) {
            setState(() => showYellowColor = value);
          },
        ),
        SizedBox(width: 20),
        buildCheckBox(
          color: greenColor,
          value: showGreenColor,
          text: "绿色",
          onChanged: (value) {
            setState(() => showGreenColor = value);
          },
        ),
        SizedBox(width: 20),
        buildCheckBox(
          color: blueColor,
          value: showBlueColor,
          text: "蓝色",
          onChanged: (value) {
            setState(() => showBlueColor = value);
          },
        ),
        SizedBox(width: 20),
        buildCheckBox(
          color: purpleColor,
          value: showPurpleColor,
          text: "紫色",
          onChanged: (value) {
            setState(() => showPurpleColor = value);
          },
        ),
        SizedBox(width: 20),
        buildCheckBox(
          color: doubleNumColor,
          value: showDoubleNum,
          text: "重号",
          onChanged: (value) {
            setState(() => showDoubleNum = value);
          },
        ),
        SizedBox(width: 20),
        buildCheckBox(
          color: continueNumColor,
          value: showContinueNum,
          text: "连号",
          onChanged: (value) {
            setState(() => showContinueNum = value);
          },
        ),
        SizedBox(width: 20),
        buildCheckBox(
          color: sideNumColor,
          value: showSideNum,
          text: "边号",
          onChanged: (value) {
            setState(() => showSideNum = value);
          },
        ),
      ],
    );
  }

  // 表头
  Widget buildTableHeader(String title, {String? tail}) {
    return Container(
      constraints: BoxConstraints.expand(height: 20),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints.tightFor(width: 80, height: 20),
            child: Text(title, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
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
              return Container(
                alignment: Alignment.center,
                color: Color(0xFFCBEDFB),
                constraints: BoxConstraints.tightFor(width: 20, height: 20),
                child: Text("${index + 1}", style: TextStyle(color: Colors.black, fontSize: 14, height: 1.1)),
              );
            },
            itemCount: widget.redBallMax,
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
              return Container(
                alignment: Alignment.center,
                color: Color(0xFFCBEDFB),
                constraints: BoxConstraints.tightFor(width: 20, height: 20),
                child: Text("${index + 1}", style: TextStyle(color: Colors.black, fontSize: 14, height: 1.1)),
              );
            },
            itemCount: widget.blueBallMax,
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
          if (tail != null) ...[
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints.tightFor(width: 80, height: 20),
              child: Text(tail, style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            Container(constraints: BoxConstraints.expand(width: 5), color: Colors.white),
          ],
        ],
      ),
    );
  }

  // 编辑按钮
  Widget buildEditButton() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 10),
          RichText(
            text: TextSpan(
              children: const <InlineSpan>[
                TextSpan(text: "[重号] ", style: TextStyle(color: Color(0xFF5C9292))),
                TextSpan(text: "前两期连续出现两次的号码\n"),
                TextSpan(text: "[连号] ", style: TextStyle(color: Color(0xFFEA3CF7))),
                TextSpan(text: "即相连号，中奖号码按顺序相连\n"),
                TextSpan(text: "[边号] ", style: TextStyle(color: Color(0xFFF19937))),
                TextSpan(text: "也叫邻号，与上期开出的中奖号码加减余1的号码"),
              ],
              style: TextStyle(color: Colors.black, fontSize: 14, height: 2),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: CupertinoButton(
                    padding: EdgeInsets.all(10),
                    color: Colors.redAccent,
                    onPressed: () {
                      final ticket = TicketEntity();
                      ticketList.add(ticket);
                      editTicketList.add(ticket);

                      eventBus.fire(DataChangeEvent());
                    },
                    child: Text("增加一期"),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: CupertinoButton(
                    padding: EdgeInsets.all(10),
                    color: Colors.redAccent,
                    onPressed: () async {
                      final file = await openFile(acceptedTypeGroups: [
                        XTypeGroup(extensions: const <String>["xls", "xlsx"])
                      ]);

                      if (file != null) {
                        var bytes = File(file.path).readAsBytesSync();
                        var excel = Excel.decodeBytes(bytes);

                        if (excel.tables.keys.isEmpty) {
                          return;
                        }

                        final sheetName = excel.tables.keys.first;
                        final table = excel.tables[sheetName]!;

                        Data? redBallStart;
                        Data? redBallEnd;

                        Data? blueBallStart;
                        Data? blueBallEnd;

                        int? dataRowIndex;
                        Map<int, TicketEntity> ticketMap = {};

                        for (final row in table.rows) {
                          for (final cell in row) {
                            if (cell == null) {
                              continue;
                            }

                            if (redBallStart == null) {
                              if (cell.value == 1) {
                                redBallStart = cell;
                              }
                            } else if (redBallEnd == null && redBallStart.rowIndex == cell.rowIndex) {
                              if (cell.value == widget.redBallMax) {
                                redBallEnd = cell;
                              }
                            } else if (blueBallStart == null && redBallStart.rowIndex == cell.rowIndex) {
                              if (cell.value == 1) {
                                blueBallStart = cell;
                              }
                            } else if (blueBallEnd == null && redBallStart.rowIndex == cell.rowIndex) {
                              if (cell.value == widget.blueBallMax) {
                                blueBallEnd = cell;
                              }
                            }

                            if (redBallStart != null && redBallEnd != null && blueBallStart != null && blueBallEnd != null) {
                              // 检测数据结束
                              if (dataRowIndex == null) {
                                dataRowIndex = redBallStart.rowIndex;
                                continue;
                              } else if (dataRowIndex == cell.rowIndex) {
                                // noop
                              } else if (dataRowIndex + 1 == cell.rowIndex) {
                                dataRowIndex = cell.rowIndex;
                              } else {
                                break;
                              }

                              // 检测数据
                              TicketEntity ticketEntity = ticketMap[dataRowIndex] ?? TicketEntity();

                              if (cell.columnIndex >= redBallStart.columnIndex && cell.columnIndex <= redBallEnd.columnIndex) {
                                final num = int.tryParse(cell.value.toString());
                                if (num != null) {
                                  final ball = TicketBallEntity();
                                  ball.num = num;
                                  ticketEntity.redBallList.add(ball);
                                  ticketMap[dataRowIndex] = ticketEntity;
                                }
                              } else if (cell.columnIndex >= blueBallStart.columnIndex && cell.columnIndex <= blueBallEnd.columnIndex) {
                                final num = int.tryParse(cell.value.toString());
                                if (num != null) {
                                  final ball = TicketBallEntity();
                                  ball.num = num;
                                  ticketEntity.blueBallList.add(ball);
                                  ticketMap[dataRowIndex] = ticketEntity;
                                }
                              }
                            }
                          }
                        }

                        if (ticketMap.values.isNotEmpty) {
                          ticketList.clear();
                          ticketList.addAll(ticketMap.values);

                          editTicketList.clear();

                          eventBus.fire(DataChangeEvent());

                          EasyLoading.showToast("导入成功");
                        }
                      }
                    },
                    child: Text("从Excel导入"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget buildCheckBox({required Color color, required bool value, required String text, required ValueChanged<bool> onChanged}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => onChanged(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                if (value) Icon(Icons.check_box_outlined, color: color, size: 20),
                if (!value) Icon(Icons.check_box_outline_blank, color: color, size: 20),
              ],
            ),
            SizedBox(width: 2),
            Text(text, style: TextStyle(color: color, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Future showAlertDialog(BuildContext context, String text) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (alertContext) {
        return CupertinoAlertDialog(
          content: Text(text, style: TextStyle(fontSize: 15)),
          actions: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(alertContext).pop(false),
              child: Text("取消", style: TextStyle(fontSize: 16, color: Colors.grey)),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(alertContext).pop(true),
              child: Text("确定", style: TextStyle(fontSize: 16, color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
