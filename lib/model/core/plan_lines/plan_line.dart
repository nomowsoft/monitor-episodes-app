
import 'package:monitor_episodes/model/core/plan_lines/mistakes_plan_line.dart';

class PlanLine {
  String fromSuraName,toSuraName;
  int fromAya,toAya,mistake;
  Mistakes? mistakes;

  PlanLine({ required this.fromSuraName,required this.fromAya,required this.toAya,required this.toSuraName,required this.mistake,this.mistakes});
  PlanLine.fromDefault({ this.fromSuraName = 'الفاتحة', this.fromAya = 1, this.toAya = 0, this.toSuraName = '',this.mistake = 0,});

  PlanLine.fromJson(Map<String, dynamic> json):
    fromSuraName = json['from_sura_name'] ?? '',
    toSuraName = json['to_sura_name'] ?? '',
    fromAya = json['from_aya'] ?? 0,
    toAya = json['to_aya'] ?? 0,
    mistake = json['mistake'] ?? 0;
 
  
  Map<String, dynamic> toJson() => {
        "from_sura_name": fromSuraName,
        "to_sura_name": toSuraName,
        "from_aya": fromAya,
        "to_aya": toAya,
        "mistake": mistake,
      };
}

