import 'package:json_annotation/json_annotation.dart';
part 'serializable.g.dart';

@JsonSerializable()
class Task {
  String id;
  String name;
  String avatar;
  String createdAt;

  Task({this.id, this.name, this.avatar, this.createdAt});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

enum Status {
  @JsonValue("new")
  New,
  @JsonValue("on_going")
  OnGoing,
  @JsonValue("closed")
  Closed,
}

@JsonSerializable()
class TaskQuery {
  List<Status> statuses;
  TaskQuery(this.statuses);

  factory TaskQuery.fromJson(Map<String, dynamic> json) =>
      _$TaskQueryFromJson(json);
  Map<String, dynamic> toJson() => _$TaskQueryToJson(this);
}

@JsonSerializable()
class TaskGroup {
  DateTime date;
  List<Task> todos;
  List<Task> completed;
  List<Task> inProgress;

  TaskGroup({this.date, this.todos, this.completed, this.inProgress});

  factory TaskGroup.fromJson(Map<String, dynamic> json) =>
      _$TaskGroupFromJson(json);
  Map<String, dynamic> toJson() => _$TaskGroupToJson(this);
}
