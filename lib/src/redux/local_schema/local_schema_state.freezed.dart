// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_schema_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalSchemaState {

 IMap<String, CollectionModel> get byId; IList<String> get sorted;
/// Create a copy of LocalSchemaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalSchemaStateCopyWith<LocalSchemaState> get copyWith => _$LocalSchemaStateCopyWithImpl<LocalSchemaState>(this as LocalSchemaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalSchemaState&&(identical(other.byId, byId) || other.byId == byId)&&const DeepCollectionEquality().equals(other.sorted, sorted));
}


@override
int get hashCode => Object.hash(runtimeType,byId,const DeepCollectionEquality().hash(sorted));

@override
String toString() {
  return 'LocalSchemaState(byId: $byId, sorted: $sorted)';
}


}

/// @nodoc
abstract mixin class $LocalSchemaStateCopyWith<$Res>  {
  factory $LocalSchemaStateCopyWith(LocalSchemaState value, $Res Function(LocalSchemaState) _then) = _$LocalSchemaStateCopyWithImpl;
@useResult
$Res call({
 IMap<String, CollectionModel> byId, IList<String> sorted
});




}
/// @nodoc
class _$LocalSchemaStateCopyWithImpl<$Res>
    implements $LocalSchemaStateCopyWith<$Res> {
  _$LocalSchemaStateCopyWithImpl(this._self, this._then);

  final LocalSchemaState _self;
  final $Res Function(LocalSchemaState) _then;

/// Create a copy of LocalSchemaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? byId = null,Object? sorted = null,}) {
  return _then(_self.copyWith(
byId: null == byId ? _self.byId : byId // ignore: cast_nullable_to_non_nullable
as IMap<String, CollectionModel>,sorted: null == sorted ? _self.sorted : sorted // ignore: cast_nullable_to_non_nullable
as IList<String>,
  ));
}

}



/// @nodoc


class _LocalSchemaState implements LocalSchemaState {
  const _LocalSchemaState({this.byId = const IMapConst({}), this.sorted = const IListConst([])});
  

@override@JsonKey() final  IMap<String, CollectionModel> byId;
@override@JsonKey() final  IList<String> sorted;

/// Create a copy of LocalSchemaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalSchemaStateCopyWith<_LocalSchemaState> get copyWith => __$LocalSchemaStateCopyWithImpl<_LocalSchemaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalSchemaState&&(identical(other.byId, byId) || other.byId == byId)&&const DeepCollectionEquality().equals(other.sorted, sorted));
}


@override
int get hashCode => Object.hash(runtimeType,byId,const DeepCollectionEquality().hash(sorted));

@override
String toString() {
  return 'LocalSchemaState(byId: $byId, sorted: $sorted)';
}


}

/// @nodoc
abstract mixin class _$LocalSchemaStateCopyWith<$Res> implements $LocalSchemaStateCopyWith<$Res> {
  factory _$LocalSchemaStateCopyWith(_LocalSchemaState value, $Res Function(_LocalSchemaState) _then) = __$LocalSchemaStateCopyWithImpl;
@override @useResult
$Res call({
 IMap<String, CollectionModel> byId, IList<String> sorted
});




}
/// @nodoc
class __$LocalSchemaStateCopyWithImpl<$Res>
    implements _$LocalSchemaStateCopyWith<$Res> {
  __$LocalSchemaStateCopyWithImpl(this._self, this._then);

  final _LocalSchemaState _self;
  final $Res Function(_LocalSchemaState) _then;

/// Create a copy of LocalSchemaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? byId = null,Object? sorted = null,}) {
  return _then(_LocalSchemaState(
byId: null == byId ? _self.byId : byId // ignore: cast_nullable_to_non_nullable
as IMap<String, CollectionModel>,sorted: null == sorted ? _self.sorted : sorted // ignore: cast_nullable_to_non_nullable
as IList<String>,
  ));
}


}

// dart format on
