
import 'package:flutter_7challenge/model/user_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.freezed.dart';

@freezed
class UserDataState with _$UserDataState {
  const factory UserDataState({
    List<UserData>? userList,
  }) = _UserDataState;
}