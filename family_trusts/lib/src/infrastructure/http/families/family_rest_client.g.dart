// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _FamilyRestClient implements FamilyRestClient {
  _FamilyRestClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<FamilyDTO>> findMatchingFamiliesByMemberIdQuery(memberId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'memberId': memberId};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<FamilyDTO>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/families',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => FamilyDTO.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<FamilyDTO>> findAvailableFamiliesByNameQuery(familyName) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'name': familyName};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<FamilyDTO>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/families/available',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => FamilyDTO.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<FamilyDTO> createFamily(createFamilyDTO) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createFamilyDTO.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FamilyDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/families',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FamilyDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FamilyDTO> removeMember(familyId, memberId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<FamilyDTO>(
            Options(method: 'DELETE', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, '/families/${familyId}/members/${memberId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FamilyDTO.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
