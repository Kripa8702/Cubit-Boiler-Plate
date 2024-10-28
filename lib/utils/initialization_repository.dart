import 'package:cubit_boiler_plate/utils/colored_logs.dart';
import 'package:cubit_boiler_plate/utils/dio_client.dart';

class InitializationRepository {
  late DioClient dioClient;

  Future<void> init() async {
    dioClient = DioClient();
    ColoredLogs.success("::::::::::::::::::::: DioClient Initialized :::::::::::::::::::::");
  }
}
