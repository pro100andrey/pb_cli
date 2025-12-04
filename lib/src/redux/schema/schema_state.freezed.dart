// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schema_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SchemaState {

 List<CollectionModel>? get collections;
/// Create a copy of SchemaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchemaStateCopyWith<SchemaState> get copyWith => _$SchemaStateCopyWithImpl<SchemaState>(this as SchemaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchemaState&&const DeepCollectionEquality().equals(other.collections, collections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(collections));

@override
String toString() {
  return 'SchemaState(collections: $collections)';
}


}

/// @nodoc
abstract mixin class $SchemaStateCopyWith<$Res>  {
  factory $SchemaStateCopyWith(SchemaState value, $Res Function(SchemaState) _then) = _$SchemaStateCopyWithImpl;
@useResult
$Res call({
 List<CollectionModel>? collections
});




}
/// @nodoc
class _$SchemaStateCopyWithImpl<$Res>
    implements $SchemaStateCopyWith<$Res> {
  _$SchemaStateCopyWithImpl(this._self, this._then);

  final SchemaState _self;
  final $Res Function(SchemaState) _then;

/// Create a copy of SchemaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? collections = freezed,}) {
  return _then(_self.copyWith(
collections: freezed == collections ? _self.collections : collections // ignore: cast_nullable_to_non_nullable
as List<CollectionModel>?,
  ));
}

}



/// @nodoc


class _SchemaState implements SchemaState {
  const _SchemaState({final  List<CollectionModel>? collections}): _collections = collections;
  

 final  List<CollectionModel>? _collections;
@override List<CollectionModel>? get collections {
  final value = _collections;
  if (value == null) return null;
  if (_collections is EqualUnmodifiableListView) return _collections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SchemaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchemaStateCopyWith<_SchemaState> get copyWith => __$SchemaStateCopyWithImpl<_SchemaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchemaState&&const DeepCollectionEquality().equals(other._collections, _collections));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_collections));

@override
String toString() {
  return 'SchemaState(collections: $collections)';
}


}

/// @nodoc
abstract mixin class _$SchemaStateCopyWith<$Res> implements $SchemaStateCopyWith<$Res> {
  factory _$SchemaStateCopyWith(_SchemaState value, $Res Function(_SchemaState) _then) = __$SchemaStateCopyWithImpl;
@override @useResult
$Res call({
 List<CollectionModel>? collections
});




}
/// @nodoc
class __$SchemaStateCopyWithImpl<$Res>
    implements _$SchemaStateCopyWith<$Res> {
  __$SchemaStateCopyWithImpl(this._self, this._then);

  final _SchemaState _self;
  final $Res Function(_SchemaState) _then;

/// Create a copy of SchemaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? collections = freezed,}) {
  return _then(_SchemaState(
collections: freezed == collections ? _self._collections : collections // ignore: cast_nullable_to_non_nullable
as List<CollectionModel>?,
  ));
}


}

// dart format on
