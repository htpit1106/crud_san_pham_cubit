import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(genericArgumentFactories: true)
class ObjectResponse<T> {
  final List<dynamic> message;
  final T? data;
  final T? items;
  final bool? status;

  ObjectResponse({this.message = const [], this.data, this.items, this.status});

  factory ObjectResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => ObjectResponse<T>(
    message: _parseMessage(json['message']),
    data: _$nullableGenericFromJson(json['data'], fromJsonT),
    items: _$nullableGenericFromJson(json['items'], fromJsonT),
    status: json['status'] as bool?,
  );
}

List<dynamic> _parseMessage(Object? value) {
  if (value == null) return const [];
  if (value is List) return value;
  return [value];
}

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);
