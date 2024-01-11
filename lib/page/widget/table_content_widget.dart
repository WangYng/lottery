import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottery/entity/ticket_entity.dart';
import 'package:lottery/event/data_change_event.dart';
import 'package:lottery/page/home_page.dart';

const redBallColor = Color(0xFFB05858);
const blueBallColor = Color(0xFF3873A6);
const editBallColor = Color(0xFF979797);
const doubleNumColor = Color(0xFF5C9292);
const continueNumColor = Color(0xFFEA3CF7);
const sideNumColor = Color(0xFFFC7100);

const redColor = Color(0xFFE56659);
const yellowColor = Color(0xFFEBA54D);
const greenColor = Color(0xFF73CB6D);
const blueColor = Color(0xFF4D8CEF);
const purpleColor = Color(0xFFA875CD);

class TableContentWidget extends StatefulWidget {
  final int subPageIndex;

  final List<TicketEntity> ticketList;
  final List<TicketEntity> editTicketList;

  final int redBallMax;
  final int blueBallMax;

  final bool showDoubleNum;
  final bool showContinueNum;
  final bool showSideNum;
  final bool showRedColor;
  final bool showYellowColor;
  final bool showGreenColor;
  final bool showBlueColor;
  final bool showPurpleColor;

  const TableContentWidget({
    super.key,
    required this.subPageIndex,
    required this.ticketList,
    required this.redBallMax,
    required this.blueBallMax,
    required this.editTicketList,
    required this.showDoubleNum,
    required this.showContinueNum,
    required this.showSideNum,
    required this.showRedColor,
    required this.showYellowColor,
    required this.showGreenColor,
    required this.showBlueColor,
    required this.showPurpleColor,
  });

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<TableContentWidget> {
  TapDownDetails? tapDownDetails;

  @override
  Widget build(BuildContext context) {
    return buildTableContent();
  }

  // 数据表格
  Widget buildTableContent() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return Container(constraints: BoxConstraints.expand(height: 1), color: Colors.white);
      },
      itemBuilder: (BuildContext context, int index) {
        return buildTableItem(index);
      },
      itemCount: widget.ticketList.length,
    );
  }

  Widget buildTableItem(int index) {
    final ticket = widget.ticketList[index];

    return Container(
      constraints: BoxConstraints.expand(height: 20),
      color: Color(0xFFF2F2F2),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints.tightFor(width: 80, height: 20),
            child: Text("${index + 1}", style: TextStyle(color: Colors.black, fontSize: 14)),
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white);
            },
            itemBuilder: (BuildContext context, int ballIndex) {
              return buildRedBall(index, ballIndex + 1);
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
            itemBuilder: (BuildContext context, int ballIndex) {
              return buildBlueBall(index, ballIndex + 1);
            },
            itemCount: widget.blueBallMax,
          ),
          Container(constraints: BoxConstraints.expand(width: 1), color: Colors.white),
          if (widget.subPageIndex == 0)
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints.tightFor(width: 80, height: 20),
              child: Text("${ticket.moneyOne()}", style: TextStyle(color: Colors.black, fontSize: 14)),
            )
          else if (widget.subPageIndex == 1)
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints.tightFor(width: 80, height: 20),
              child: Text("${ticket.moneyTwo()}", style: TextStyle(color: Colors.black, fontSize: 14)),
            ),
          Container(constraints: BoxConstraints.expand(width: 5), color: Colors.white),
          SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CupertinoButton(
              minSize: 20,
              padding: EdgeInsets.zero,
              onPressed: () {
                if (widget.editTicketList.contains(ticket)) {
                  widget.editTicketList.remove(ticket);
                } else {
                  widget.editTicketList.add(ticket);
                }

                eventBus.fire(DataChangeEvent());
              },
              child: Row(
                children: [
                  if (widget.editTicketList.contains(ticket)) ...[
                    Icon(Icons.lock_open, size: 20, color: Colors.redAccent),
                    SizedBox(width: 3),
                    Text("锁定", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold))
                  ] else ...[
                    Icon(Icons.lock, size: 20, color: Colors.redAccent),
                    SizedBox(width: 3),
                    Text("解锁", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold))
                  ],
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget buildBallGestureDetector(int index, int num, {required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTapDown: (TapDownDetails details) {
        setState(() {
          tapDownDetails = details;
        });
      },
      onSecondaryTap: () async {
        if (tapDownDetails != null) {
          final dx = tapDownDetails!.globalPosition.dx;
          final dy = tapDownDetails!.globalPosition.dy;

          final result = await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(dx, dy, dx, dy),
            items: [
              buildMenuItem('insertUp', Icons.arrow_upward, "向上插入一行"),
              buildMenuItem('insertDown', Icons.arrow_downward, "向上插入一行"),
              buildMenuItem('delete', Icons.delete, "删除"),
            ],
          );

          setState(() {
            tapDownDetails = null;
          });

          if (result == null) {
            return;
          }

          if (result == 'insertUp') {
            widget.ticketList.insert(index, TicketEntity());
          } else if (result == 'insertDown') {
            widget.ticketList.insert(index + 1, TicketEntity());
          } else if (result == 'delete') {
            final entity = widget.ticketList.removeAt(index);
            widget.editTicketList.remove(entity);
          }

          eventBus.fire(DataChangeEvent());
        }
      },
      child: child,
    );
  }

  // 红球
  Widget buildRedBall(int index, int num) {
    final ticket = widget.ticketList[index];

    bool isSelected = ticket.isContainRedBall(num); // 选中
    bool isEdit = widget.editTicketList.contains(ticket); // 编辑状态

    bool isDoubleNum = false; // 重号
    bool isContinueNum = false; // 连号
    bool isSideNum = false; // 边号

    if (isSelected) {
      TicketEntity? previousTicket;
      if (index > 0) {
        previousTicket = widget.ticketList[index - 1];
      }

      if (previousTicket != null) {
        isDoubleNum = previousTicket.isContainRedBall(num);
      }

      if (num > 1) {
        isContinueNum = ticket.isContainRedBall(num - 1);
      }

      if (previousTicket != null) {
        if (num - 1 > 0) {
          isSideNum = previousTicket.isContainRedBall(num - 1);
        }
        if (isSideNum == false) {
          isSideNum = previousTicket.isContainRedBall(num + 1);
        }
      }
    }

    Color? specialColor;

    Color? customColor = ticket.getRedBallColor(num);
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
    if (isDoubleNum && widget.showDoubleNum) {
      specialColor ??= doubleNumColor;
    }
    if (isContinueNum && widget.showContinueNum) {
      specialColor ??= continueNumColor;
    }
    if (isSideNum && widget.showSideNum) {
      specialColor ??= sideNumColor;
    }

    if (isEdit) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (isSelected) {
              ticket.removeRedBall(num);
            } else {
              ticket.addRedBall(num);
            }

            eventBus.fire(DataChangeEvent());
          },
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTap: () => onSecondaryTap(index),
          child: Container(
            constraints: BoxConstraints.tightFor(width: 20, height: 20),
            child: Stack(
              children: [
                if (isSelected)
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints.expand(),
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: redBallColor),
                    child: Text("$num", style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.1)),
                  )
                else
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints.expand(),
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: editBallColor.withOpacity(0.5))),
                    child: Text("$num", style: const TextStyle(color: editBallColor, fontSize: 12, height: 1.1)),
                  ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTap: () => onSecondaryTap(index, ball: ticket.getRedBall(num), isRedBall: true),
        child: Container(
          constraints: BoxConstraints.tightFor(width: 20, height: 20),
          child: Stack(
            children: [
              if (isSelected)
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints.expand(),
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: specialColor ?? redBallColor),
                  child: Text("$num", style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.1)),
                ),
            ],
          ),
        ),
      );
    }
  }

  // 蓝球
  Widget buildBlueBall(int index, int num) {
    final ticket = widget.ticketList[index];

    bool isSelected = ticket.isContainBlueBall(num); // 选中
    bool isEdit = widget.editTicketList.contains(ticket); // 编辑状态

    Color? specialColor;

    Color? customColor = ticket.getBlueBallColor(num);
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

    if (isEdit) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (isSelected) {
              ticket.removeBlueBall(num);
            } else {
              ticket.addBlueBall(num);
            }

            eventBus.fire(DataChangeEvent());
          },
          onSecondaryTapDown: onSecondaryTapDown,
          onSecondaryTap: () => onSecondaryTap(index),
          child: Container(
            constraints: BoxConstraints.tightFor(width: 20, height: 20),
            child: Stack(
              children: [
                if (isSelected)
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints.expand(),
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: blueBallColor),
                    child: Text("$num", style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.1)),
                  )
                else
                  Container(
                    alignment: Alignment.center,
                    constraints: BoxConstraints.expand(),
                    margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: editBallColor.withOpacity(0.5))),
                    child: Text("$num", style: const TextStyle(color: editBallColor, fontSize: 12, height: 1.1)),
                  ),
              ],
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: onSecondaryTapDown,
        onSecondaryTap: () => onSecondaryTap(index, ball: ticket.getBlueBall(num), isBlueBall: true),
        child: Container(
          constraints: BoxConstraints.tightFor(width: 20, height: 20),
          child: Stack(
            children: [
              if (isSelected)
                Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints.expand(),
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: specialColor ?? blueBallColor),
                  child: Text("$num", style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.1)),
                ),
            ],
          ),
        ),
      );
    }
  }

  PopupMenuEntry buildMenuItem(dynamic value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      height: 30,
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 20),
          SizedBox(width: 10),
          Text(text, style: TextStyle(color: Colors.black, fontSize: 12)),
        ],
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

  void onSecondaryTap(int index, {TicketBallEntity? ball, bool? isRedBall, bool? isBlueBall}) async {
    if (tapDownDetails != null) {
      final dx = tapDownDetails!.globalPosition.dx;
      final dy = tapDownDetails!.globalPosition.dy;

      final result = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx, dy),
        items: [
          if (ball != null) ...[
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
                  buildColorItem(redColor.value, redColor, checked: redColor.value == ball.color),
                  SizedBox(width: 10),
                  buildColorItem(yellowColor.value, yellowColor, checked: yellowColor.value == ball.color),
                  SizedBox(width: 10),
                  buildColorItem(greenColor.value, greenColor, checked: greenColor.value == ball.color),
                  SizedBox(width: 10),
                  buildColorItem(blueColor.value, blueColor, checked: blueColor.value == ball.color),
                  SizedBox(width: 10),
                  buildColorItem(purpleColor.value, purpleColor, checked: purpleColor.value == ball.color),
                ],
              ),
            ),
          ],
          buildMenuItem('insertUp', Icons.arrow_upward, "向上插入一行"),
          buildMenuItem('insertDown', Icons.arrow_downward, "向上插入一行"),
          buildMenuItem('delete', Icons.delete, "删除"),
        ],
      );

      setState(() {
        tapDownDetails = null;
      });

      if (result == null) {
        return;
      }

      if (result == 'insertUp') {
        widget.ticketList.insert(index, TicketEntity());
      } else if (result == 'insertDown') {
        widget.ticketList.insert(index + 1, TicketEntity());
      } else if (result == 'delete') {
        final entity = widget.ticketList.removeAt(index);
        widget.editTicketList.remove(entity);
      } else if (result == 'defaultColor') {
        if (ball != null && isRedBall == true) {
          widget.ticketList[index].addRedBall(ball.num, color: null);
        } else if (ball != null && isBlueBall == true) {
          widget.ticketList[index].addBlueBall(ball.num, color: null);
        }
      } else {
        final color = int.tryParse(result.toString());
        if (ball != null && isRedBall == true) {
          widget.ticketList[index].addRedBall(ball.num, color: color);
        } else if (ball != null && isBlueBall == true) {
          widget.ticketList[index].addBlueBall(ball.num, color: color);
        }
      }

      eventBus.fire(DataChangeEvent());
    }
  }
}
