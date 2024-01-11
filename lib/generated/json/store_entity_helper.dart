import 'package:lottery/entity/store_entity.dart';
import 'package:lottery/entity/ticket_entity.dart';

storeEntityFromJson(StoreEntity data, Map<String, dynamic> json) {
	if (json['double_color_ball'] != null) {
		data.doubleColorBall = LotteryTableEntity().fromJson(json['double_color_ball']);
	}
	if (json['lotto'] != null) {
		data.lotto = LotteryTableEntity().fromJson(json['lotto']);
	}
	return data;
}

Map<String, dynamic> storeEntityToJson(StoreEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['double_color_ball'] = entity.doubleColorBall.toJson();
	data['lotto'] = entity.lotto.toJson();
	return data;
}

lotteryTableEntityFromJson(LotteryTableEntity data, Map<String, dynamic> json) {
	if (json['table'] != null) {
		data.table = (json['table'] as List).map((v) => TicketEntity().fromJson(v)).toList();
	}
	if (json['statistic'] != null) {
		data.statistic = (json['statistic'] as List).map((v) => StatisticColorEntity().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> lotteryTableEntityToJson(LotteryTableEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['table'] =  entity.table.map((v) => v.toJson()).toList();
	data['statistic'] =  entity.statistic.map((v) => v.toJson()).toList();
	return data;
}

statisticColorEntityFromJson(StatisticColorEntity data, Map<String, dynamic> json) {
	if (json['type'] != null) {
		data.type = json['type'] is String
				? int.tryParse(json['type'])
				: json['type'].toInt();
	}
	if (json['num'] != null) {
		data.num = json['num'] is String
				? int.tryParse(json['num'])
				: json['num'].toInt();
	}
	if (json['color'] != null) {
		data.color = json['color'] is String
				? int.tryParse(json['color'])
				: json['color'].toInt();
	}
	return data;
}

Map<String, dynamic> statisticColorEntityToJson(StatisticColorEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['type'] = entity.type;
	data['num'] = entity.num;
	data['color'] = entity.color;
	return data;
}