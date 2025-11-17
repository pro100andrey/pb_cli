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

 String? get pbHost; String? get pbUsername; String? get pbPassword; String? get pbToken;
/// Create a copy of EnvState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnvStateCopyWith<EnvState> get copyWith => _$EnvStateCopyWithImpl<EnvState>(this as EnvState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnvState&&(identical(other.pbHost, pbHost) || other.pbHost == pbHost)&&(identical(other.pbUsername, pbUsername) || other.pbUsername == pbUsername)&&(identical(other.pbPassword, pbPassword) || other.pbPassword == pbPassword)&&(identical(other.pbToken, pbToken) || other.pbToken == pbToken));
}


@override
int get hashCode => Object.hash(runtimeType,pbHost,pbUsername,pbPassword,pbToken);

@override
String toString() {
  return 'EnvState(pbHost: $pbHost, pbUsername: $pbUsername, pbPassword: $pbPassword, pbToken: $pbToken)';
}


}

/// @nodoc
abstract mixin class $EnvStateCopyWith<$Res>  {
  factory $EnvStateCopyWith(EnvState value, $Res Function(EnvState) _then) = _$EnvStateCopyWithImpl;
@useResult
$Res call({
 String? pbHost, String? pbUsername, String? pbPassword, String? pbToken
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
@pragma('vm:prefer-inline') @override $Res call({Object? pbHost = freezed,Object? pbUsername = freezed,Object? pbPassword = freezed,Object? pbToken = freezed,}) {
  return _then(_self.copyWith(
pbHost: freezed == pbHost ? _self.pbHost : pbHost // ignore: cast_nullable_to_non_nullable
as String?,pbUsername: freezed == pbUsername ? _self.pbUsername : pbUsername // ignore: cast_nullable_to_non_nullable
as String?,pbPassword: freezed == pbPassword ? _self.pbPassword : pbPassword // ignore: cast_nullable_to_non_nullable
as String?,pbToken: freezed == pbToken ? _self.pbToken : pbToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}



/// @nodoc


class _EnvState implements EnvState {
  const _EnvState({this.pbHost, this.pbUsername, this.pbPassword, this.pbToken});
  

@override final  String? pbHost;
@override final  String? pbUsername;
@override final  String? pbPassword;
@override final  String? pbToken;

/// Create a copy of EnvState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnvStateCopyWith<_EnvState> get copyWith => __$EnvStateCopyWithImpl<_EnvState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnvState&&(identical(other.pbHost, pbHost) || other.pbHost == pbHost)&&(identical(other.pbUsername, pbUsername) || other.pbUsername == pbUsername)&&(identical(other.pbPassword, pbPassword) || other.pbPassword == pbPassword)&&(identical(other.pbToken, pbToken) || other.pbToken == pbToken));
}


@override
int get hashCode => Object.hash(runtimeType,pbHost,pbUsername,pbPassword,pbToken);

@override
String toString() {
  return 'EnvState(pbHost: $pbHost, pbUsername: $pbUsername, pbPassword: $pbPassword, pbToken: $pbToken)';
}


}

/// @nodoc
abstract mixin class _$EnvStateCopyWith<$Res> implements $EnvStateCopyWith<$Res> {
  factory _$EnvStateCopyWith(_EnvState value, $Res Function(_EnvState) _then) = __$EnvStateCopyWithImpl;
@override @useResult
$Res call({
 String? pbHost, String? pbUsername, String? pbPassword, String? pbToken
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
@override @pragma('vm:prefer-inline') $Res call({Object? pbHost = freezed,Object? pbUsername = freezed,Object? pbPassword = freezed,Object? pbToken = freezed,}) {
  return _then(_EnvState(
pbHost: freezed == pbHost ? _self.pbHost : pbHost // ignore: cast_nullable_to_non_nullable
as String?,pbUsername: freezed == pbUsername ? _self.pbUsername : pbUsername // ignore: cast_nullable_to_non_nullable
as String?,pbPassword: freezed == pbPassword ? _self.pbPassword : pbPassword // ignore: cast_nullable_to_non_nullable
as String?,pbToken: freezed == pbToken ? _self.pbToken : pbToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
