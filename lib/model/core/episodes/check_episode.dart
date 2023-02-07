import 'episode.dart';

class CheckEpisode {
  bool? update;
  List<int>? deletedHalaqat;
  List<NewHalaqat>? newHalaqat;

  CheckEpisode({this.update, this.deletedHalaqat, this.newHalaqat});

  CheckEpisode.fromJson(Map<String, dynamic> json) {
    update = json['update'];
    if (json['deleted_halaqat'] != null) {
      deletedHalaqat = <int>[];
      json['deleted_halaqat'].forEach((v) {
        deletedHalaqat!.add(v);
      });
    }
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
    if (deletedHalaqat != null) {
      data['deleted_halaqat'] = deletedHalaqat!.map((v) => v).toList();
    }
    if (newHalaqat != null) {
      data['new_halaqat'] = newHalaqat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewHalaqat extends Episode {
  List<Students>? students;

  NewHalaqat(
      {required super.displayName,
      required super.id,
      required super.name,
      required super.epsdType,
      required this.students});

  NewHalaqat.fromJson(Map<String, dynamic> json)
      : students = (json['students'] as List)
            .map((e) => Students.fromJson(e))
            .toList(),
        super.fromServerJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['type_episode'] = epsdType;
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
  List<NewWorks>? newWorks;
  List<NewAttendances>? newAttendances;
  String? state;

  Students(
      {this.id,
      this.name,
      this.isHifz,
      this.isSmallReview,
      this.isBigReview,
      this.isTilawa,
      this.newWorks,
      this.newAttendances,
      this.state});

  Students.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isHifz = json['is_hifz'];
    isSmallReview = json['is_small_review'];
    isBigReview = json['is_big_review'];
    isTilawa = json['is_tilawa'];
    if (json['new_works'] != null) {
      newWorks = <NewWorks>[];
      json['new_works'].forEach((v) {
        newWorks!.add(NewWorks.fromJson(v));
      });
    }
    if (json['new_attendances'] != null) {
      newAttendances = <NewAttendances>[];
      json['new_attendances'].forEach((v) {
        newAttendances!.add(NewAttendances.fromJson(v));
      });
    }
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
    if (newWorks != null) {
      data['new_works'] = newWorks!.map((v) => v.toJson()).toList();
    }
    if (newAttendances != null) {
      data['new_attendances'] = newAttendances!.map((v) => v.toJson()).toList();
    }
    data['state'] = state;
    return data;
  }
}

class NewWorks {
  int? id;
  String? typeWork;
  int? fromSuraId;
  int? fromAyaId;
  int? toSuraId;
  int? toAyaId;
  String? dateListen;
  int? nbrErrorHifz;
  int? nbrErrorTajwed;

  NewWorks(
      {this.id,
      this.typeWork,
      this.fromSuraId,
      this.fromAyaId,
      this.toSuraId,
      this.toAyaId,
      this.dateListen,
      this.nbrErrorHifz,
      this.nbrErrorTajwed});

  NewWorks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeWork = json['type_work'];
    fromSuraId = json['from_sura_id'];
    fromAyaId = json['from_aya_id'];
    toSuraId = json['to_sura_id'];
    toAyaId = json['to_aya_id'];
    dateListen = json['date_listen'];
    nbrErrorHifz = json['nbr_error_hifz'];
    nbrErrorTajwed = json['nbr_error_tajwed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['type_work'] = typeWork;
    data['from_sura_id'] = fromSuraId;
    data['from_aya_id'] = fromAyaId;
    data['to_sura_id'] = toSuraId;
    data['to_aya_id'] = toAyaId;
    data['date_listen'] = dateListen;
    data['nbr_error_hifz'] = nbrErrorHifz;
    data['nbr_error_tajwed'] = nbrErrorTajwed;
    return data;
  }
}

class NewAttendances {
  int? id;
  String? datePresence;
  String? status;

  NewAttendances({this.id, this.datePresence, this.status});

  NewAttendances.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    datePresence = json['date_presence'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['date_presence'] = datePresence;
    data['status'] = status;
    return data;
  }
}
