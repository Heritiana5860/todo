class TodoModel {
  int? id;
  String title;
  String description;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
  });

  // Factory method for creating a TodoModel from a map (e.g., for JSON parsing)
  ///deserialization
  factory TodoModel.fromMap(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // Method to convert a TodoModel into a map (e.g., for saving to a database)
  ///Serialization
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }


  ///Debugging
  @override
  String toString() {
    return 'TodoModel(id: $id, title: $title, description: $description)';
  }
}
