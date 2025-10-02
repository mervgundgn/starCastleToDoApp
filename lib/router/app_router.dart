import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 🔹 Çocuk tarafı
import '../features/splash/splash_screen.dart';
import '../features/child/home/home_screen.dart';
import '../features/child/tasks/tasks_screen.dart';
import '../features/child/collection/collection_screen.dart';
import '../features/child/collection/collection_detail_screen.dart';
import '../features/child/profile/profile_screen.dart';

// 🔹 Ebeveyn tarafı
import '../features/parent/add_task/add_task_screen.dart';
import '../features/parent/auth/pin_screen.dart';
import '../features/parent/panel/parent_panel_screen.dart';
import '../features/parent/reports/reports_screen.dart';
import '../features/parent/settings/change_pin_screen.dart';
import 'package:starcastle_todoapp/features/parent/settings/edit_profile_screen.dart';

/// 🌍 Tüm uygulama router’ı
final GoRouter appRouter = GoRouter(
  initialLocation: "/splash",
  routes: [
    // Splash
    GoRoute(
      path: "/splash",
      builder: (context, state) => const SplashScreen(),
    ),

    // 🔹 Çocuk akışı
    GoRoute(
      path: "/child/home",
      builder: (context, state) => const ChildHomeScreen(),
    ),
    GoRoute(
      path: "/tasks",
      builder: (context, state) => const TasksScreen(),
    ),
    GoRoute(
      path: "/collection",
      builder: (context, state) => const CollectionScreen(),
    ),
    GoRoute(
      path: "/collection/:category",
      builder: (context, state) {
        final category = state.pathParameters['category']!;
        final titles = {
          "princess": "Prensesler",
          "superheroes": "Süper Kahramanlar",
          "flowers": "Çiçekler",
          "cars": "Arabalar",
          "jobs": "Meslekler",
        };
        return CollectionDetailScreen(
          category: category,
          title: titles[category] ?? category,
        );
      },
    ),
    GoRoute(
      path: "/profile",
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: "/add-task",
      builder: (context, state) => const AddTaskScreen(),
    ),

    // 🔹 Ebeveyn akışı
    GoRoute(
      path: "/parent/pin",
      builder: (context, state) => const PinScreen(),
    ),
    GoRoute(
      path: "/parent/panel",
      builder: (context, state) => const ParentPanelScreen(),
    ),
    GoRoute(
      path: "/parent/reports",
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: "/parent/change-pin",
      builder: (context, state) => const ChangePinScreen(),
    ),
    GoRoute(
      path: "/parent/edit-profile",
      builder: (context, state) => const EditProfileScreen(),
    ),

  ],
);
