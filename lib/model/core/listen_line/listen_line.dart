import 'package:monitor_episodes/model/offline_quran/verses.dart';

class ListenLine {
  String typeFollow, actualDate;
  int linkId, fromSuraId, toSuraId, fromAya, toAya, totalMstkQty, totalMstkRead;

  ListenLine({
    required this.linkId,
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
      : linkId = json['link_id'] ?? 0,
        typeFollow = json['type_follow'] ?? '',
        actualDate = json['actual_date'] ?? '',
        fromSuraId = json['from_surah'] ?? 0,
        fromAya = json['from_aya'] ?? 0,
        toSuraId = json['to_surah'] ?? 0,
        toAya = json['to_aya'] ?? 0,
        totalMstkQty = json['total_mstk_qty'] ?? 0,
        totalMstkRead = json['total_mstk_read'] ?? 0;

  Map<String, dynamic> toJson() => {
        "link_id": linkId,
        "type_follow": typeFollow,
        "actual_date": actualDate,
        "from_surah": fromSuraId,
        "from_aya": fromAya,
        "to_surah": toSuraId,
        "to_aya": toAya,
        "total_mstk_qty": totalMstkQty,
        "total_mstk_read": totalMstkRead
      };

  Map<String, dynamic> toJsonServer() => {
        'id': linkId.toString(),
        'date_listen': actualDate,
        'type_work': getTypeWork(typeFollow),
        'from_sura': fromSuraId,
        'to_sura': toSuraId,
        'from_aya': getfromAyaId(),
        'to_aya': getToAyaId(),
        'nbr_error_hifz': totalMstkQty,
        'nbr_error_tajwed': totalMstkRead
      };

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
