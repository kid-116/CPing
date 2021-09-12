import 'package:hive/hive.dart';

part 'calenderapi.g.dart';

@HiveType(typeId: 1)
class Authcalender {
  @HiveField(0)
  late var authHeaders;
}
