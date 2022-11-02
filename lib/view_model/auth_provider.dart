import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';

final authProvider = Provider((ref) => AuthRepository());