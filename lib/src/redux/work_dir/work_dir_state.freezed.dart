// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_dir_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkDirState {

 DirectoryPath? get path; ResolveWorkDirOption? get resolveOption;
/// Create a copy of WorkDirState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkDirStateCopyWith<WorkDirState> get copyWith => _$WorkDirStateCopyWithImpl<WorkDirState>(this as WorkDirState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkDirState&&(identical(other.path, path) || other.path == path)&&(identical(other.resolveOption, resolveOption) || other.resolveOption == resolveOption));
}


@override
int get hashCode => Object.hash(runtimeType,path,resolveOption);

@override
String toString() {
  return 'WorkDirState(path: $path, resolveOption: $resolveOption)';
}


}

/// @nodoc
abstract mixin class $WorkDirStateCopyWith<$Res>  {
  factory $WorkDirStateCopyWith(WorkDirState value, $Res Function(WorkDirState) _then) = _$WorkDirStateCopyWithImpl;
@useResult
$Res call({
 DirectoryPath? path, ResolveWorkDirOption? resolveOption
});




}
/// @nodoc
class _$WorkDirStateCopyWithImpl<$Res>
    implements $WorkDirStateCopyWith<$Res> {
  _$WorkDirStateCopyWithImpl(this._self, this._then);

  final WorkDirState _self;
  final $Res Function(WorkDirState) _then;

/// Create a copy of WorkDirState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = freezed,Object? resolveOption = freezed,}) {
  return _then(_self.copyWith(
path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as DirectoryPath?,resolveOption: freezed == resolveOption ? _self.resolveOption : resolveOption // ignore: cast_nullable_to_non_nullable
as ResolveWorkDirOption?,
  ));
}

}



/// @nodoc


class _WorkDirState implements WorkDirState {
  const _WorkDirState({this.path, this.resolveOption});
  

@override final  DirectoryPath? path;
@override final  ResolveWorkDirOption? resolveOption;

/// Create a copy of WorkDirState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkDirStateCopyWith<_WorkDirState> get copyWith => __$WorkDirStateCopyWithImpl<_WorkDirState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkDirState&&(identical(other.path, path) || other.path == path)&&(identical(other.resolveOption, resolveOption) || other.resolveOption == resolveOption));
}


@override
int get hashCode => Object.hash(runtimeType,path,resolveOption);

@override
String toString() {
  return 'WorkDirState(path: $path, resolveOption: $resolveOption)';
}


}

/// @nodoc
abstract mixin class _$WorkDirStateCopyWith<$Res> implements $WorkDirStateCopyWith<$Res> {
  factory _$WorkDirStateCopyWith(_WorkDirState value, $Res Function(_WorkDirState) _then) = __$WorkDirStateCopyWithImpl;
@override @useResult
$Res call({
 DirectoryPath? path, ResolveWorkDirOption? resolveOption
});




}
/// @nodoc
class __$WorkDirStateCopyWithImpl<$Res>
    implements _$WorkDirStateCopyWith<$Res> {
  __$WorkDirStateCopyWithImpl(this._self, this._then);

  final _WorkDirState _self;
  final $Res Function(_WorkDirState) _then;

/// Create a copy of WorkDirState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = freezed,Object? resolveOption = freezed,}) {
  return _then(_WorkDirState(
path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as DirectoryPath?,resolveOption: freezed == resolveOption ? _self.resolveOption : resolveOption // ignore: cast_nullable_to_non_nullable
as ResolveWorkDirOption?,
  ));
}


}

// dart format on
