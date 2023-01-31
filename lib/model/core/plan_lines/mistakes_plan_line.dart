class Mistakes {
  int  totalMstkQty, totalMstkRead;

  Mistakes(
      {
      required this.totalMstkQty,
      required this.totalMstkRead});

  Mistakes.fromJson(Map<String, dynamic> json)
      : totalMstkQty = json['total_mstk_qty'] ?? 0,
        totalMstkRead = json['total_mstk_read'] ?? 0;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_mstk_qty'] = totalMstkQty;
    data['total_mstk_read'] = totalMstkRead;
    return data;
  }

  Map<String, dynamic> toMap() => {
        "totalMstkQty": totalMstkQty,
        "totalMstkRead": totalMstkRead,
      };
}
