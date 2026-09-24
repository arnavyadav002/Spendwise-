import 'package:spendwise/core/network/mock_backend.dart';

class FakeApi {
  static MockBackendDatabase get db => MockBackendDatabase.instance;

  static void reset() {
    MockBackendDatabase.instance.reset();
  }
}
