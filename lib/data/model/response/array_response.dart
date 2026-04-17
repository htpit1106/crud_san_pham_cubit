class ArrayResponse<T> {
  final List<T>? data;
  final Pagination? pagination;

  ArrayResponse({this.data, this.pagination});
  factory ArrayResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ArrayResponse<T>(
      data: (json['data'] as List?)
          ?.map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      pagination: json['paging'] != null
          ? Pagination.fromJson(json['paging'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Pagination {
  final int? page;
  final int? limit;
  final int? count;

  Pagination({this.page, this.limit, this.count});
  Map<String, dynamic> toJson() {
    return {'page': page, 'limit': limit, 'count': count};
  }

  // fromJson
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] as int?,
      limit: json['limit'] as int?,
      count: json['count'] as int?,
    );
  }
}
