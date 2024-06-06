import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:neighborly_flutter_app/core/network/network_info.dart';

final sl = GetIt.instance;


void init() async {
  // register usecase


  // register repository


  // register datasource


  // register network info
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
        InternetConnectionChecker(),
      ));


  // register bloc



}