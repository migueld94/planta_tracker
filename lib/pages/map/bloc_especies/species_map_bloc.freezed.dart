// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_map_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PlantsMapEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(LatLng northEast, LatLng southWest)
        loadMoreByBoundries,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(LatLng northEast, LatLng southWest)? loadMoreByBoundries,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(LatLng northEast, LatLng southWest)? loadMoreByBoundries,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_LoadMoreByBoundries value) loadMoreByBoundries,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_LoadMoreByBoundries value)? loadMoreByBoundries,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_LoadMoreByBoundries value)? loadMoreByBoundries,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantsMapEventCopyWith<$Res> {
  factory $PlantsMapEventCopyWith(
          PlantsMapEvent value, $Res Function(PlantsMapEvent) then) =
      _$PlantsMapEventCopyWithImpl<$Res, PlantsMapEvent>;
}

/// @nodoc
class _$PlantsMapEventCopyWithImpl<$Res, $Val extends PlantsMapEvent>
    implements $PlantsMapEventCopyWith<$Res> {
  _$PlantsMapEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadImplCopyWith<$Res> {
  factory _$$LoadImplCopyWith(
          _$LoadImpl value, $Res Function(_$LoadImpl) then) =
      __$$LoadImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadImplCopyWithImpl<$Res>
    extends _$PlantsMapEventCopyWithImpl<$Res, _$LoadImpl>
    implements _$$LoadImplCopyWith<$Res> {
  __$$LoadImplCopyWithImpl(_$LoadImpl _value, $Res Function(_$LoadImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadImpl implements _Load {
  const _$LoadImpl();

  @override
  String toString() {
    return 'PlantsMapEvent.load()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(LatLng northEast, LatLng southWest)
        loadMoreByBoundries,
  }) {
    return load();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(LatLng northEast, LatLng southWest)? loadMoreByBoundries,
  }) {
    return load?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(LatLng northEast, LatLng southWest)? loadMoreByBoundries,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_LoadMoreByBoundries value) loadMoreByBoundries,
  }) {
    return load(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_LoadMoreByBoundries value)? loadMoreByBoundries,
  }) {
    return load?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_LoadMoreByBoundries value)? loadMoreByBoundries,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load(this);
    }
    return orElse();
  }
}

abstract class _Load implements PlantsMapEvent {
  const factory _Load() = _$LoadImpl;
}

/// @nodoc
abstract class _$$LoadMoreByBoundriesImplCopyWith<$Res> {
  factory _$$LoadMoreByBoundriesImplCopyWith(_$LoadMoreByBoundriesImpl value,
          $Res Function(_$LoadMoreByBoundriesImpl) then) =
      __$$LoadMoreByBoundriesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({LatLng northEast, LatLng southWest});
}

/// @nodoc
class __$$LoadMoreByBoundriesImplCopyWithImpl<$Res>
    extends _$PlantsMapEventCopyWithImpl<$Res, _$LoadMoreByBoundriesImpl>
    implements _$$LoadMoreByBoundriesImplCopyWith<$Res> {
  __$$LoadMoreByBoundriesImplCopyWithImpl(_$LoadMoreByBoundriesImpl _value,
      $Res Function(_$LoadMoreByBoundriesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? northEast = null,
    Object? southWest = null,
  }) {
    return _then(_$LoadMoreByBoundriesImpl(
      null == northEast
          ? _value.northEast
          : northEast // ignore: cast_nullable_to_non_nullable
              as LatLng,
      null == southWest
          ? _value.southWest
          : southWest // ignore: cast_nullable_to_non_nullable
              as LatLng,
    ));
  }
}

/// @nodoc

class _$LoadMoreByBoundriesImpl implements _LoadMoreByBoundries {
  const _$LoadMoreByBoundriesImpl(this.northEast, this.southWest);

  @override
  final LatLng northEast;
  @override
  final LatLng southWest;

  @override
  String toString() {
    return 'PlantsMapEvent.loadMoreByBoundries(northEast: $northEast, southWest: $southWest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadMoreByBoundriesImpl &&
            (identical(other.northEast, northEast) ||
                other.northEast == northEast) &&
            (identical(other.southWest, southWest) ||
                other.southWest == southWest));
  }

  @override
  int get hashCode => Object.hash(runtimeType, northEast, southWest);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadMoreByBoundriesImplCopyWith<_$LoadMoreByBoundriesImpl> get copyWith =>
      __$$LoadMoreByBoundriesImplCopyWithImpl<_$LoadMoreByBoundriesImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(LatLng northEast, LatLng southWest)
        loadMoreByBoundries,
  }) {
    return loadMoreByBoundries(northEast, southWest);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(LatLng northEast, LatLng southWest)? loadMoreByBoundries,
  }) {
    return loadMoreByBoundries?.call(northEast, southWest);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(LatLng northEast, LatLng southWest)? loadMoreByBoundries,
    required TResult orElse(),
  }) {
    if (loadMoreByBoundries != null) {
      return loadMoreByBoundries(northEast, southWest);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Load value) load,
    required TResult Function(_LoadMoreByBoundries value) loadMoreByBoundries,
  }) {
    return loadMoreByBoundries(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Load value)? load,
    TResult? Function(_LoadMoreByBoundries value)? loadMoreByBoundries,
  }) {
    return loadMoreByBoundries?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Load value)? load,
    TResult Function(_LoadMoreByBoundries value)? loadMoreByBoundries,
    required TResult orElse(),
  }) {
    if (loadMoreByBoundries != null) {
      return loadMoreByBoundries(this);
    }
    return orElse();
  }
}

abstract class _LoadMoreByBoundries implements PlantsMapEvent {
  const factory _LoadMoreByBoundries(
          final LatLng northEast, final LatLng southWest) =
      _$LoadMoreByBoundriesImpl;

