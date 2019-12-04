import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:snapfeed/src/common/config/config_api_response.dart';
import 'package:snapfeed/src/common/network/data_state.dart';

class SnapfeedApiClient {
  SnapfeedApiClient(
      {@required this.httpClient,
      @required this.projectId,
      @required this.secret});

  static const String _host = 'https://api.snapfeed.dev/v1/';
  static const String _projectsPath = 'projects';
  static const String _feedbackPath = 'feedback';
  static const String _configPath = 'config';

  static const String _parameterFeedbackMessage = 'message';
  static const String _parameterFeedbackScreenshot = 'file';

  final http.Client httpClient;
  final String projectId;
  final String secret;

  Future<Map<String, dynamic>> get(String urlPath) async {
    final url = '$_host$urlPath';
    final http.BaseResponse response =
        await httpClient.get(url, headers: {'authorization': 'Secret $secret'});
    final responseJsonString =
        utf8.decode((response as http.Response).bodyBytes);
    if (response.statusCode != 200) {
      throw Exception('${response.statusCode}:\n$responseJsonString');
    }
    try {
      return json.decode(responseJsonString) as Map<String, dynamic>;
    } catch (exception) {
      throw Exception('${exception.toString()}\n$responseJsonString');
    }
  }

  Future<Map<String, dynamic>> post({
    @required String urlPath,
    @required Map<String, String> arguments,
    List<http.MultipartFile> files,
  }) async {
    final url = '$_host$urlPath';
    http.BaseResponse response;
    String responseJsonString;
    if (files == null) {
      response = await httpClient.post(url,
          headers: {'authorization': 'Secret $secret'}, body: arguments);
      responseJsonString = utf8.decode((response as http.Response).bodyBytes);
    } else {
      final multipartRequest = http.MultipartRequest('POST', Uri.parse(url))
        ..fields.addAll(arguments)
        ..files.addAll(files);
      multipartRequest.headers['authorization'] = 'Secret $secret';
      response = await multipartRequest.send();
      responseJsonString = utf8
          .decode(await (response as http.StreamedResponse).stream.toBytes());
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('${response.statusCode}:\n$responseJsonString');
    }
    try {
      return json.decode(responseJsonString) as Map<String, dynamic>;
    } catch (exception) {
      throw Exception('${exception.toString()}\n$responseJsonString');
    }
  }

  Future<void> getConfig({
    @required
        SetSnapfeedDataStateCallback<SnapfeedConfigApiResponse>
            onDataStateChanged,
  }) async {
    onDataStateChanged(SnapfeedDataState<SnapfeedConfigApiResponse>.loading());
    try {
      onDataStateChanged(
        SnapfeedDataState<SnapfeedConfigApiResponse>.success(
          SnapfeedConfigApiResponse.fromJson(
            await get('$_projectsPath/$projectId/$_configPath'),
          ),
        ),
      );
    } catch (exception) {
      onDataStateChanged(
          SnapfeedDataState<SnapfeedConfigApiResponse>.error(exception));
    }
  }

  Future<void> sendFeedback({
    @required String message,
    @required Uint8List screenshot,
    @required
        SetSnapfeedDataStateCallback<Map<String, dynamic>> onDataStateChanged,
  }) async {
    onDataStateChanged(SnapfeedDataState<Map<String, dynamic>>.loading());
    try {
      onDataStateChanged(
        SnapfeedDataState<Map<String, dynamic>>.success(
          await post(
            urlPath: '$_projectsPath/$projectId/$_feedbackPath',
            arguments: <String, String>{
              _parameterFeedbackMessage: message,
            },
            files: <http.MultipartFile>[
              http.MultipartFile.fromBytes(
                _parameterFeedbackScreenshot,
                screenshot,
                filename: 'screenshot.png',
                contentType: MediaType('image', 'png'),
              ),
            ],
          ),
        ),
      );
    } catch (exception) {
      onDataStateChanged(
          SnapfeedDataState<Map<String, dynamic>>.error(exception));
    }
  }
}

typedef SetSnapfeedDataStateCallback<T> = void Function(
    SnapfeedDataState<T> dataState);
