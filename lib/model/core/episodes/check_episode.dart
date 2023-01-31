// class CheckEpisode {
//   String? jsonrpc;
//   int? id;
//   Result? result;

//   CheckEpisode({this.jsonrpc, this.id, this.result});

//   CheckEpisode.fromJson(Map<String, dynamic> json) {
//     jsonrpc = json['jsonrpc'];
//     id = json['id'] is int ? json['id'] : 0;
//     result =
//         json['result'] != null ? new Result.fromJson(json['result']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['jsonrpc'] = jsonrpc;
//     data['id'] = id;
//     if (result != null) {
//       data['result'] = result!.toJson();
//     }
//     return data;
//   }
// }

// class Result {
//   bool? success;
//   Results? results;

//   Result({this.success, this.results});

//   Result.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     results = json['result'] != null ? Results.fromJson(json['result']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data['success'] = success;
//     if (results != null) {
//       data['result'] = results!.toJson();
//     }
//     return data;
//   }
// }

class CheckEpisode {
  bool? update;
  List<int>? deletedHalaqat;
  List<NewHalaqat>? newHalaqat;

  CheckEpisode({this.update, this.deletedHalaqat, this.newHalaqat});

  CheckEpisode.fromJson(Map<String, dynamic> json) {
    update = json['update'];
    deletedHalaqat = json['deleted_halaqat'].cast<int>();
    if (json['new_halaqat'] != null) {
      newHalaqat = <NewHalaqat>[];
      json['new_halaqat'].forEach((v) {
        newHalaqat!.add(NewHalaqat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['update'] = update;
    data['deleted_halaqat'] = deletedHalaqat;
    if (newHalaqat != null) {
      data['new_halaqat'] = newHalaqat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewHalaqat {
  int? id;
  String? name;
  String? typeEpisode;
  List<Students>? students;

  NewHalaqat({this.id, this.name, this.typeEpisode, this.students});

  NewHalaqat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    typeEpisode = json['type_episode'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['type_episode'] = typeEpisode;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  int? id;
  String? name;
  bool? isHifz;
  bool? isSmallReview;
  bool? isBigReview;
  bool? isTilawa;
  String? state;

  Students(
      {this.id,
      this.name,
      this.isHifz,
      this.isSmallReview,
      this.isBigReview,
      this.isTilawa,
      this.state});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isHifz = json['is_hifz'];
    isSmallReview = json['is_small_review'];
    isBigReview = json['is_big_review'];
    isTilawa = json['is_tilawa'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['is_hifz'] = isHifz;
    data['is_small_review'] = isSmallReview;
    data['is_big_review'] = isBigReview;
    data['is_tilawa'] = isTilawa;
    data['state'] = state;
    return data;
  }
}
