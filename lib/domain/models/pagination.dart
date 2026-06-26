class PaginatedResponse<T> {
  final bool success;
  final List<T> data;
  final int total;
  final int page;
  final int limit;

  PaginatedResponse({
    required this.success,
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>? ?? []).map(fromJsonT).toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 50,
    );
  }

  bool get hasNextPage => total > page * limit;
  bool get hasPreviousPage => page > 1;
}
