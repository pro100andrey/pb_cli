// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'config_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConfigState {

/// Configuration data loaded from config.json file.
///
/// Empty if the file doesn't exist or hasn't been loaded yet.
 ConfigData get data;
/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigStateCopyWith<ConfigState> get copyWith => _$ConfigStateCopyWithImpl<ConfigState>(this as ConfigState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfigState&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ConfigState(data: $data)';
}


}

/// @nodoc
abstract mixin class $ConfigStateCopyWith<$Res>  {
  factory $ConfigStateCopyWith(ConfigState value, $Res Function(ConfigState) _then) = _$ConfigStateCopyWithImpl;
@useResult
$Res call({
 ConfigData data
});




}
/// @nodoc
class _$ConfigStateCopyWithImpl<$Res>
    implements $ConfigStateCopyWith<$Res> {
  _$ConfigStateCopyWithImpl(this._self, this._then);

  final ConfigState _self;
  final $Res Function(ConfigState) _then;

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(_self.copyWith(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ConfigData,
  ));
}

}



/// @nodoc


class _ConfigState extends ConfigState {
  const _ConfigState({this.data = const ConfigData.empty()}): super._();
  

/// Configuration data loaded from config.json file.
///
/// Empty if the file doesn't exist or hasn't been loaded yet.
@override@JsonKey() final  ConfigData data;

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigStateCopyWith<_ConfigState> get copyWith => __$ConfigStateCopyWithImpl<_ConfigState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfigState&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ConfigState(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ConfigStateCopyWith<$Res> implements $ConfigStateCopyWith<$Res> {
  factory _$ConfigStateCopyWith(_ConfigState value, $Res Function(_ConfigState) _then) = __$ConfigStateCopyWithImpl;
@override @useResult
$Res call({
 ConfigData data
});




}
/// @nodoc
class __$ConfigStateCopyWithImpl<$Res>
    implements _$ConfigStateCopyWith<$Res> {
  __$ConfigStateCopyWithImpl(this._self, this._then);

  final _ConfigState _self;
  final $Res Function(_ConfigState) _then;

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ConfigState(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ConfigData,
  ));
}


}

// dart format on
