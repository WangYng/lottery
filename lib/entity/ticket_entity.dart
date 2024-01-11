import 'dart:ui';

import 'package:lottery/generated/json/base/json_convert_content.dart';
import 'package:lottery/generated/json/base/json_field.dart';

class TicketEntity with JsonConvert<TicketEntity> {
  @JSONField(name: "red_ball")
  List<TicketBallEntity> redBallList = [];

  @JSONField(name: "blue_ball")
  List<TicketBallEntity> blueBallList = [];

  @JSONField(serialize: false, deserialize: false)
  int? _moneyOne;

  @JSONField(serialize: false, deserialize: false)
  int? _moneyTwo;

  // 双色球
  int moneyOne() {
    if (_moneyOne == null) {
      calculateMoneyOne();
      return _moneyOne ?? 0;
    } else {
      return _moneyOne!;
    }
  }

  // 乐透
  int moneyTwo() {
    if (_moneyTwo == null) {
      calculateMoneyTwo();
      return _moneyTwo ?? 0;
    } else {
      return _moneyTwo!;
    }
  }

  TicketEntity();

  bool isContainRedBall(int num) {
    return redBallList.where((e) => e.num == num).isNotEmpty;
  }

  bool isContainBlueBall(int num) {
    return blueBallList.where((e) => e.num == num).isNotEmpty;
  }

  void removeRedBall(int num) {
    redBallList.removeWhere((e) => e.num == num);
    calculateMoney();
  }

  void addRedBall(int num, {int? color}) {
    redBallList.removeWhere((e) => e.num == num);

    final ball = TicketBallEntity();
    ball.num = num;
    ball.color = color;

    redBallList.add(ball);
    calculateMoney();
  }

  TicketBallEntity? getRedBall(int num) {
    final ballList = redBallList.where((e) => e.num == num);
    if (ballList.isNotEmpty) {
      return ballList.first;
    }
    return null;
  }

  Color? getRedBallColor(int num) {
    final ballList = redBallList.where((e) => e.num == num);
    if (ballList.isNotEmpty) {
      final color = ballList.first.color;
      if (color != null) {
        return Color(color);
      }
    }
    return null;
  }

  void removeBlueBall(int num) {
    blueBallList.removeWhere((e) => e.num == num);
    calculateMoney();
  }

  void addBlueBall(int num, {int? color}) {
    blueBallList.removeWhere((e) => e.num == num);

    final ball = TicketBallEntity();
    ball.num = num;
    ball.color = color;

    blueBallList.add(ball);
    calculateMoney();
  }

  TicketBallEntity? getBlueBall(int num) {
    final ballList = blueBallList.where((e) => e.num == num);
    if (ballList.isNotEmpty) {
      return ballList.first;
    }
    return null;
  }

  Color? getBlueBallColor(int num) {
    final ballList = blueBallList.where((e) => e.num == num);
    if (ballList.isNotEmpty) {
      final color = ballList.first.color;
      if (color != null) {
        return Color(color);
      }
    }
    return null;
  }

  void calculateMoney() {
    calculateMoneyOne();
    calculateMoneyTwo();
  }

  void calculateMoneyOne() {
    if (redBallList.length >= 6 && blueBallList.isNotEmpty) {
      int redCount = redBallList.length;
      redCount = (redCount * (redCount - 1) * (redCount - 2) * (redCount - 3) * (redCount - 4) * (redCount - 5)) ~/ (6 * 5 * 4 * 3 * 2 * 1);

      int blueCount = blueBallList.length;
      _moneyOne = redCount * blueCount * 2;
    } else {
      _moneyOne = 0;
    }
  }

  void calculateMoneyTwo() {
    if (redBallList.length >= 5 && blueBallList.length >= 2) {
      int redCount = redBallList.length;
      redCount = (redCount * (redCount - 1) * (redCount - 2) * (redCount - 3) * (redCount - 4)) ~/ (5 * 4 * 3 * 2 * 1);

      int blueCount = blueBallList.length;
      blueCount = (blueCount * (blueCount - 1)) ~/ (2 * 1);

      _moneyTwo = redCount * blueCount * 2;
    } else {
      _moneyTwo = 0;
    }
  }
}

class TicketBallEntity with JsonConvert<TicketBallEntity> {
  late int num;
  int? color;
}
