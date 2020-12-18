class MessageModel {
  final String message;
  final DateTime time;
  final String sentBy;

  MessageModel({
    this.message,
    this.time,
    this.sentBy,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        message: json["message"],
        time: DateTime.fromMillisecondsSinceEpoch(json["time"]),
        sentBy: json["sentBy"],
      );
}
