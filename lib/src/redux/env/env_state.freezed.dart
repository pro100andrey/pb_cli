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

/// Raw key-value pairs loaded from .env file.
///
/// Empty if the file doesn't exist or hasn't been loaded yet.
 EnvData get data;
/// Create a copy of EnvState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnvStateCopyWith<EnvState> get copyWith => _$EnvStateCopyWithImpl<EnvState>(this as EnvState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnvState&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'EnvState(data: $data)';
}


}

/// @nodoc
abstract mixin class $EnvStateCopyWith<$Res>  {
  factory $EnvStateCopyWith(EnvState value, $Res Function(EnvState) _then) = _$EnvStateCopyWithImpl;
@useResult
$Res call({
 EnvData data
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
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EnvData,
  ));
}

}



/// @nodoc


class _EnvState extends EnvState {
  const _EnvState({this.data = const EnvData.empty()}): super._();
  

/// Raw key-value pairs loaded from .env file.
///
/// Empty if the file doesn't exist or hasn't been loaded yet.
@override@JsonKey() final  EnvData data;

/// Create a copy of EnvState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnvStateCopyWith<_EnvState> get copyWith => __$EnvStateCopyWithImpl<_EnvState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnvState&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'EnvState(data: $data)';
}


}

/// @nodoc
abstract mixin class _$EnvStateCopyWith<$Res> implements $EnvStateCopyWith<$Res> {
  factory _$EnvStateCopyWith(_EnvState value, $Res Function(_EnvState) _then) = __$EnvStateCopyWithImpl;
@override @useResult
$Res call({
 EnvData data
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
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_EnvState(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as EnvData,
  ));
}


}

// dart format on
