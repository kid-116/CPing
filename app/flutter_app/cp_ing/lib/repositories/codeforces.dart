import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cp_ing/models/codeforces.dart';

class CodeforcesRepository {
  Future<List<CodeforcesModel>> getCodeforcesData(String a) async {
    var response = await http
        .get(Uri.parse("http://10.0.2.2:5000/api/codeforces/contests/"));
    var data = json.decode(response.body);
    List<CodeforcesModel> _codeforcesModelList = [];
    print(data['future-contests']);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (var item in data[a]) {
        CodeforcesModel _codeforcesModel = CodeforcesModel.fromJson(item);
        _codeforcesModelList.add(_codeforcesModel);
      }
      print(_codeforcesModelList.length);
      return _codeforcesModelList;
    } else {
      print("error");
      return _codeforcesModelList;
    }
  }
}
