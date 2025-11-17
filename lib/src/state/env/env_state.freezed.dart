// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'env_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EnvState {

 String? get host; String? get usernameOrEmail; String? get password; String? get token;
/// Create a copy of EnvState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnvStateCopyWith<EnvState> get copyWith => _$EnvStateCopyWithImpl<EnvState>(this as EnvState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnvState&&(identical(other.host, host) || other.host == host)&&(identical(other.usernameOrEmail, usernameOrEmail) || other.usernameOrEmail == usernameOrEmail)&&(identical(other.password, password) || other.password == password)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,host,usernameOrEmail,password,token);

@override
String toString() {
  return 'EnvState(host: $host, usernameOrEmail: $usernameOrEmail, password: $password, token: $token)';
}


}

/// @nodoc
abstract mixin class $EnvStateCopyWith<$Res>  {
  factory $EnvStateCopyWith(EnvState value, $Res Function(EnvState) _then) = _$EnvStateCopyWithImpl;
@useResult
$Res call({
 String? host, String? usernameOrEmail, String? password, String? token
});




}
/// @nodoc
class _$EnvStateCopyWithImpl<$Res>
    implements $EnvStateCopyWith<$Res> {
  _$EnvStateCopyWithImpl(this._self, this._then);

  final EnvState _self;
  final $Res Function(EnvState) _then;

/// Create a copy of EnvState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = freezed,Object? usernameOrEmail = freezed,Object? password = freezed,Object? token = freezed,}) {
  return _then(_self.copyWith(
host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,usernameOrEmail: freezed == usernameOrEmail ? _self.usernameOrEmail : usernameOrEmail // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc


class _EnvState implements EnvState {
  const _EnvState({this.host, this.usernameOrEmail, this.password, this.token});
  

@override final  String? host;
@override final  String? usernameOrEmail;
@override final  String? password;
@override final  String? token;

/// Create a copy of EnvState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnvStateCopyWith<_EnvState> get copyWith => __$EnvStateCopyWithImpl<_EnvState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnvState&&(identical(other.host, host) || other.host == host)&&(identical(other.usernameOrEmail, usernameOrEmail) || other.usernameOrEmail == usernameOrEmail)&&(identical(other.password, password) || other.password == password)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,host,usernameOrEmail,password,token);

@override
String toString() {
  return 'EnvState(host: $host, usernameOrEmail: $usernameOrEmail, password: $password, token: $token)';
}


}

/// @nodoc
abstract mixin class _$EnvStateCopyWith<$Res> implements $EnvStateCopyWith<$Res> {
  factory _$EnvStateCopyWith(_EnvState value, $Res Function(_EnvState) _then) = __$EnvStateCopyWithImpl;
@override @useResult
$Res call({
 String? host, String? usernameOrEmail, String? password, String? token
});




}
/// @nodoc
class __$EnvStateCopyWithImpl<$Res>
    implements _$EnvStateCopyWith<$Res> {
  __$EnvStateCopyWithImpl(this._self, this._then);

  final _EnvState _self;
  final $Res Function(_EnvState) _then;

/// Create a copy of EnvState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = freezed,Object? usernameOrEmail = freezed,Object? password = freezed,Object? token = freezed,}) {
  return _then(_EnvState(
host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,usernameOrEmail: freezed == usernameOrEmail ? _self.usernameOrEmail : usernameOrEmail // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
