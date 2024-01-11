import 'package:lottery/entity/ticket_entity.dart';
import 'package:lottery/generated/json/base/json_convert_content.dart';
import 'package:lottery/generated/json/base/json_field.dart';

class StoreEntity with JsonConvert<StoreEntity> {
  @JSONField(name: "double_color_ball")
  late LotteryTableEntity doubleColorBall;

  @JSONField(name: "lotto")
  late LotteryTableEntity lotto;
}

class LotteryTableEntity with JsonConvert<LotteryTableEntity> {
  List<TicketEntity> table = [];
  List<StatisticColorEntity> statistic = [];
}

class StatisticColorEntity with JsonConvert<StatisticColorEntity> {
  late int type;
  late int num;
  late int color;
}
