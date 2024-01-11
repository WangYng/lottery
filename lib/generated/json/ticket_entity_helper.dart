import 'package:lottery/entity/ticket_entity.dart';

ticketEntityFromJson(TicketEntity data, Map<String, dynamic> json) {
	if (json['red_ball'] != null) {
		data.redBallList = (json['red_ball'] as List).map((v) => TicketBallEntity().fromJson(v)).toList();
	}
	if (json['blue_ball'] != null) {
		data.blueBallList = (json['blue_ball'] as List).map((v) => TicketBallEntity().fromJson(v)).toList();
	}
	return data;
}

Map<String, dynamic> ticketEntityToJson(TicketEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['red_ball'] =  entity.redBallList.map((v) => v.toJson()).toList();
	data['blue_ball'] =  entity.blueBallList.map((v) => v.toJson()).toList();
	return data;
}

ticketBallEntityFromJson(TicketBallEntity data, Map<String, dynamic> json) {
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

Map<String, dynamic> ticketBallEntityToJson(TicketBallEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['num'] = entity.num;
	data['color'] = entity.color;
	return data;
}