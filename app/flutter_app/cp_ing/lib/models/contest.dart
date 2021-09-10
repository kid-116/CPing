class Contest {
  late Duration length;
  late String name;
  late DateTime start;
  late DateTime end;
  late String venue;
  String id = 'null';

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

class Contests {
  late List<Contest> contests;

  Contests({required this.contests});

  Contests.fromJson(Map<String, dynamic> json) {
    if (true) {
      contests = <Contest>[];
      contests.add(Contest.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contests'] = contests.map((v) => v.toJson()).toList();
    return data;
  }
}

