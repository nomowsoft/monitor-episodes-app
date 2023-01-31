import 'package:monitor_episodes/model/core/episodes/student_state.dart';

import '../listen_line/listen_line.dart';

class CheckStudentsWorkResponce {
  List<StudentState> studentState;
  List<ListenLine> listenLine;
  bool update;
  CheckStudentsWorkResponce({
    required this.listenLine,
    required this.studentState,
    required this.update,
  });

  CheckStudentsWorkResponce.fromJson(
      Map<String, dynamic> json, int episodeId, int studentId)
      : studentState = ((json['new_attendances'] ?? []) as List)
            .map((e) => StudentState.fromJsonServer(e,
                episId: episodeId, stuId: studentId))
            .toList(),
        listenLine = ((json['new_works'] ?? []) as List)
            .map((e) => ListenLine.fromJsonServer(e, studentId))
            .toList(),
        update = json['update'];
}
