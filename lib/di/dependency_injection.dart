import 'package:test_task_for_effective_mobile/data/api.dart';
import 'package:test_task_for_effective_mobile/data/mapper.dart';
import 'package:test_task_for_effective_mobile/data/repository_impl.dart';

import '../data/db/db_service.dart';
import '../data/shared_prefs/app_shared_preferences.dart';

class DependencyInjection {
  static getMapper() => Mapper();
  static getRepository() => RepositoryImpl();
  static getApi() => Api();
  static getDatabase() => DBService.instance();
  static getSharedPrefs() => AppSharedPreferences();
}