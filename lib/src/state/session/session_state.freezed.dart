// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState()';
}


}

/// @nodoc
class $SessionStateCopyWith<$Res>  {
$SessionStateCopyWith(SessionState _, $Res Function(SessionState) __);
}



/// @nodoc


class SessionUnresolved implements SessionState {
  const SessionUnresolved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionUnresolved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SessionState.unresolved()';
}


}




/// @nodoc


class SessionToken implements SessionState {
  const SessionToken({required this.host, required this.token});
  

 final  String host;
 final  String token;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionTokenCopyWith<SessionToken> get copyWith => _$SessionTokenCopyWithImpl<SessionToken>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionToken&&(identical(other.host, host) || other.host == host)&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,host,token);

@override
String toString() {
  return 'SessionState.token(host: $host, token: $token)';
}


}

/// @nodoc
abstract mixin class $SessionTokenCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory $SessionTokenCopyWith(SessionToken value, $Res Function(SessionToken) _then) = _$SessionTokenCopyWithImpl;
@useResult
$Res call({
 String host, String token
});




}
/// @nodoc
class _$SessionTokenCopyWithImpl<$Res>
    implements $SessionTokenCopyWith<$Res> {
  _$SessionTokenCopyWithImpl(this._self, this._then);

  final SessionToken _self;
  final $Res Function(SessionToken) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? host = null,Object? token = null,}) {
  return _then(SessionToken(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SessionUser implements SessionState {
  const SessionUser({required this.host, required this.usernameOrEmail, required this.password});
  

 final  String host;
 final  String usernameOrEmail;
 final  String password;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionUserCopyWith<SessionUser> get copyWith => _$SessionUserCopyWithImpl<SessionUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionUser&&(identical(other.host, host) || other.host == host)&&(identical(other.usernameOrEmail, usernameOrEmail) || other.usernameOrEmail == usernameOrEmail)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,host,usernameOrEmail,password);

@override
String toString() {
  return 'SessionState.user(host: $host, usernameOrEmail: $usernameOrEmail, password: $password)';
}


}

/// @nodoc
abstract mixin class $SessionUserCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory $SessionUserCopyWith(SessionUser value, $Res Function(SessionUser) _then) = _$SessionUserCopyWithImpl;
@useResult
$Res call({
 String host, String usernameOrEmail, String password
});




}
/// @nodoc
class _$SessionUserCopyWithImpl<$Res>
    implements $SessionUserCopyWith<$Res> {
  _$SessionUserCopyWithImpl(this._self, this._then);

  final SessionUser _self;
  final $Res Function(SessionUser) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? host = null,Object? usernameOrEmail = null,Object? password = null,}) {
  return _then(SessionUser(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,usernameOrEmail: null == usernameOrEmail ? _self.usernameOrEmail : usernameOrEmail // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
