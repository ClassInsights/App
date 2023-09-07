class Lesson {
  final int id;
  final int roomId;
  final int subjectId;
  final int classId;
  final DateTime startTime;
  final DateTime endTime;

  const Lesson({
    required this.id,
    required this.roomId,
    required this.subjectId,
    required this.classId,
    required this.startTime,
    required this.endTime,
  });
}
