// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'records_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordsState {

 IMap<String, IList<RecordModel>> get byCollectionName;
/// Create a copy of RecordsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordsStateCopyWith<RecordsState> get copyWith => _$RecordsStateCopyWithImpl<RecordsState>(this as RecordsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordsState&&(identical(other.byCollectionName, byCollectionName) || other.byCollectionName == byCollectionName));
}


@override
int get hashCode => Object.hash(runtimeType,byCollectionName);

@override
String toString() {
  return 'RecordsState(byCollectionName: $byCollectionName)';
}


}

/// @nodoc
abstract mixin class $RecordsStateCopyWith<$Res>  {
  factory $RecordsStateCopyWith(RecordsState value, $Res Function(RecordsState) _then) = _$RecordsStateCopyWithImpl;
@useResult
$Res call({
 IMap<String, IList<RecordModel>> byCollectionName
});




}
/// @nodoc
class _$RecordsStateCopyWithImpl<$Res>
    implements $RecordsStateCopyWith<$Res> {
  _$RecordsStateCopyWithImpl(this._self, this._then);

  final RecordsState _self;
  final $Res Function(RecordsState) _then;

/// Create a copy of RecordsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? byCollectionName = null,}) {
  return _then(_self.copyWith(
byCollectionName: null == byCollectionName ? _self.byCollectionName : byCollectionName // ignore: cast_nullable_to_non_nullable
as IMap<String, IList<RecordModel>>,
  ));
}

}



/// @nodoc


class _RecordsState implements RecordsState {
  const _RecordsState({this.byCollectionName = const IMapConst({})});
  

@override@JsonKey() final  IMap<String, IList<RecordModel>> byCollectionName;

/// Create a copy of RecordsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordsStateCopyWith<_RecordsState> get copyWith => __$RecordsStateCopyWithImpl<_RecordsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordsState&&(identical(other.byCollectionName, byCollectionName) || other.byCollectionName == byCollectionName));
}


@override
int get hashCode => Object.hash(runtimeType,byCollectionName);

@override
String toString() {
  return 'RecordsState(byCollectionName: $byCollectionName)';
}


}

/// @nodoc
abstract mixin class _$RecordsStateCopyWith<$Res> implements $RecordsStateCopyWith<$Res> {
  factory _$RecordsStateCopyWith(_RecordsState value, $Res Function(_RecordsState) _then) = __$RecordsStateCopyWithImpl;
@override @useResult
$Res call({
 IMap<String, IList<RecordModel>> byCollectionName
});




}
/// @nodoc
class __$RecordsStateCopyWithImpl<$Res>
    implements _$RecordsStateCopyWith<$Res> {
  __$RecordsStateCopyWithImpl(this._self, this._then);

  final _RecordsState _self;
  final $Res Function(_RecordsState) _then;

/// Create a copy of RecordsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? byCollectionName = null,}) {
  return _then(_RecordsState(
byCollectionName: null == byCollectionName ? _self.byCollectionName : byCollectionName // ignore: cast_nullable_to_non_nullable
as IMap<String, IList<RecordModel>>,
  ));
}


}

// dart format on
