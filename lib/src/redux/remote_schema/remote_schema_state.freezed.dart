// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_schema_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteSchemaState {

 IMap<String, CollectionModel> get byId; IList<String> get sorted;
/// Create a copy of RemoteSchemaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteSchemaStateCopyWith<RemoteSchemaState> get copyWith => _$RemoteSchemaStateCopyWithImpl<RemoteSchemaState>(this as RemoteSchemaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteSchemaState&&(identical(other.byId, byId) || other.byId == byId)&&const DeepCollectionEquality().equals(other.sorted, sorted));
}


@override
int get hashCode => Object.hash(runtimeType,byId,const DeepCollectionEquality().hash(sorted));

@override
String toString() {
  return 'RemoteSchemaState(byId: $byId, sorted: $sorted)';
}


}

/// @nodoc
abstract mixin class $RemoteSchemaStateCopyWith<$Res>  {
  factory $RemoteSchemaStateCopyWith(RemoteSchemaState value, $Res Function(RemoteSchemaState) _then) = _$RemoteSchemaStateCopyWithImpl;
@useResult
$Res call({
 IMap<String, CollectionModel> byId, IList<String> sorted
});




}
/// @nodoc
class _$RemoteSchemaStateCopyWithImpl<$Res>
    implements $RemoteSchemaStateCopyWith<$Res> {
  _$RemoteSchemaStateCopyWithImpl(this._self, this._then);

  final RemoteSchemaState _self;
  final $Res Function(RemoteSchemaState) _then;

/// Create a copy of RemoteSchemaState
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


class _RemoteSchemaState implements RemoteSchemaState {
  const _RemoteSchemaState({this.byId = const IMapConst({}), this.sorted = const IListConst([])});
  

@override@JsonKey() final  IMap<String, CollectionModel> byId;
@override@JsonKey() final  IList<String> sorted;

/// Create a copy of RemoteSchemaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteSchemaStateCopyWith<_RemoteSchemaState> get copyWith => __$RemoteSchemaStateCopyWithImpl<_RemoteSchemaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteSchemaState&&(identical(other.byId, byId) || other.byId == byId)&&const DeepCollectionEquality().equals(other.sorted, sorted));
}


@override
int get hashCode => Object.hash(runtimeType,byId,const DeepCollectionEquality().hash(sorted));

@override
String toString() {
  return 'RemoteSchemaState(byId: $byId, sorted: $sorted)';
}


}

/// @nodoc
abstract mixin class _$RemoteSchemaStateCopyWith<$Res> implements $RemoteSchemaStateCopyWith<$Res> {
  factory _$RemoteSchemaStateCopyWith(_RemoteSchemaState value, $Res Function(_RemoteSchemaState) _then) = __$RemoteSchemaStateCopyWithImpl;
@override @useResult
$Res call({
 IMap<String, CollectionModel> byId, IList<String> sorted
});




}
/// @nodoc
class __$RemoteSchemaStateCopyWithImpl<$Res>
    implements _$RemoteSchemaStateCopyWith<$Res> {
  __$RemoteSchemaStateCopyWithImpl(this._self, this._then);

  final _RemoteSchemaState _self;
  final $Res Function(_RemoteSchemaState) _then;

/// Create a copy of RemoteSchemaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? byId = null,Object? sorted = null,}) {
  return _then(_RemoteSchemaState(
byId: null == byId ? _self.byId : byId // ignore: cast_nullable_to_non_nullable
as IMap<String, CollectionModel>,sorted: null == sorted ? _self.sorted : sorted // ignore: cast_nullable_to_non_nullable
as IList<String>,
  ));
}


}

// dart format on
