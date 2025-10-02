import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🔹 Çocuk tarafı
import '../features/child/home/home_screen.dart';
import '../features/child/tasks/tasks_screen.dart';
import '../features/child/collection/collection_screen.dart';
import '../features/child/profile/profile_screen.dart';

// 🔹 Ebeveyn tarafı
import '../features/parent/add_task/add_task_screen.dart';
import '../features/parent/panel/parent_panel_screen.dart';
import '../features/parent/reports/reports_screen.dart';
import '../features/parent/settings/change_pin_screen.dart'; // ✅ PIN ekranı

final GoRouter appRouter = GoRouter(
  routes: [
    // 🔹 Çocuk akışı
    GoRoute(
      path: '/',
      builder: (context, state) => const ChildHomeScreen(),
      routes: [
        GoRoute(
          path: 'tasks',
          builder: (context, state) => const TasksScreen(),
        ),
        GoRoute(
          path: 'collection',
          builder: (context, state) => const CollectionScreen(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: 'add-task',
          builder: (context, state) => const AddTaskScreen(),
        ),
      ],
    ),

    // 🔹 Ebeveyn paneli
    GoRoute(
      path: '/parent',
      builder: (context, state) => const ParentPanelScreen(),
    ),

    // 🔹 Raporlar
    GoRoute(
      path: '/parent/reports',
      builder: (context, state) => const ReportsScreen(),
    ),

    // 🔹 PIN Değiştir
    GoRoute(
      path: '/change-pin',
      builder: (context, state) => const ChangePinScreen(),
    ),
  ],
);
