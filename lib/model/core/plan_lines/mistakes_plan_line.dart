class Mistakes {
  int totalMstkQlty,totalMstkQty,totalMstkRead;

  Mistakes({required this.totalMstkQlty,required this.totalMstkQty,required this.totalMstkRead});

  Mistakes.fromJson(Map<String, dynamic> json):
    totalMstkQlty = json['total_mstk_qlty'] ?? 0,
    totalMstkQty = json['total_mstk_qty'] ?? 0,
    totalMstkRead = json['total_mstk_read'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['total_mstk_qlty'] = totalMstkQlty;
    data['total_mstk_qty'] =  totalMstkQty;
    data['total_mstk_read'] = totalMstkRead;
    return data;
  }

  Map<String, dynamic> toMap() => {
        "total_mstk_qlty": totalMstkQlty,
        "totalMstkQty": totalMstkQty,
        "totalMstkRead": totalMstkRead,
      };
}

