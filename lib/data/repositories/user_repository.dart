import 'package:notification_app/data/models/user.dart';
import 'package:notification_app/data/providers/user_provider.dart';
import 'package:notification_app/utils/utils.dart';

class UserRepository {
  final UserProvider _user = UserProvider();

  /// [customerId] can be composed from users msisdn or email, but can't be
  /// pure value. Use [msisdnToCustomerId] or [emailToCustomerId] to convert the
  /// appropriate value to [customerId]
  Future<User> getUser(String customerId) => _user.getUser(customerId);
}
