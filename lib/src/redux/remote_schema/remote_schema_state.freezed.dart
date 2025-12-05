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

 List<CollectionModel>? get collections;
/// Create a copy of RemoteSchemaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteSchemaStateCopyWith<RemoteSchemaState> get copyWith => _$RemoteSchemaStateCopyWithImpl<RemoteSchemaState>(this as RemoteSchemaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteSchemaState&&const DeepCollectionEquality().equals(other.collections, collections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(collections));

@override
String toString() {
  return 'RemoteSchemaState(collections: $collections)';
}


}

/// @nodoc
abstract mixin class $RemoteSchemaStateCopyWith<$Res>  {
  factory $RemoteSchemaStateCopyWith(RemoteSchemaState value, $Res Function(RemoteSchemaState) _then) = _$RemoteSchemaStateCopyWithImpl;
@useResult
$Res call({
 List<CollectionModel>? collections
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
@pragma('vm:prefer-inline') @override $Res call({Object? collections = freezed,}) {
  return _then(_self.copyWith(
collections: freezed == collections ? _self.collections : collections // ignore: cast_nullable_to_non_nullable
as List<CollectionModel>?,
  ));
}

}



/// @nodoc


class _RemoteSchemaState implements RemoteSchemaState {
  const _RemoteSchemaState({final  List<CollectionModel>? collections}): _collections = collections;
  

 final  List<CollectionModel>? _collections;
@override List<CollectionModel>? get collections {
  final value = _collections;
  if (value == null) return null;
  if (_collections is EqualUnmodifiableListView) return _collections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RemoteSchemaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteSchemaStateCopyWith<_RemoteSchemaState> get copyWith => __$RemoteSchemaStateCopyWithImpl<_RemoteSchemaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteSchemaState&&const DeepCollectionEquality().equals(other._collections, _collections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_collections));

@override
String toString() {
  return 'RemoteSchemaState(collections: $collections)';
}


}

/// @nodoc
abstract mixin class _$RemoteSchemaStateCopyWith<$Res> implements $RemoteSchemaStateCopyWith<$Res> {
  factory _$RemoteSchemaStateCopyWith(_RemoteSchemaState value, $Res Function(_RemoteSchemaState) _then) = __$RemoteSchemaStateCopyWithImpl;
@override @useResult
$Res call({
 List<CollectionModel>? collections
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
@override @pragma('vm:prefer-inline') $Res call({Object? collections = freezed,}) {
  return _then(_RemoteSchemaState(
collections: freezed == collections ? _self._collections : collections // ignore: cast_nullable_to_non_nullable
as List<CollectionModel>?,
  ));
}


}

// dart format on
