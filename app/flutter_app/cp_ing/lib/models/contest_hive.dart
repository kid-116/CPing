import 'package:hive/hive.dart';

part 'contest_hive.g.dart';

@HiveType(typeId: 0)
class ContestHive {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late String id;
  @HiveField(2)
  late String end;
  @HiveField(3)
  late String start;
  @HiveField(4)
  late String venue;

  ContestHive({
    required this.name,
    required this.id,
    required this.end,
    required this.start,
    required this.venue,
  });
}