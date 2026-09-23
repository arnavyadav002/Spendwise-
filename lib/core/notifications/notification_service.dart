import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String message;
  final bool isRead;

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    bool? isRead,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationService {
  const NotificationService();

  List<AppNotification> get sampleNotifications => const [
    AppNotification(
      id: 'welcome',
      title: 'Welcome back',
      message: 'Your spending summary is ready.',
    ),
    AppNotification(
      id: 'budget',
      title: 'Budget check-in',
      message: 'You are on track for this month.',
      isRead: true,
    ),
  ];
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return const NotificationService();
});
