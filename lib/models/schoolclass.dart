class SchoolClass {
  final int id;
  final String name;

  const SchoolClass({
    required this.id,
    required this.name,
  });

  static SchoolClass blank() {
    return const SchoolClass(
      id: 0,
      name: "",
    );
  }
}
