class Computer {
  final int id;
  final int roomId;
  final String name;
  final String? macAddress;
  final String? ipAddress;
  final String? lastUser;
  final DateTime lastSeen;

  Computer({
    required this.id,
    required this.roomId,
    required this.name,
    required this.macAddress,
    required this.ipAddress,
    required this.lastUser,
    required this.lastSeen,
  });
}
