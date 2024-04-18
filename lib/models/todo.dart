class Todo {
  String title;
  bool isCompleted;
  bool isEditing;

  Todo({
    required this.title,
    this.isCompleted = false,
    this.isEditing = false,
  });

  // Setters and getters for isEditing and title
  setEditing(bool value) {
    isEditing = value;
  }

  setTitle(String value) {
    title = value;
  }

  // Toggle the completion status of the todo
  toggleCompletion() {
    isCompleted = !isCompleted;
  }

  // Convert the todo to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Factory method to create a Todo from a JSON object
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      isCompleted: json['isCompleted'],
    );
  }

// Add other methods as needed
}
