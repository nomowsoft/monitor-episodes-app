import 'package:intl/intl.dart';

class Educational {
  String fromSuraName, toSuraName;
  int fromAya, toAya;
  DateTime? actualDate;
  int totalMstkQty, totalMstkRead;

  Educational({
    required this.actualDate,
    required this.fromSuraName,
    required this.fromAya,
    required this.toAya,
    required this.toSuraName,
    required this.totalMstkQty,
    required this.totalMstkRead,
  });

  Educational.fromJson(Map<String, dynamic> json)
      : fromSuraName = json['from_sura_name'] ?? '',
        toSuraName = json['to_sura_name'] ?? '',
        actualDate = DateTime.tryParse(
            json['actual_date'].toString().replaceAll('T', ' ')), 
        fromAya = json['from_aya'] ?? 0,
        toAya = json['to_aya'] ?? 0,
        totalMstkQty = json['total_mstk_qty'] ?? 0,
        totalMstkRead = json['total_mstk_read'] ?? 0 ;

  Map<String, dynamic> toJson() => {
        "actual_date": DateFormat('yyyy-MM-dd').format(actualDate!) , 
        "from_sura_name": fromSuraName,
        "to_sura_name": toSuraName,
        "from_aya": fromAya,
        "to_aya": toAya,
        "total_mstk_qty": totalMstkQty,
        "total_mstk_read": totalMstkRead, 
      };

 

  
}
