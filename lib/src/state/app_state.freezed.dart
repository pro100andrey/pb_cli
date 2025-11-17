// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppState {

 DirectoryPath? get workDir; EnvState get env; ConfigState get config;
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStateCopyWith<AppState> get copyWith => _$AppStateCopyWithImpl<AppState>(this as AppState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppState&&(identical(other.workDir, workDir) || other.workDir == workDir)&&(identical(other.env, env) || other.env == env)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,workDir,env,config);

@override
String toString() {
  return 'AppState(workDir: $workDir, env: $env, config: $config)';
}


}

/// @nodoc
abstract mixin class $AppStateCopyWith<$Res>  {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) _then) = _$AppStateCopyWithImpl;
@useResult
$Res call({
 DirectoryPath? workDir, EnvState env, ConfigState config
});


$EnvStateCopyWith<$Res> get env;$ConfigStateCopyWith<$Res> get config;

}
/// @nodoc
class _$AppStateCopyWithImpl<$Res>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._self, this._then);

  final AppState _self;
  final $Res Function(AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workDir = freezed,Object? env = null,Object? config = null,}) {
  return _then(_self.copyWith(
workDir: freezed == workDir ? _self.workDir : workDir // ignore: cast_nullable_to_non_nullable
as DirectoryPath?,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as EnvState,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as ConfigState,
  ));
}
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnvStateCopyWith<$Res> get env {
  
  return $EnvStateCopyWith<$Res>(_self.env, (value) {
    return _then(_self.copyWith(env: value));
  });
}/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConfigStateCopyWith<$Res> get config {
  
  return $ConfigStateCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}



/// @nodoc


class _AppState implements AppState {
  const _AppState({required this.workDir, required this.env, required this.config});
  

@override final  DirectoryPath? workDir;
@override final  EnvState env;
@override final  ConfigState config;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStateCopyWith<_AppState> get copyWith => __$AppStateCopyWithImpl<_AppState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppState&&(identical(other.workDir, workDir) || other.workDir == workDir)&&(identical(other.env, env) || other.env == env)&&(identical(other.config, config) || other.config == config));
}


@override
int get hashCode => Object.hash(runtimeType,workDir,env,config);

@override
String toString() {
  return 'AppState(workDir: $workDir, env: $env, config: $config)';
}


}

/// @nodoc
abstract mixin class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) _then) = __$AppStateCopyWithImpl;
@override @useResult
$Res call({
 DirectoryPath? workDir, EnvState env, ConfigState config
});


@override $EnvStateCopyWith<$Res> get env;@override $ConfigStateCopyWith<$Res> get config;

}
/// @nodoc
class __$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(this._self, this._then);

  final _AppState _self;
  final $Res Function(_AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workDir = freezed,Object? env = null,Object? config = null,}) {
  return _then(_AppState(
workDir: freezed == workDir ? _self.workDir : workDir // ignore: cast_nullable_to_non_nullable
as DirectoryPath?,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as EnvState,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as ConfigState,
  ));
}

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EnvStateCopyWith<$Res> get env {
  
  return $EnvStateCopyWith<$Res>(_self.env, (value) {
    return _then(_self.copyWith(env: value));
  });
}/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConfigStateCopyWith<$Res> get config {
  
  return $ConfigStateCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
