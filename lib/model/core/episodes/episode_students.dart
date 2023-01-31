import 'package:monitor_episodes/model/core/episodes/episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_of_episode.dart';
import 'package:monitor_episodes/model/core/episodes/student_state.dart';
import 'package:monitor_episodes/model/core/plan_lines/plan_lines.dart';

class EpisodeStudents extends Episode {
  List<StudentOfEpisode>? students;
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
        super.fromJson(json);
}


 
class StudentOfEpisodeFromServer extends StudentOfEpisode{
    PlanLines studentWorks;
    List<StudentState> studentAttendances;
    StudentOfEpisodeFromServer(
      {
      required super.age,
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
      required this.studentAttendances});

        StudentOfEpisodeFromServer.fromJson(Map<String, dynamic> json,int episodeId)
      : studentAttendances = (json['student_attendances'] as List)
            .map((e) => StudentState.fromServerJson(e,json['id'],episodeId))
            .toList(),
        studentWorks =  PlanLines.fromServerJson(json['student_works'], episodeId, json['id']),    
        super.fromServer(json);


} 
