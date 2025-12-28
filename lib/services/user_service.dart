import '../models/user_model.dart';
import 'showcase_data.dart';

class UserService {
  Future<UserModel> fetchUserProfile() async {
    return ShowcaseData.currentUser;
  }
}
