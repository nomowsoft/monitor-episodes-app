import 'package:monitor_episodes/model/core/user/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class TeacherService {

  Future<TeacherModel?> get getUserLocal async {
    final prefs = await SharedPreferences.getInstance();
    String files = prefs.getString('user') ?? '';
    var data = files.isNotEmpty ? convert.jsonDecode(files) : null;
    if (data != null) {
      return TeacherModel.fromJson(data);
    }
    return null;
  }

  Future setTeacherLocal(TeacherModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = user.toJson();
    var data = convert.jsonEncode(listJson);
    await prefs.setString('user', data.toString());
  }

  Future removeTeacherLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', '');
  }

}
