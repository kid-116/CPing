class Contest {
  late Duration length;
  late String name;
  late DateTime start;
  late DateTime end;
  late String calendarId = 'null';
  late String docId = 'null';

  Contest({
    required this.name,
    required this.length,
    required this.start,
    required this.end,
    required this.calendarId,
    required this.docId,
  });

  Contest.fromJson(Map<String, dynamic> json) {
    length = Duration(
        days: json['length']['days'],
        hours: json['length']['hours'],
        minutes: json['length']['minutes']);
    name = json['name'];
    start = DateTime.parse(json['start']).toLocal();
    end = start.add(length);

    // for (final contest in registeredContests) {
    //   if (contest['name'] == name) {
    //     id = contest['id'];
    //     docId = contest.id;
    //   }
    // }
  }
}