import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/user_repository.dart';

final userProvider = Provider((ref) => UserRepository());