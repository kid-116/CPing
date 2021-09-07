import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cp_ing/models/codechef.dart';

class CodechefRepository {
  Future<List<CodechefModel>> getCodechefData(String a) async {
    var response = await http
        .get(Uri.parse("http://10.0.2.2:5000/api/codechef/contests/"));
    var data = json.decode(response.body);
    List<CodechefModel> _codechefModelList = [];
    print(data['future-contests']);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (var item in data[a]) {
        CodechefModel _codechefModel = CodechefModel.fromJson(item);
        _codechefModelList.add(_codechefModel);
      }
      print(_codechefModelList.length);
      return _codechefModelList;
    } else {
      print("error");
      return _codechefModelList;
    }
  }
}
