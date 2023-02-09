// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:monitor_episodes/model/core/episodes/check_student_work_responce.dart';
import 'package:monitor_episodes/model/core/episodes/student_state.dart';
import 'package:monitor_episodes/model/core/listen_line/listen_line.dart';

class CheckStudentsResponce {
  List<int> deletedStudentsIds;
  List<NewStudent> newStudents;
  bool update;
  CheckStudentsResponce({
    required this.deletedStudentsIds,
    required this.newStudents,
    required this.update,
  });

  CheckStudentsResponce.fromJson(Map<String, dynamic> json, int epiId)
      : deletedStudentsIds =
            List<int>.from((json['deleted_students'] ?? []) as List),
        newStudents = _getNewStudent(((json['new_students'] ?? []) as List),epiId),
        update = json['update'];
}

List<NewStudent> _getNewStudent(List list,int epiId) {
  List<NewStudent> newStudents = [];
  for (var element in list) {
    newStudents.add(NewStudent.fromJson(element,epiId));
  }
  return newStudents;
}

class NewStudent extends CheckStudentsWorkResponce{
  int id;
  String name;
  String state;
  bool isHifz, isSmallReview, isBigReview, isTilawa;
  NewStudent({
    required this.id,
    required this.name,
    required this.state,
    required this.isHifz,
    required this.isSmallReview,
    required this.isBigReview,
    required this.isTilawa,
    required super.listenLine,
    required super.studentState,
    required super.update,

  });

  factory NewStudent.fromJson(json, int epiId) {
    return NewStudent(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      isHifz: json['is_hifz'],
      isSmallReview: json['is_small_review'],
      isBigReview: json['is_big_review'],
      isTilawa: json['is_tilawa'],
      listenLine: ((json['new_works']?? []) as List).map((e) => ListenLine.fromJsonServer(e, 0)).toList(),
      studentState: ((json['new_attendances']?? [] )as List).map((e) => StudentState.fromJsonServer(e, episId: epiId, stuId: 0)).toList(),
      update: null,
    );
  }
}
