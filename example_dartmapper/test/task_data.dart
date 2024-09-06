import 'dart:convert';

import 'package:retrofit_example/example.dart';

final demoTask = Task(
    id: "123455151",
    name: "demo task",
    avatar:
        "https://p7.hiclipart.com/preview/312/283/679/avatar-computer-icons-user-profile-business-user-avatar.jpg",
    createdAt: "2017/09/08 21:35:19");

final demoTaskJson = jsonEncode(demoTask);
final List<Task> demoTaskList = [demoTask];
final demoTaskListJson = jsonEncode(demoTaskList);
final List<Task> demoEmptyList = [];
final demoEmptyListJson = jsonEncode(demoEmptyList);

final groupTask = TaskGroup(
    date: DateTime.now(),
    todos: demoTaskList,
    completed: demoTaskList,
    inProgress: demoEmptyList);

final groupTaskList = [groupTask];
final groupTaskListJson = jsonEncode(groupTaskList);
