// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_proposal_rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _JoinProposalRestClient implements JoinProposalRestClient {
  _JoinProposalRestClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<JoinFamilyProposalDTO>> findArchivedByPersonId(personId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<JoinFamilyProposalDTO>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/proposals/person/${personId}/archived',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            JoinFamilyProposalDTO.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<JoinFamilyProposalDTO> findPendingByPersonId(personId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<JoinFamilyProposalDTO>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/proposals/person/${personId}/pending',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = JoinFamilyProposalDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<JoinFamilyProposalDTO> create(createJoinFamilyProposalDTO) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(createJoinFamilyProposalDTO.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<JoinFamilyProposalDTO>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/proposals',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = JoinFamilyProposalDTO.fromJson(_result.data!);
    return value;
  }

  @override
  Future<JoinFamilyProposalDTO> cancel(joinFamilyProposalId, issuerId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<JoinFamilyProposalDTO>(
            Options(method: 'PUT', headers: _headers, extra: _extra)
                .compose(_dio.options,
                    '/proposals/${joinFamilyProposalId}/cancel/${issuerId}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = JoinFamilyProposalDTO.fromJson(_result.data!);
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
