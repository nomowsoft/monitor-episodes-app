import 'package:intl/intl.dart';

class StudentState {
  int? id;
  int studentId, episodeId;
  String state, date;

  StudentState({
    required this.studentId,
    required this.episodeId,
    required this.state,
    required this.date,
  });

  StudentState.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        studentId = json['student_id'] ?? 0,
        episodeId = json['episode_id'] ?? 0,
        date = json['date'] ?? '',
        state = json['state'] ?? '';

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "episode_id": episodeId,
        "date": date,
        "state": state
      };

  Map<String, dynamic> toJsonServer() => {
        'id': id,
        'student_id': studentId,
        'status': state,
        'date_presence': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };

  StudentState.fromJsonServer(json, {required int episId, required int stuId})
      : id = json['id'],
        studentId = stuId,
        episodeId = episId,
        date = json['date_presence'],
        state = json['status'];
}
