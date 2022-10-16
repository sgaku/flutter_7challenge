// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserDataState {
  List<UserData>? get userList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserDataStateCopyWith<UserDataState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataStateCopyWith<$Res> {
  factory $UserDataStateCopyWith(
          UserDataState value, $Res Function(UserDataState) then) =
      _$UserDataStateCopyWithImpl<$Res, UserDataState>;
  @useResult
  $Res call({List<UserData>? userList});
}

/// @nodoc
class _$UserDataStateCopyWithImpl<$Res, $Val extends UserDataState>
    implements $UserDataStateCopyWith<$Res> {
  _$UserDataStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userList = freezed,
  }) {
    return _then(_value.copyWith(
      userList: freezed == userList
          ? _value.userList
          : userList // ignore: cast_nullable_to_non_nullable
              as List<UserData>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserDataStateCopyWith<$Res>
    implements $UserDataStateCopyWith<$Res> {
  factory _$$_UserDataStateCopyWith(
          _$_UserDataState value, $Res Function(_$_UserDataState) then) =
      __$$_UserDataStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserData>? userList});
}

/// @nodoc
class __$$_UserDataStateCopyWithImpl<$Res>
    extends _$UserDataStateCopyWithImpl<$Res, _$_UserDataState>
    implements _$$_UserDataStateCopyWith<$Res> {
  __$$_UserDataStateCopyWithImpl(
      _$_UserDataState _value, $Res Function(_$_UserDataState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userList = freezed,
  }) {
    return _then(_$_UserDataState(
      userList: freezed == userList
          ? _value._userList
          : userList // ignore: cast_nullable_to_non_nullable
              as List<UserData>?,
    ));
  }
}

/// @nodoc

class _$_UserDataState implements _UserDataState {
  const _$_UserDataState({final List<UserData>? userList})
      : _userList = userList;

  final List<UserData>? _userList;
  @override
  List<UserData>? get userList {
    final value = _userList;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserDataState(userList: $userList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserDataState &&
            const DeepCollectionEquality().equals(other._userList, _userList));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_userList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserDataStateCopyWith<_$_UserDataState> get copyWith =>
      __$$_UserDataStateCopyWithImpl<_$_UserDataState>(this, _$identity);
}

abstract class _UserDataState implements UserDataState {
  const factory _UserDataState({final List<UserData>? userList}) =
      _$_UserDataState;

  @override
  List<UserData>? get userList;
  @override
  @JsonKey(ignore: true)
  _$$_UserDataStateCopyWith<_$_UserDataState> get copyWith =>
      throw _privateConstructorUsedError;
}
