import 'dart:developer';

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  final InternetConnection _internetConnection;
  ConnectivityRepositoryImpl(this._internetConnection);
  @override
  Future<bool> get hasIntenert async {
    try {
      return await _internetConnection.hasInternetAccess;
    } catch (e) {
      log(e.toString(), name: 'ConnectivityRepositoryImpl');
      return false;
    }
  }
}
