import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

/// Available whisper models
enum WhisperModel {
  /// tiny model for all languages
  tiny('tiny'),

  /// tiny quantized model for all languages
  tinyQ5('tiny-q5_1'),

  /// base model for all languages
  base('base'),

  /// base quantized model for all languages
  baseQ5('base-q5_1'),

  /// small model for all languages
  small('small'),

  /// small quantized model for all languages
  smallQ5('small-q5_1'),

  /// medium model for all languages
  medium('medium'),

  /// medium quantized model for all languages
  mediumQ5('medium-q5_0'),

  /// large model for all languages
  large('large'),

  /// large quantized model for all languages
  largeQ5('large-q5_0'),

  /// tiny model for english only
  tinyEn('tiny.en'),

  /// tiny quantized model for english only
  tinyEnQ5('tiny.en-q5_1'),

  /// base model for english only
  baseEn('base.en'),

  /// base quantized model for english only
  baseEnQ5('base.en-q5_1'),

  /// small model for english only
  smallEn('small.en'),

  /// small quantized model for english only
  smallEnQ5('small.en-q5_1'),

  /// medium model for english only
  mediumEn('medium.en'),

  /// medium quantized model for english only
  mediumEnQ5('medium.en-q5_0');

  const WhisperModel(this.modelName);

  /// Public name of model
  final String modelName;

  /// Huggingface url to download model
  Uri get modelUri {
    return Uri.parse(
      'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-$modelName.bin',
    );
  }

  /// Get local path of model file
  String getPath(String dir) {
    return '$dir/ggml-$modelName.bin';
  }
}

/// Download [model] to [destinationPath]
Future<String> downloadModel({
  required WhisperModel model,
  required String destinationPath,
}) async {
  logger.info('Download model ${model.modelName}');
  final httpClient = HttpClient();

  final request = await httpClient.getUrl(
    model.modelUri,
  );

  final response = await request.close();

  final bytes = await consolidateHttpClientResponseBytes(response);

  final File file = File(
    model.getPath(destinationPath),
  );
  await file.writeAsBytes(bytes);

  return file.path;
}
