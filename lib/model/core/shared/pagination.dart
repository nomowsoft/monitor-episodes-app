class Pagination {
  int? currentPage,nextPage,previousPage,totalPages,perPage,totalEntries;
   
  Pagination({this.currentPage, this.nextPage, this.previousPage,this.totalPages,this.perPage,this.totalEntries});
  
  Pagination.fromJson(Map<String, dynamic> jsonMap) {
    currentPage = jsonMap['current_page'];
    nextPage = jsonMap['next_page'];
    previousPage = jsonMap['previous_page'];
    totalPages = jsonMap['total_pages'];
    perPage = jsonMap['per_page'];
    totalEntries = jsonMap['total_entries'];
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage??0,
      'next_page': nextPage??0,
      "previous_page": previousPage??0,
      "total_pages": totalPages??0,
      "per_page": perPage??0,
      "total_entries": totalEntries??0,
    };
  }
}
 