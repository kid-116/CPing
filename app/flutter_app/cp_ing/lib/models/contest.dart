import 'package:hive/hive.dart';

class Contest {
  late Duration length;
  late String name;
  late DateTime start;
  late DateTime end;
  late String venue;
  late String id = 'null';

  Contest({
    required this.name,
    required this.length,
    required this.start,
    required this.end,
    required this.venue,
    required this.id,
  });

  Contest.fromJson(Map<String, dynamic> json) {
    // print(json['length']);
    length = Duration(
      days: json['length']['days'],
      hours: json['length']['hours'],
      minutes: json['length']['minutes']
    );
    name = json['name'];
    start = DateTime.parse(json['start']).toLocal();
    end = start.add(length);
    // start = json['start'];
    venue = json['venue'];
    var contestBox = Hive.box('contests').toMap();
    contestBox.forEach((key, contest) {
      if (contest.name == name) {
        id = contest.id;
      }
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['length'] = length;
    data['name'] = name;
    data['start'] = start;
    data['id'] = id;
    data['end'] = end;
    data['venue'] = venue;
    return data;
  }
}
