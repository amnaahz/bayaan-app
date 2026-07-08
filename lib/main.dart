import 'package:bayaan/app.dart';
import 'package:bayaan/core/config/app_config.dart';
import 'package:bayaan/data/repositories/bayaan_repository.dart';
import 'package:flutter/material.dart';

void main() {
  final config = AppConfig.fromEnvironment();

  // The front-end runs on mock data today. To connect a real backend later,
  // provide an alternative [BayaanRepository] implementation here (selected
  // via [AppConfig.useMockData] / [AppConfig.apiBaseUrl]).
  const BayaanRepository repository = MockBayaanRepository();

  runApp(BayaanApp(repository: repository, config: config));
}
