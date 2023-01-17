import 'dart:convert' as convert;
import 'package:monitor_episodes/model/core/plan_lines/plan_line.dart';

class PlanLines {
  int? episodeId, studentId;
  PlanLine? listen, reviewbig, reviewsmall, tlawa;

  PlanLines(
      {this.listen,
      this.reviewbig,
      this.reviewsmall,
      this.tlawa,
      this.episodeId,
      this.studentId});

  PlanLines.fromJson(
      Map<String, dynamic> json, int newEpisodeId, int newStudentId)
      : listen = (json['listen'] as Map).isNotEmpty
            ? PlanLine.fromJson(json['listen'])
            : null,
        reviewbig = (json['reviewbig'] as Map).isNotEmpty
            ? PlanLine.fromJson(json['reviewbig'])
            : null,
        reviewsmall = (json['reviewsmall'] as Map).isNotEmpty
            ? PlanLine.fromJson(json['reviewsmall'])
            : null,
        tlawa = (json['tlawa'] as Map).isNotEmpty
            ? PlanLine.fromJson(json['tlawa'])
            : null,
        episodeId = newEpisodeId,
        studentId = newStudentId;

  PlanLines.fromJsonLocal(Map<String, dynamic> json)
      : listen = json['listen']  != null
            ? PlanLines().getPlanLineFromString(json['listen'].toString())
            : null,
        reviewbig = json['reviewbig'] != null
            ? PlanLines().getPlanLineFromString(json['reviewbig'].toString())
            : null,
        reviewsmall = json['reviewsmall'] != null
            ? PlanLines().getPlanLineFromString(json['reviewsmall'].toString())
            : null,
        tlawa = json['tlawa'] != null
            ? PlanLines().getPlanLineFromString(json['tlawa'].toString())
            : null,
        episodeId = json['episodeId'],
        studentId = json['studentId'];

  Map<String, dynamic> toJson() => {
        "listen":listen !=null ? getPlanLineAsString(listen!):null,
        "reviewbig":reviewbig !=null ? getPlanLineAsString(reviewbig!):null,  
        "reviewsmall":reviewsmall !=null ? getPlanLineAsString(reviewsmall!):null, 
        "tlawa": tlawa !=null ? getPlanLineAsString(tlawa!):null,
        "episodeId": episodeId,
        "studentId": studentId,
      };

   PlanLine? getPlanLineFromString(String planLine) {
    var data = planLine.isNotEmpty ? convert.jsonDecode(planLine) : null;
    return PlanLine.fromJson(data);
  }

  String  getPlanLineAsString(PlanLine planLine) {
    final listJson = planLine.toJson();
    return convert.jsonEncode(listJson);
  }
  
}
