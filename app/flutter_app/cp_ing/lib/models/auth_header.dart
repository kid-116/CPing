import 'package:hive/hive.dart';

part 'auth_header.g.dart';

@HiveType(typeId: 1)
class AuthHeader {
  @HiveField(0)
  late Map<String, String> header;

  AuthHeader({
    required this.header,
  });
}
