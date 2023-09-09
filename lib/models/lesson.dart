import 'package:classinsights/models/subject_data.dart';

class Lesson {
  final int id;
  final int roomId;
  final SubjectData subject;
  final int classId;
  final DateTime? startTime;
  final DateTime? endTime;

  const Lesson({
    required this.id,
    required this.roomId,
    required this.subject,
    required this.classId,
    required this.startTime,
    required this.endTime,
  });
}
