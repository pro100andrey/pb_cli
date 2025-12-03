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

/// The current working directory.
 WorkDirState get workDir;/// The environment state (loaded from .env file).
 EnvState get env;/// The configuration state (loaded from config file).
 ConfigState get config;/// The session state (active user credentials).
 SessionState get session;/// The schema state (PocketBase collections).
 SchemaState get schema;
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStateCopyWith<AppState> get copyWith => _$AppStateCopyWithImpl<AppState>(this as AppState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppState&&(identical(other.workDir, workDir) || other.workDir == workDir)&&(identical(other.env, env) || other.env == env)&&(identical(other.config, config) || other.config == config)&&(identical(other.session, session) || other.session == session)&&(identical(other.schema, schema) || other.schema == schema));
}


@override
int get hashCode => Object.hash(runtimeType,workDir,env,config,session,schema);

@override
String toString() {
  return 'AppState(workDir: $workDir, env: $env, config: $config, session: $session, schema: $schema)';
}


}

/// @nodoc
abstract mixin class $AppStateCopyWith<$Res>  {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) _then) = _$AppStateCopyWithImpl;
@useResult
$Res call({
 WorkDirState workDir, EnvState env, ConfigState config, SessionState session, SchemaState schema
});


$WorkDirStateCopyWith<$Res> get workDir;$EnvStateCopyWith<$Res> get env;$ConfigStateCopyWith<$Res> get config;$SessionStateCopyWith<$Res> get session;$SchemaStateCopyWith<$Res> get schema;

}
/// @nodoc
class _$AppStateCopyWithImpl<$Res>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._self, this._then);

  final AppState _self;
  final $Res Function(AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workDir = null,Object? env = null,Object? config = null,Object? session = null,Object? schema = null,}) {
  return _then(_self.copyWith(
workDir: null == workDir ? _self.workDir : workDir // ignore: cast_nullable_to_non_nullable
as WorkDirState,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as EnvState,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as ConfigState,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SessionState,schema: null == schema ? _self.schema : schema // ignore: cast_nullable_to_non_nullable
as SchemaState,
  ));
}
/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkDirStateCopyWith<$Res> get workDir {
  
  return $WorkDirStateCopyWith<$Res>(_self.workDir, (value) {
    return _then(_self.copyWith(workDir: value));
  });
}/// Create a copy of AppState
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
}/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionStateCopyWith<$Res> get session {
  
  return $SessionStateCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SchemaStateCopyWith<$Res> get schema {
  
  return $SchemaStateCopyWith<$Res>(_self.schema, (value) {
    return _then(_self.copyWith(schema: value));
  });
}
}



/// @nodoc


class _AppState implements AppState {
  const _AppState({required this.workDir, required this.env, required this.config, required this.session, required this.schema});
  

/// The current working directory.
@override final  WorkDirState workDir;
/// The environment state (loaded from .env file).
@override final  EnvState env;
/// The configuration state (loaded from config file).
@override final  ConfigState config;
/// The session state (active user credentials).
@override final  SessionState session;
/// The schema state (PocketBase collections).
@override final  SchemaState schema;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStateCopyWith<_AppState> get copyWith => __$AppStateCopyWithImpl<_AppState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppState&&(identical(other.workDir, workDir) || other.workDir == workDir)&&(identical(other.env, env) || other.env == env)&&(identical(other.config, config) || other.config == config)&&(identical(other.session, session) || other.session == session)&&(identical(other.schema, schema) || other.schema == schema));
}


@override
int get hashCode => Object.hash(runtimeType,workDir,env,config,session,schema);

@override
String toString() {
  return 'AppState(workDir: $workDir, env: $env, config: $config, session: $session, schema: $schema)';
}


}

/// @nodoc
abstract mixin class _$AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$AppStateCopyWith(_AppState value, $Res Function(_AppState) _then) = __$AppStateCopyWithImpl;
@override @useResult
$Res call({
 WorkDirState workDir, EnvState env, ConfigState config, SessionState session, SchemaState schema
});


@override $WorkDirStateCopyWith<$Res> get workDir;@override $EnvStateCopyWith<$Res> get env;@override $ConfigStateCopyWith<$Res> get config;@override $SessionStateCopyWith<$Res> get session;@override $SchemaStateCopyWith<$Res> get schema;

}
/// @nodoc
class __$AppStateCopyWithImpl<$Res>
    implements _$AppStateCopyWith<$Res> {
  __$AppStateCopyWithImpl(this._self, this._then);

  final _AppState _self;
  final $Res Function(_AppState) _then;

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workDir = null,Object? env = null,Object? config = null,Object? session = null,Object? schema = null,}) {
  return _then(_AppState(
workDir: null == workDir ? _self.workDir : workDir // ignore: cast_nullable_to_non_nullable
as WorkDirState,env: null == env ? _self.env : env // ignore: cast_nullable_to_non_nullable
as EnvState,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as ConfigState,session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as SessionState,schema: null == schema ? _self.schema : schema // ignore: cast_nullable_to_non_nullable
as SchemaState,
  ));
}

/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkDirStateCopyWith<$Res> get workDir {
  
  return $WorkDirStateCopyWith<$Res>(_self.workDir, (value) {
    return _then(_self.copyWith(workDir: value));
  });
}/// Create a copy of AppState
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
}/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionStateCopyWith<$Res> get session {
  
  return $SessionStateCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AppState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SchemaStateCopyWith<$Res> get schema {
  
  return $SchemaStateCopyWith<$Res>(_self.schema, (value) {
    return _then(_self.copyWith(schema: value));
  });
}
}

// dart format on
