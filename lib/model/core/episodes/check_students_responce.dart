// ignore_for_file: public_member_api_docs, sort_constructors_first

class CheckStudentsResponce {
  List<int> deletedStudentsIds;
  List<NewStudent> newStudents;
  bool update;
  CheckStudentsResponce({
    required this.deletedStudentsIds,
    required this.newStudents,
    required this.update,
  });

  CheckStudentsResponce.fromJson(Map<String, dynamic> json)
      : deletedStudentsIds =
            List<int>.from((json['deleted_students'] ?? []) as List),
        newStudents = _getNewStudent(((json['new_students'] ?? []) as List)),
        update = json['update'];
}

List<NewStudent> _getNewStudent(List list) {
  List<NewStudent> newStudents = [];
  for (var element in list) {
    if (element.runtimeType != int) {
      newStudents.add(NewStudent.fromJson(element));
    }
  }
  return newStudents;
}

class NewStudent {
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
  });

  factory NewStudent.fromJson(json) {
    return NewStudent(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      isHifz: json['is_hifz'],
      isSmallReview: json['is_small_review'],
      isBigReview: json['is_big_review'],
      isTilawa: json['is_tilawa'],
    );
  }
}
