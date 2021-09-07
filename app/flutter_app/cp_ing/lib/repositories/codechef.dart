import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cp_ing/models/codechef.dart';

class CodechefRepository {
  Future<List<CodechefModel>> getCodechefData(String a) async {
    var response = await http
        .get(Uri.parse("http://10.0.2.2:5000/api/codechef/contests/"));
    var data = json.decode(response.body);
    List<CodechefModel> _CodechefModelList = [];
    print(data['future-contests']);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (var item in data[a]) {
        CodechefModel _CodechefModel = CodechefModel.fromJson(item);
        _CodechefModelList.add(_CodechefModel);
      }
      print(_CodechefModelList.length);
      return _CodechefModelList;
    } else {
      print("error");
      return _CodechefModelList;
    }
  }
}
