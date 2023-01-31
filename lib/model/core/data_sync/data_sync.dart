class DataSync {
  String? name;
  int? id;
  String? episodeType;
  List<Students>? students;

  DataSync({this.name, this.id, this.episodeType, this.students});

  DataSync.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    episodeType = json['episode_type'];
    if (json['students'] != null) {
      students = <Students>[];
      json['students'].forEach((v) {
        students!.add(Students.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['id'] = id;
    data['episode_type'] = episodeType;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Students {
  String? name;
  int? id;
  String? gender;
  bool? isHifz;
  bool? isSmallReview;
  bool? isBigReview;
  bool? isTilawa;
  StudentWorks? studentWorks;
  List<StudentAttendances>? studentAttendances;

  Students(
      {this.name,
      this.id,
      this.gender,
      this.isHifz,
      this.isSmallReview,
      this.isBigReview,
      this.isTilawa,
      this.studentWorks,
      this.studentAttendances});

  Students.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    gender = json['gender'];
    isHifz = json['is_hifz'];
    isSmallReview = json['is_small_review'];
    isBigReview = json['is_big_review'];
    isTilawa = json['is_tilawa'];
    studentWorks = json['student_works'] != null
        ? StudentWorks.fromJson(json['student_works'])
        : null;
    if (json['student_attendances'] != null) {
      studentAttendances = <StudentAttendances>[];
      json['student_attendances'].forEach((v) {
        studentAttendances!.add(StudentAttendances.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['id'] = id;
    data['gender'] = gender;
    data['is_hifz'] = isHifz;
    data['is_small_review'] = isSmallReview;
    data['is_big_review'] = isBigReview;
    data['is_tilawa'] = isTilawa;
    if (studentWorks != null) {
      data['student_works'] = studentWorks!.toJson();
    }
    if (studentAttendances != null) {
      data['student_attendances'] =
          studentAttendances!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentWorks {
  List<PlanListen>? planListen;
  List<PlanReviewSmall>? planReviewSmall;
  List<PlanReviewBig>? planReviewBig;
  List<PlanTlawa>? planTlawa;

  StudentWorks(
      {this.planListen,
      this.planReviewSmall,
      this.planReviewBig,
      this.planTlawa});

  StudentWorks.fromJson(Map<String, dynamic> json) {
    if (json['plan_listen'] != null) {
      planListen = <PlanListen>[];
      json['plan_listen'].forEach((v) {
        planListen!.add(PlanListen.fromJson(v));
      });
    }
    if (json['plan_review_small'] != null) {
      planReviewSmall = <PlanReviewSmall>[];
      json['plan_review_small'].forEach((v) {
        planReviewSmall!.add(PlanReviewSmall.fromJson(v));
      });
    }
    if (json['plan_review_big'] != null) {
      planReviewBig = <PlanReviewBig>[];
      json['plan_review_big'].forEach((v) {
        planReviewBig!.add(PlanReviewBig.fromJson(v));
      });
    }
    if (json['plan_tlawa'] != null) {
      planTlawa = <PlanTlawa>[];
      json['plan_tlawa'].forEach((v) {
        planTlawa!.add(PlanTlawa.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (planListen != null) {
      data['plan_listen'] = planListen!.map((v) => v.toJson()).toList();
    }
    if (planReviewSmall != null) {
      data['plan_review_small'] =
          planReviewSmall!.map((v) => v.toJson()).toList();
    }
    if (planReviewBig != null) {
      data['plan_review_big'] = planReviewBig!.map((v) => v.toJson()).toList();
    }
    if (planTlawa != null) {
      data['plan_tlawa'] = planTlawa!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanListen {
  int? id;
  String? typeWork;
  int? fromSuraId;
  int? fromAyaId;
  int? toSuraId;
  int? toAyaId;
  int? nbrErrorHifz;
  int? nbrErrorTajwed;

  PlanListen(
      {this.id,
      this.typeWork,
      this.fromSuraId,
      this.fromAyaId,
      this.toSuraId,
      this.toAyaId,
      this.nbrErrorHifz,
      this.nbrErrorTajwed});

  PlanListen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeWork = json['type_work'];
    fromSuraId = json['from_sura_id'];
    fromAyaId = json['from_aya_id'];
    toSuraId = json['to_sura_id'];
    toAyaId = json['to_aya_id'];
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
    data['nbr_error_hifz'] = nbrErrorHifz;
    data['nbr_error_tajwed'] = nbrErrorTajwed;
    return data;
  }
}

class PlanReviewSmall {
  int? id;
  String? typeWork;
  int? fromSuraId;
  int? fromAyaId;
  int? toSuraId;
  int? toAyaId;
  int? nbrErrorHifz;
  int? nbrErrorTajwed;

  PlanReviewSmall(
      {this.id,
      this.typeWork,
      this.fromSuraId,
      this.fromAyaId,
      this.toSuraId,
      this.toAyaId,
      this.nbrErrorHifz,
      this.nbrErrorTajwed});

  PlanReviewSmall.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeWork = json['type_work'];
    fromSuraId = json['from_sura_id'];
    fromAyaId = json['from_aya_id'];
    toSuraId = json['to_sura_id'];
    toAyaId = json['to_aya_id'];
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
    data['nbr_error_hifz'] = nbrErrorHifz;
    data['nbr_error_tajwed'] = nbrErrorTajwed;
    return data;
  }
}

class PlanReviewBig {
  int? id;
  String? typeWork;
  int? fromSuraId;
  int? fromAyaId;
  int? toSuraId;
  int? toAyaId;
  int? nbrErrorHifz;
  int? nbrErrorTajwed;

  PlanReviewBig(
      {this.id,
      this.typeWork,
      this.fromSuraId,
      this.fromAyaId,
      this.toSuraId,
      this.toAyaId,
      this.nbrErrorHifz,
      this.nbrErrorTajwed});

  PlanReviewBig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeWork = json['type_work'];
    fromSuraId = json['from_sura_id'];
    fromAyaId = json['from_aya_id'];
    toSuraId = json['to_sura_id'];
    toAyaId = json['to_aya_id'];
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
    data['nbr_error_hifz'] = nbrErrorHifz;
    data['nbr_error_tajwed'] = nbrErrorTajwed;
    return data;
  }
}

class PlanTlawa {
  int? id;
  String? typeWork;
  int? fromSuraId;
  int? fromAyaId;
  int? toSuraId;
  int? toAyaId;
  int? nbrErrorHifz;
  int? nbrErrorTajwed;

  PlanTlawa(
      {this.id,
      this.typeWork,
      this.fromSuraId,
      this.fromAyaId,
      this.toSuraId,
      this.toAyaId,
      this.nbrErrorHifz,
      this.nbrErrorTajwed});

  PlanTlawa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeWork = json['type_work'];
    fromSuraId = json['from_sura_id'];
    fromAyaId = json['from_aya_id'];
    toSuraId = json['to_sura_id'];
    toAyaId = json['to_aya_id'];
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
    data['nbr_error_hifz'] = nbrErrorHifz;
    data['nbr_error_tajwed'] = nbrErrorTajwed;
    return data;
  }
}


class StudentAttendances {
  int? id;
  String? datePresence;
  String? status;

  StudentAttendances({this.id, this.datePresence, this.status});

  StudentAttendances.fromJson(Map<String, dynamic> json) {
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
