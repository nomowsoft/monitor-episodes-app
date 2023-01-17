class ListenLine {
  String typeFollow, actualDate;
  int linkId,
      fromSuraId,
      toSuraId,
      fromAya,
      toAya,
      totalMstkQlty,
      totalMstkQty,
      totalMstkRead;

  ListenLine({
    required this.linkId,
    required this.fromSuraId,
    required this.fromAya,
    required this.toAya,
    required this.toSuraId,
    required this.actualDate,
    required this.typeFollow,
    required this.totalMstkQty,
    required this.totalMstkQlty,
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
        totalMstkQlty = json['total_mstk_qlty'] ?? 0,
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
        "total_mstk_qlty": totalMstkQlty,
        "total_mstk_read": totalMstkRead
      };

      
}


