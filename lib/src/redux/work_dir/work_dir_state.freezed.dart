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





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkDirState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WorkDirState()';
}


}

/// @nodoc
class $WorkDirStateCopyWith<$Res>  {
$WorkDirStateCopyWith(WorkDirState _, $Res Function(WorkDirState) __);
}



/// @nodoc


class UnresolvedWorkDir implements WorkDirState {
  const UnresolvedWorkDir();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnresolvedWorkDir);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WorkDirState.unresolved()';
}


}




/// @nodoc


class ResolvedWorkDir implements WorkDirState {
  const ResolvedWorkDir({required this.path, required this.commandContext});
  

 final  DirectoryPath path;
 final  CommandContext commandContext;

/// Create a copy of WorkDirState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResolvedWorkDirCopyWith<ResolvedWorkDir> get copyWith => _$ResolvedWorkDirCopyWithImpl<ResolvedWorkDir>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResolvedWorkDir&&(identical(other.path, path) || other.path == path)&&(identical(other.commandContext, commandContext) || other.commandContext == commandContext));
}


@override
int get hashCode => Object.hash(runtimeType,path,commandContext);

@override
String toString() {
  return 'WorkDirState.resolved(path: $path, commandContext: $commandContext)';
}


}

/// @nodoc
abstract mixin class $ResolvedWorkDirCopyWith<$Res> implements $WorkDirStateCopyWith<$Res> {
  factory $ResolvedWorkDirCopyWith(ResolvedWorkDir value, $Res Function(ResolvedWorkDir) _then) = _$ResolvedWorkDirCopyWithImpl;
@useResult
$Res call({
 DirectoryPath path, CommandContext commandContext
});




}
/// @nodoc
class _$ResolvedWorkDirCopyWithImpl<$Res>
    implements $ResolvedWorkDirCopyWith<$Res> {
  _$ResolvedWorkDirCopyWithImpl(this._self, this._then);

  final ResolvedWorkDir _self;
  final $Res Function(ResolvedWorkDir) _then;

/// Create a copy of WorkDirState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? path = null,Object? commandContext = null,}) {
  return _then(ResolvedWorkDir(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as DirectoryPath,commandContext: null == commandContext ? _self.commandContext : commandContext // ignore: cast_nullable_to_non_nullable
as CommandContext,
  ));
}


}

// dart format on
