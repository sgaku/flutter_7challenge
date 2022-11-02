import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/notification_repository.dart';

final notificationProvider = Provider((ref) => NotificationRepository());
