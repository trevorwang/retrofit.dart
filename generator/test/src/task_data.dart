import 'dart:convert';
import '../../example/lib/example.dart';

final demoTask = Task(
    id: "123455151",
    name: "demo task",
    avatar:
        "https://p7.hiclipart.com/preview/312/283/679/avatar-computer-icons-user-profile-business-user-avatar.jpg",
    createdAt: "2017/09/08 21:35:19");

final demoTaskJson = jsonEncode(demoTask);
final demoTaskList = []..add(demoTask);
final demoTaskListJson = jsonEncode(demoTaskList);
final demoEmptyList = [];
final demoEmptyListJson = jsonEncode(demoEmptyList);
