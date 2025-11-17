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

 List<String>? get managedCollections; CredentialsSource? get credentialsSource;
/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigStateCopyWith<ConfigState> get copyWith => _$ConfigStateCopyWithImpl<ConfigState>(this as ConfigState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConfigState&&const DeepCollectionEquality().equals(other.managedCollections, managedCollections)&&(identical(other.credentialsSource, credentialsSource) || other.credentialsSource == credentialsSource));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(managedCollections),credentialsSource);

@override
String toString() {
  return 'ConfigState(managedCollections: $managedCollections, credentialsSource: $credentialsSource)';
}


}

/// @nodoc
abstract mixin class $ConfigStateCopyWith<$Res>  {
  factory $ConfigStateCopyWith(ConfigState value, $Res Function(ConfigState) _then) = _$ConfigStateCopyWithImpl;
@useResult
$Res call({
 List<String>? managedCollections, CredentialsSource? credentialsSource
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
@pragma('vm:prefer-inline') @override $Res call({Object? managedCollections = freezed,Object? credentialsSource = freezed,}) {
  return _then(_self.copyWith(
managedCollections: freezed == managedCollections ? _self.managedCollections : managedCollections // ignore: cast_nullable_to_non_nullable
as List<String>?,credentialsSource: freezed == credentialsSource ? _self.credentialsSource : credentialsSource // ignore: cast_nullable_to_non_nullable
as CredentialsSource?,
  ));
}

}



/// @nodoc


class _ConfigState implements ConfigState {
  const _ConfigState({final  List<String>? managedCollections, this.credentialsSource}): _managedCollections = managedCollections;
  

 final  List<String>? _managedCollections;
@override List<String>? get managedCollections {
  final value = _managedCollections;
  if (value == null) return null;
  if (_managedCollections is EqualUnmodifiableListView) return _managedCollections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  CredentialsSource? credentialsSource;

/// Create a copy of ConfigState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigStateCopyWith<_ConfigState> get copyWith => __$ConfigStateCopyWithImpl<_ConfigState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConfigState&&const DeepCollectionEquality().equals(other._managedCollections, _managedCollections)&&(identical(other.credentialsSource, credentialsSource) || other.credentialsSource == credentialsSource));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_managedCollections),credentialsSource);

@override
String toString() {
  return 'ConfigState(managedCollections: $managedCollections, credentialsSource: $credentialsSource)';
}


}

/// @nodoc
abstract mixin class _$ConfigStateCopyWith<$Res> implements $ConfigStateCopyWith<$Res> {
  factory _$ConfigStateCopyWith(_ConfigState value, $Res Function(_ConfigState) _then) = __$ConfigStateCopyWithImpl;
@override @useResult
$Res call({
 List<String>? managedCollections, CredentialsSource? credentialsSource
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
@override @pragma('vm:prefer-inline') $Res call({Object? managedCollections = freezed,Object? credentialsSource = freezed,}) {
  return _then(_ConfigState(
managedCollections: freezed == managedCollections ? _self._managedCollections : managedCollections // ignore: cast_nullable_to_non_nullable
as List<String>?,credentialsSource: freezed == credentialsSource ? _self.credentialsSource : credentialsSource // ignore: cast_nullable_to_non_nullable
as CredentialsSource?,
  ));
}


}

// dart format on
