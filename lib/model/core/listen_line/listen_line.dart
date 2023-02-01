import 'package:get/get.dart';
import 'package:monitor_episodes/model/offline_quran/surahs.dart';
import 'package:monitor_episodes/model/offline_quran/verses.dart';
import 'package:monitor_episodes/model/services/listen_line_service.dart';

class ListenLine {
  int? id;
  String typeFollow, actualDate;
  int studentId,
      fromSuraId,
      toSuraId,
      fromAya,
      toAya,
      totalMstkQty,
      totalMstkRead;

  ListenLine({
    this.id,
    required this.studentId,
    required this.fromSuraId,
    required this.fromAya,
    required this.toAya,
    required this.toSuraId,
    required this.actualDate,
    required this.typeFollow,
    required this.totalMstkQty,
    required this.totalMstkRead,
  });
  ListenLine.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        studentId = json['student_id'] ?? 0,
        typeFollow = json['type_follow'] ?? '',
        actualDate = json['actual_date'] ?? '',
        fromSuraId = json['from_surah'] ?? 0,
        fromAya = json['from_aya'] ?? 0,
        toSuraId = json['to_surah'] ?? 0,
        toAya = json['to_aya'] ?? 0,
        totalMstkQty = json['total_mstk_qty'] ?? 0,
        totalMstkRead = json['total_mstk_read'] ?? 0;

  ListenLine.fromJsonServer(
    Map<String, dynamic> json,
    int stuId,
  )   : id = json['id'],
        studentId = stuId,
        typeFollow = getTypeWorkserver(json['type_work']),
        fromSuraId = json['from_sura_id'],
        toSuraId = json['to_sura_id'],
        fromAya = getAyaFrom(json['from_aya_id']),
        toAya = getAyaTo(json['to_aya_id']),
        actualDate = json['date_listen'],
        totalMstkQty = json['nbr_error_hifz'],
        totalMstkRead = json['nbr_error_tajwed'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "type_follow": typeFollow,
        "actual_date": actualDate,
        "from_surah": fromSuraId,
        "from_aya": fromAya,
        "to_surah": toSuraId,
        "to_aya": toAya,
        "total_mstk_qty": totalMstkQty,
        "total_mstk_read": totalMstkRead
      };

  Future<Map<String, dynamic>> toJsonServer() async {
    return {
      'id': await getListenLineId(),
      'student_id': studentId.toString(),
      'date_listen': actualDate,
      'type_work': getTypeWork(typeFollow),
      'from_sura': fromSuraId,
      'to_sura': toSuraId,
      'from_aya': getfromAyaId(),
      'to_aya': getToAyaId(),
      'nbr_error_hifz': totalMstkQty,
      'nbr_error_tajwed': totalMstkRead
    };
  }

  Future<String> getListenLineId() async {
    var result = await ListenLineService().getLastListenLinesLocal();
    return result!.id.toString();
  }

  getTypeWork(String typeFollow) {
    switch (typeFollow) {
      case 'listen':
        return 'hifz';
      case 'reviewbig':
        return 'mourajaa_g';
      case 'reviewsmall':
        return 'mourajaa_s';
      case 'tlawa':
        return 'tilawa';
      default:
    }
  }

  getfromAyaId() {
    for (var element in verses) {
      if (element['surah_id'] == fromSuraId.toString() &&
          element['original_surah_order'] == fromAya) {
        return int.parse(element['id']);
      }
    }
  }

  getToAyaId() {
    for (var element in verses) {
      if (element['surah_id'] == toSuraId.toString() &&
          element['original_surah_order'] == toAya) {
        return int.parse(element['id']);
      }
    }
  }

}

getSuraName(int id) {
  for (var element in surahs) {
    if (element['id'] == id.toString()) {
      return element['name'];
    }
  }
}

getAyaFrom(int ayaId) {
  for (var element in verses) {
    if (element['id'] == ayaId.toString()) {
      return element['original_surah_order'];
    }
  }
}

getAyaTo(int ayaId) {
  for (var element in verses) {
    if (element['id'] == ayaId.toString()) {
      return element['original_surah_order'];
    }
  }
}

getTypeWorkserver(String typeFollow) {
  switch (typeFollow) {
    case 'hifz':
      return 'listen';
    case 'mourajaa_g':
      return 'reviewbig';
    case 'reviewbig':
      return 'reviewsmall';
    case 'tilawa':
      return 'tlawa';
    default:
  }
}
