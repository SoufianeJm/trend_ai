import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import '../config/app_config.dart';

class AppwriteClient {
  static final Client client = Client()
    ..setEndpoint("https://cloud.appwrite.io/v1")
    ..setProject("67dc087f00082b022eca");

  static final Account account = Account(client);
  static final Databases databases = Databases(client);
  static final Functions functions = Functions(client); // ✅ Add this
}
