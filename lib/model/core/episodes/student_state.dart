import 'package:intl/intl.dart';

class StudentState {
  int studentId, episodeId;
  String state, date;

  StudentState({
    required this.studentId,
    required this.episodeId,
    required this.state,
    required this.date,
  });

  StudentState.fromJson(Map<String, dynamic> json)
      : studentId = json['student_id'] ?? 0,
        episodeId = json['episode_id'] ?? 0,
        date = json['date'] ?? '',
        state = json['state'] ?? '';

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "episode_id": episodeId,
        "date": date,
        "state": state
      };

  Map<String, dynamic> toJsonServer() => {
        'id': studentId,
        'status': state,
        'date_presence':  DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };
}