  LatLng get northEast;
  LatLng get southWest;
  @JsonKey(ignore: true)
  _$$LoadMoreByBoundriesImplCopyWith<_$LoadMoreByBoundriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlantsMapState {
  LatLng get location => throw _privateConstructorUsedError;
  LatLng? get userLocation => throw _privateConstructorUsedError;
  LatLng get northEast => throw _privateConstructorUsedError;
  LatLng get southWest => throw _privateConstructorUsedError;
  List<Plant> get plants => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlantsMapStateCopyWith<PlantsMapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlantsMapStateCopyWith<$Res> {
  factory $PlantsMapStateCopyWith(
          PlantsMapState value, $Res Function(PlantsMapState) then) =
      _$PlantsMapStateCopyWithImpl<$Res, PlantsMapState>;
  @useResult
  $Res call(
      {LatLng location,
      LatLng? userLocation,
      LatLng northEast,
      LatLng southWest,
      List<Plant> plants});
}

/// @nodoc
class _$PlantsMapStateCopyWithImpl<$Res, $Val extends PlantsMapState>
    implements $PlantsMapStateCopyWith<$Res> {
  _$PlantsMapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? userLocation = freezed,
    Object? northEast = null,
    Object? southWest = null,
    Object? plants = null,
  }) {
    return _then(_value.copyWith(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      userLocation: freezed == userLocation
          ? _value.userLocation
          : userLocation // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      northEast: null == northEast
          ? _value.northEast
          : northEast // ignore: cast_nullable_to_non_nullable
              as LatLng,
      southWest: null == southWest
          ? _value.southWest
          : southWest // ignore: cast_nullable_to_non_nullable
              as LatLng,
      plants: null == plants
          ? _value.plants
          : plants // ignore: cast_nullable_to_non_nullable
              as List<Plant>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlantsMapStateImplCopyWith<$Res>
    implements $PlantsMapStateCopyWith<$Res> {
  factory _$$PlantsMapStateImplCopyWith(_$PlantsMapStateImpl value,
          $Res Function(_$PlantsMapStateImpl) then) =
      __$$PlantsMapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LatLng location,
      LatLng? userLocation,
      LatLng northEast,
      LatLng southWest,
      List<Plant> plants});
}

/// @nodoc
class __$$PlantsMapStateImplCopyWithImpl<$Res>
    extends _$PlantsMapStateCopyWithImpl<$Res, _$PlantsMapStateImpl>
    implements _$$PlantsMapStateImplCopyWith<$Res> {
  __$$PlantsMapStateImplCopyWithImpl(
      _$PlantsMapStateImpl _value, $Res Function(_$PlantsMapStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = null,
    Object? userLocation = freezed,
    Object? northEast = null,
    Object? southWest = null,
    Object? plants = null,
  }) {
    return _then(_$PlantsMapStateImpl(
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      userLocation: freezed == userLocation
          ? _value.userLocation
          : userLocation // ignore: cast_nullable_to_non_nullable
              as LatLng?,
      northEast: null == northEast
          ? _value.northEast
          : northEast // ignore: cast_nullable_to_non_nullable
              as LatLng,
      southWest: null == southWest
          ? _value.southWest
          : southWest // ignore: cast_nullable_to_non_nullable
              as LatLng,
      plants: null == plants
          ? _value._plants
          : plants // ignore: cast_nullable_to_non_nullable
              as List<Plant>,
    ));
  }
}

/// @nodoc

class _$PlantsMapStateImpl implements _PlantsMapState {
  const _$PlantsMapStateImpl(
      {this.location = const LatLng(23.11958, -82.397264),
      this.userLocation,
      this.northEast = const LatLng(23.61958, -82.597264),
      this.southWest = const LatLng(22.11958, -82.197264),
      final List<Plant> plants = const []})
      : _plants = plants;

  @override
  @JsonKey()
  final LatLng location;
  @override
  final LatLng? userLocation;
  @override
  @JsonKey()
  final LatLng northEast;
  @override
  @JsonKey()
  final LatLng southWest;
  final List<Plant> _plants;
  @override
  @JsonKey()
  List<Plant> get plants {
    if (_plants is EqualUnmodifiableListView) return _plants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_plants);
  }

  @override
  String toString() {
    return 'PlantsMapState(location: $location, userLocation: $userLocation, northEast: $northEast, southWest: $southWest, plants: $plants)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlantsMapStateImpl &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.userLocation, userLocation) ||
                other.userLocation == userLocation) &&
            (identical(other.northEast, northEast) ||
                other.northEast == northEast) &&
            (identical(other.southWest, southWest) ||
                other.southWest == southWest) &&
            const DeepCollectionEquality().equals(other._plants, _plants));
  }

  @override
  int get hashCode => Object.hash(runtimeType, location, userLocation,
      northEast, southWest, const DeepCollectionEquality().hash(_plants));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlantsMapStateImplCopyWith<_$PlantsMapStateImpl> get copyWith =>
      __$$PlantsMapStateImplCopyWithImpl<_$PlantsMapStateImpl>(
          this, _$identity);
}

abstract class _PlantsMapState implements PlantsMapState {
  const factory _PlantsMapState(
      {final LatLng location,
      final LatLng? userLocation,
      final LatLng northEast,
      final LatLng southWest,
      final List<Plant> plants}) = _$PlantsMapStateImpl;

  @override
  LatLng get location;
  @override
  LatLng? get userLocation;
  @override
  LatLng get northEast;
  @override
  LatLng get southWest;
  @override
  List<Plant> get plants;
  @override
  @JsonKey(ignore: true)
  _$$PlantsMapStateImplCopyWith<_$PlantsMapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
