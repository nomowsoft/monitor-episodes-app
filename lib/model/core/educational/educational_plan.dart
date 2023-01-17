import 'dart:convert' as convert;

import 'package:monitor_episodes/model/core/educational/educational.dart';

class EducationalPlan {
  late List<Educational> planListen, planReviewbig, planReviewSmall, planTlawa;
  int? episodeId, studentId;
  EducationalPlan({
    this.planListen = const [],
    this.planReviewbig = const [],
    this.planReviewSmall = const [],
    this.planTlawa = const [],
    this.episodeId,
    this.studentId
  });

  EducationalPlan.fromJson(Map<String, dynamic> json,int newEpisodeId, int newStudentId)
      : planListen = (json['plan_listen'] as List)
            .map((e) => Educational.fromJson(e))
            .toList(),
        planReviewbig = (json['plan_review_big'] as List)
            .map((e) => Educational.fromJson(e))
            .toList(),
        planReviewSmall = (json['plan_review_small'] as List)
            .map((e) => Educational.fromJson(e))
            .toList(),
        planTlawa = (json['plan_tlawa'] as List)
            .map((e) => Educational.fromJson(e))
            .toList(),
        episodeId =  newEpisodeId ,
        studentId = newStudentId ;

  EducationalPlan.fromJsonLocal(Map<String, dynamic> json)
      : planListen = json['plan_listen'] != null
            ? EducationalPlan()
                .getEducationalFromString(json['plan_listen'].toString())
            : [],
        planReviewbig = json['plan_review_big'] != null
            ? EducationalPlan()
                .getEducationalFromString(json['plan_review_big'].toString())
            : [],
        planReviewSmall = json['plan_review_small'] != null
            ? EducationalPlan()
                .getEducationalFromString(json['plan_review_small'].toString())
            : [],
        planTlawa = json['plan_tlawa'] != null
            ? EducationalPlan()
                .getEducationalFromString(json['plan_tlawa'].toString())
            : [],
        episodeId = json['episodeId'],
        studentId = json['studentId'];

  Map<String, dynamic> toJson() => {
        "plan_listen": getEducationalPlanAsString(planListen),
        "plan_review_big": getEducationalPlanAsString(planReviewbig),
        "plan_review_small": getEducationalPlanAsString(planReviewSmall),
        "plan_tlawa": getEducationalPlanAsString(planTlawa),
        "episodeId": episodeId,
        "studentId": studentId,
      };

  String getEducationalPlanAsString(List<Educational> educationalPlans) {
    final listJson = educationalPlans.map((e) => e.toJson()).toList();
    return convert.jsonEncode(listJson);
  }

  List<Educational> getEducationalFromString(String educationalPlans) {
    var data =
        educationalPlans.isNotEmpty ? convert.jsonDecode(educationalPlans) : [];
    return (data as List).map((e) => Educational.fromJson(e)).toList();
  }
}

