import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_of_episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_state.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_line.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_lines.dart';

import '../listen_line/listen_line.dart';

class EpisodeStudents extends Episode {
  List<StudentOfEpisodeFromServer>? students;
  EpisodeStudents(
      {required super.displayName,
      required super.epsdType,
      required super.id,
      required super.name,
      required this.students});
  EpisodeStudents.fromJson(Map<String, dynamic> json)
      : students = (json['students'] as List)
            .map((e) => StudentOfEpisodeFromServer.fromJson(e, json['id']))
            .toList(),
        super.fromServerJson(json);
}

class StudentOfEpisodeFromServer extends StudentOfEpisode {
  PlanLinesStudent studentWorks;
  bool isHifz, isSmallReview, isBigReview, isTilawa;
  List<StudentState> studentAttendances;
  StudentOfEpisodeFromServer(
      {required super.age,
      required super.id,
      required super.episodeId,
      required super.name,
      required super.gender,
      required super.stateDate,
      required super.address,
      required super.country,
      required super.phone,
      required super.state,
      required this.studentWorks,
      required this.isHifz,
      required this.isSmallReview,
      required this.isBigReview,
      required this.isTilawa,
      required this.studentAttendances});

  StudentOfEpisodeFromServer.fromJson(Map<String, dynamic> json, int episodeId)
      : isHifz = json['is_hifz'],
        isSmallReview = json['is_small_review'],
        isBigReview = json['is_big_review'],
        isTilawa = json['is_tilawa'],
        studentAttendances = (json['student_attendances'] as List)
            .map((e) => StudentState.fromServerJson(e, json['id'], episodeId))
            .toList(),
        studentWorks =
            PlanLinesStudent.fromJson(json['student_works'], json['id']),
        super.fromServer(json);
}

class PlanLinesStudent {
  List<ListenLine> planListen;
  List<ListenLine> planReviewSmall;
  List<ListenLine> planReviewBig;
  List<ListenLine> planTlawa;
  PlanLinesStudent(
      {required this.planListen,
      required this.planReviewSmall,
      required this.planReviewBig,
      required this.planTlawa});
  PlanLinesStudent.fromJson(Map<String, dynamic> json, int studentId)
      : planListen = (json['plan_listen'] as List)
            .map((e) => ListenLine.fromJsonServer(e, studentId))
            .toList(),
        planReviewSmall = (json['plan_review_small'] as List)
            .map((e) => ListenLine.fromJsonServer(e, studentId))
            .toList(),
        planReviewBig = (json['plan_review_big'] as List)
            .map((e) => ListenLine.fromJsonServer(e, studentId))
            .toList(),
        planTlawa = (json['plan_tlawa'] as List)
            .map((e) => ListenLine.fromJsonServer(e, studentId))
            .toList();
}
