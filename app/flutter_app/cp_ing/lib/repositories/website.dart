import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cp_ing/models/contest.dart';

class WebsiteRepository {
  static const String hostUrl = "http://10.0.2.2:5000/";
  late String endpoint;

  WebsiteRepository({
    required this.endpoint,
  });

  Future<List<Contest>> getWebsiteContests(String type) async {
    List<Contest> contests = [];
    try {
      // print("fetching contests...");
      var response = await http.get(Uri.parse(hostUrl + endpoint));
      // print("response served...");
      var data = json.decode(response.body);
        for (var item in data[type]) {
          Contest contest = Contest.fromJson(item);
          contests.add(contest);
        }
    } catch(e) {
      print("debug: $e");
    }
    return contests;
  }

  void setEndpoint(String endpoint) {
    this.endpoint = endpoint;
  }
}
