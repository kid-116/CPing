import 'dart:convert';

import 'package:cp_ing/models/atcoder_model.dart';
import 'package:http/http.dart' as http;

class AtcoderRepository {
  Future<List<AtcoderModel>> getAtcoderData(String a) async {
    var response =
        await http.get(Uri.parse("http://10.0.2.2:5000/api/atcoder/contests/"));
    var data = json.decode(response.body);
    List<AtcoderModel> _AtcoderModelList = [];
    print(data['future-contests']);
    print(response.statusCode);
    if (response.statusCode == 200) {
      for (var item in data[a]) {
        AtcoderModel _AtcoderModel = AtcoderModel.fromJson(item);
        _AtcoderModelList.add(_AtcoderModel);
      }
      print(_AtcoderModelList.length);
      return _AtcoderModelList;
    } else {
      print("error");
      return _AtcoderModelList;
    }
  }
}
