// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScanApiResponse _$ScanApiResponseFromJson(Map<String, dynamic> json) {
  return _ScanApiResponse.fromJson(json);
}

/// @nodoc
mixin _$ScanApiResponse {
  bool get success => throw _privateConstructorUsedError;
  ScanData get data => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Serializes this ScanApiResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanApiResponseCopyWith<ScanApiResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanApiResponseCopyWith<$Res> {
  factory $ScanApiResponseCopyWith(
          ScanApiResponse value, $Res Function(ScanApiResponse) then) =
      _$ScanApiResponseCopyWithImpl<$Res, ScanApiResponse>;
  @useResult
  $Res call({bool success, ScanData data, String? error});

  $ScanDataCopyWith<$Res> get data;
}

/// @nodoc
class _$ScanApiResponseCopyWithImpl<$Res, $Val extends ScanApiResponse>
    implements $ScanApiResponseCopyWith<$Res> {
  _$ScanApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ScanData,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ScanApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScanDataCopyWith<$Res> get data {
    return $ScanDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScanApiResponseImplCopyWith<$Res>
    implements $ScanApiResponseCopyWith<$Res> {
  factory _$$ScanApiResponseImplCopyWith(_$ScanApiResponseImpl value,
          $Res Function(_$ScanApiResponseImpl) then) =
      __$$ScanApiResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool success, ScanData data, String? error});

  @override
  $ScanDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$ScanApiResponseImplCopyWithImpl<$Res>
    extends _$ScanApiResponseCopyWithImpl<$Res, _$ScanApiResponseImpl>
    implements _$$ScanApiResponseImplCopyWith<$Res> {
  __$$ScanApiResponseImplCopyWithImpl(
      _$ScanApiResponseImpl _value, $Res Function(_$ScanApiResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? data = null,
    Object? error = freezed,
  }) {
    return _then(_$ScanApiResponseImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as ScanData,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanApiResponseImpl implements _ScanApiResponse {
  const _$ScanApiResponseImpl(
      {required this.success, required this.data, this.error});

  factory _$ScanApiResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanApiResponseImplFromJson(json);

  @override
  final bool success;
  @override
  final ScanData data;
  @override
  final String? error;

  @override
  String toString() {
    return 'ScanApiResponse(success: $success, data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanApiResponseImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, success, data, error);

  /// Create a copy of ScanApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanApiResponseImplCopyWith<_$ScanApiResponseImpl> get copyWith =>
      __$$ScanApiResponseImplCopyWithImpl<_$ScanApiResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanApiResponseImplToJson(
      this,
    );
  }
}

abstract class _ScanApiResponse implements ScanApiResponse {
  const factory _ScanApiResponse(
      {required final bool success,
      required final ScanData data,
      final String? error}) = _$ScanApiResponseImpl;

  factory _ScanApiResponse.fromJson(Map<String, dynamic> json) =
      _$ScanApiResponseImpl.fromJson;

  @override
  bool get success;
  @override
  ScanData get data;
  @override
  String? get error;

  /// Create a copy of ScanApiResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanApiResponseImplCopyWith<_$ScanApiResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanData _$ScanDataFromJson(Map<String, dynamic> json) {
  return _ScanData.fromJson(json);
}

/// @nodoc
mixin _$ScanData {
  @JsonKey(name: 'extractedItems')
  List<ExtractedItem> get extractedItems => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String get merchant => throw _privateConstructorUsedError;
  @JsonKey(name: 'betterOffers')
  List<BetterOffer> get betterOffers => throw _privateConstructorUsedError;
  @JsonKey(name: 'processingTime')
  int get processingTime => throw _privateConstructorUsedError;
  double get accuracy => throw _privateConstructorUsedError;

  /// Serializes this ScanData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanDataCopyWith<ScanData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanDataCopyWith<$Res> {
  factory $ScanDataCopyWith(ScanData value, $Res Function(ScanData) then) =
      _$ScanDataCopyWithImpl<$Res, ScanData>;
  @useResult
  $Res call(
      {@JsonKey(name: 'extractedItems') List<ExtractedItem> extractedItems,
      double total,
      String merchant,
      @JsonKey(name: 'betterOffers') List<BetterOffer> betterOffers,
      @JsonKey(name: 'processingTime') int processingTime,
      double accuracy});
}

/// @nodoc
class _$ScanDataCopyWithImpl<$Res, $Val extends ScanData>
    implements $ScanDataCopyWith<$Res> {
  _$ScanDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? extractedItems = null,
    Object? total = null,
    Object? merchant = null,
    Object? betterOffers = null,
    Object? processingTime = null,
    Object? accuracy = null,
  }) {
    return _then(_value.copyWith(
      extractedItems: null == extractedItems
          ? _value.extractedItems
          : extractedItems // ignore: cast_nullable_to_non_nullable
              as List<ExtractedItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      merchant: null == merchant
          ? _value.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String,
      betterOffers: null == betterOffers
          ? _value.betterOffers
          : betterOffers // ignore: cast_nullable_to_non_nullable
              as List<BetterOffer>,
      processingTime: null == processingTime
          ? _value.processingTime
          : processingTime // ignore: cast_nullable_to_non_nullable
              as int,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanDataImplCopyWith<$Res>
    implements $ScanDataCopyWith<$Res> {
  factory _$$ScanDataImplCopyWith(
          _$ScanDataImpl value, $Res Function(_$ScanDataImpl) then) =
      __$$ScanDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'extractedItems') List<ExtractedItem> extractedItems,
      double total,
      String merchant,
      @JsonKey(name: 'betterOffers') List<BetterOffer> betterOffers,
      @JsonKey(name: 'processingTime') int processingTime,
      double accuracy});
}

/// @nodoc
class __$$ScanDataImplCopyWithImpl<$Res>
    extends _$ScanDataCopyWithImpl<$Res, _$ScanDataImpl>
    implements _$$ScanDataImplCopyWith<$Res> {
  __$$ScanDataImplCopyWithImpl(
      _$ScanDataImpl _value, $Res Function(_$ScanDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? extractedItems = null,
    Object? total = null,
    Object? merchant = null,
    Object? betterOffers = null,
    Object? processingTime = null,
    Object? accuracy = null,
  }) {
    return _then(_$ScanDataImpl(
      extractedItems: null == extractedItems
          ? _value._extractedItems
          : extractedItems // ignore: cast_nullable_to_non_nullable
              as List<ExtractedItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      merchant: null == merchant
          ? _value.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String,
      betterOffers: null == betterOffers
          ? _value._betterOffers
          : betterOffers // ignore: cast_nullable_to_non_nullable
              as List<BetterOffer>,
      processingTime: null == processingTime
          ? _value.processingTime
          : processingTime // ignore: cast_nullable_to_non_nullable
              as int,
      accuracy: null == accuracy
          ? _value.accuracy
          : accuracy // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanDataImpl implements _ScanData {
  const _$ScanDataImpl(
      {@JsonKey(name: 'extractedItems')
      required final List<ExtractedItem> extractedItems,
      required this.total,
      required this.merchant,
      @JsonKey(name: 'betterOffers')
      required final List<BetterOffer> betterOffers,
      @JsonKey(name: 'processingTime') required this.processingTime,
      required this.accuracy})
      : _extractedItems = extractedItems,
        _betterOffers = betterOffers;

  factory _$ScanDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanDataImplFromJson(json);

  final List<ExtractedItem> _extractedItems;
  @override
  @JsonKey(name: 'extractedItems')
  List<ExtractedItem> get extractedItems {
    if (_extractedItems is EqualUnmodifiableListView) return _extractedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_extractedItems);
  }

  @override
  final double total;
  @override
  final String merchant;
  final List<BetterOffer> _betterOffers;
  @override
  @JsonKey(name: 'betterOffers')
  List<BetterOffer> get betterOffers {
    if (_betterOffers is EqualUnmodifiableListView) return _betterOffers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_betterOffers);
  }

  @override
  @JsonKey(name: 'processingTime')
  final int processingTime;
  @override
  final double accuracy;

  @override
  String toString() {
    return 'ScanData(extractedItems: $extractedItems, total: $total, merchant: $merchant, betterOffers: $betterOffers, processingTime: $processingTime, accuracy: $accuracy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanDataImpl &&
            const DeepCollectionEquality()
                .equals(other._extractedItems, _extractedItems) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            const DeepCollectionEquality()
                .equals(other._betterOffers, _betterOffers) &&
            (identical(other.processingTime, processingTime) ||
                other.processingTime == processingTime) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_extractedItems),
      total,
      merchant,
      const DeepCollectionEquality().hash(_betterOffers),
      processingTime,
      accuracy);

  /// Create a copy of ScanData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanDataImplCopyWith<_$ScanDataImpl> get copyWith =>
      __$$ScanDataImplCopyWithImpl<_$ScanDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanDataImplToJson(
      this,
    );
  }
}

abstract class _ScanData implements ScanData {
  const factory _ScanData(
      {@JsonKey(name: 'extractedItems')
      required final List<ExtractedItem> extractedItems,
      required final double total,
      required final String merchant,
      @JsonKey(name: 'betterOffers')
      required final List<BetterOffer> betterOffers,
      @JsonKey(name: 'processingTime') required final int processingTime,
      required final double accuracy}) = _$ScanDataImpl;

  factory _ScanData.fromJson(Map<String, dynamic> json) =
      _$ScanDataImpl.fromJson;

  @override
  @JsonKey(name: 'extractedItems')
  List<ExtractedItem> get extractedItems;
  @override
  double get total;
  @override
  String get merchant;
  @override
  @JsonKey(name: 'betterOffers')
  List<BetterOffer> get betterOffers;
  @override
  @JsonKey(name: 'processingTime')
  int get processingTime;
  @override
  double get accuracy;

  /// Create a copy of ScanData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanDataImplCopyWith<_$ScanDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExtractedItem _$ExtractedItemFromJson(Map<String, dynamic> json) {
  return _ExtractedItem.fromJson(json);
}

/// @nodoc
mixin _$ExtractedItem {
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  /// Serializes this ExtractedItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtractedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtractedItemCopyWith<ExtractedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractedItemCopyWith<$Res> {
  factory $ExtractedItemCopyWith(
          ExtractedItem value, $Res Function(ExtractedItem) then) =
      _$ExtractedItemCopyWithImpl<$Res, ExtractedItem>;
  @useResult
  $Res call({String name, double price, int quantity, double total});
}

/// @nodoc
class _$ExtractedItemCopyWithImpl<$Res, $Val extends ExtractedItem>
    implements $ExtractedItemCopyWith<$Res> {
  _$ExtractedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtractedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExtractedItemImplCopyWith<$Res>
    implements $ExtractedItemCopyWith<$Res> {
  factory _$$ExtractedItemImplCopyWith(
          _$ExtractedItemImpl value, $Res Function(_$ExtractedItemImpl) then) =
      __$$ExtractedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double price, int quantity, double total});
}

/// @nodoc
class __$$ExtractedItemImplCopyWithImpl<$Res>
    extends _$ExtractedItemCopyWithImpl<$Res, _$ExtractedItemImpl>
    implements _$$ExtractedItemImplCopyWith<$Res> {
  __$$ExtractedItemImplCopyWithImpl(
      _$ExtractedItemImpl _value, $Res Function(_$ExtractedItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExtractedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? price = null,
    Object? quantity = null,
    Object? total = null,
  }) {
    return _then(_$ExtractedItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtractedItemImpl implements _ExtractedItem {
  const _$ExtractedItemImpl(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.total});

  factory _$ExtractedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtractedItemImplFromJson(json);

  @override
  final String name;
  @override
  final double price;
  @override
  final int quantity;
  @override
  final double total;

  @override
  String toString() {
    return 'ExtractedItem(name: $name, price: $price, quantity: $quantity, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractedItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, price, quantity, total);

  /// Create a copy of ExtractedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractedItemImplCopyWith<_$ExtractedItemImpl> get copyWith =>
      __$$ExtractedItemImplCopyWithImpl<_$ExtractedItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtractedItemImplToJson(
      this,
    );
  }
}

abstract class _ExtractedItem implements ExtractedItem {
  const factory _ExtractedItem(
      {required final String name,
      required final double price,
      required final int quantity,
      required final double total}) = _$ExtractedItemImpl;

  factory _ExtractedItem.fromJson(Map<String, dynamic> json) =
      _$ExtractedItemImpl.fromJson;

  @override
  String get name;
  @override
  double get price;
  @override
  int get quantity;
  @override
  double get total;

  /// Create a copy of ExtractedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtractedItemImplCopyWith<_$ExtractedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BetterOffer _$BetterOfferFromJson(Map<String, dynamic> json) {
  return _BetterOffer.fromJson(json);
}

/// @nodoc
mixin _$BetterOffer {
  @JsonKey(name: 'originalItem')
  ExtractedItem get originalItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'betterOffers')
  List<OfferDetail> get betterOffers => throw _privateConstructorUsedError;

  /// Serializes this BetterOffer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BetterOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BetterOfferCopyWith<BetterOffer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BetterOfferCopyWith<$Res> {
  factory $BetterOfferCopyWith(
          BetterOffer value, $Res Function(BetterOffer) then) =
      _$BetterOfferCopyWithImpl<$Res, BetterOffer>;
  @useResult
  $Res call(
      {@JsonKey(name: 'originalItem') ExtractedItem originalItem,
      @JsonKey(name: 'betterOffers') List<OfferDetail> betterOffers});

  $ExtractedItemCopyWith<$Res> get originalItem;
}

/// @nodoc
class _$BetterOfferCopyWithImpl<$Res, $Val extends BetterOffer>
    implements $BetterOfferCopyWith<$Res> {
  _$BetterOfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BetterOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalItem = null,
    Object? betterOffers = null,
  }) {
    return _then(_value.copyWith(
      originalItem: null == originalItem
          ? _value.originalItem
          : originalItem // ignore: cast_nullable_to_non_nullable
              as ExtractedItem,
      betterOffers: null == betterOffers
          ? _value.betterOffers
          : betterOffers // ignore: cast_nullable_to_non_nullable
              as List<OfferDetail>,
    ) as $Val);
  }

  /// Create a copy of BetterOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExtractedItemCopyWith<$Res> get originalItem {
    return $ExtractedItemCopyWith<$Res>(_value.originalItem, (value) {
      return _then(_value.copyWith(originalItem: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BetterOfferImplCopyWith<$Res>
    implements $BetterOfferCopyWith<$Res> {
  factory _$$BetterOfferImplCopyWith(
          _$BetterOfferImpl value, $Res Function(_$BetterOfferImpl) then) =
      __$$BetterOfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'originalItem') ExtractedItem originalItem,
      @JsonKey(name: 'betterOffers') List<OfferDetail> betterOffers});

  @override
  $ExtractedItemCopyWith<$Res> get originalItem;
}

/// @nodoc
class __$$BetterOfferImplCopyWithImpl<$Res>
    extends _$BetterOfferCopyWithImpl<$Res, _$BetterOfferImpl>
    implements _$$BetterOfferImplCopyWith<$Res> {
  __$$BetterOfferImplCopyWithImpl(
      _$BetterOfferImpl _value, $Res Function(_$BetterOfferImpl) _then)
      : super(_value, _then);

  /// Create a copy of BetterOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalItem = null,
    Object? betterOffers = null,
  }) {
    return _then(_$BetterOfferImpl(
      originalItem: null == originalItem
          ? _value.originalItem
          : originalItem // ignore: cast_nullable_to_non_nullable
              as ExtractedItem,
      betterOffers: null == betterOffers
          ? _value._betterOffers
          : betterOffers // ignore: cast_nullable_to_non_nullable
              as List<OfferDetail>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BetterOfferImpl implements _BetterOffer {
  const _$BetterOfferImpl(
      {@JsonKey(name: 'originalItem') required this.originalItem,
      @JsonKey(name: 'betterOffers')
      required final List<OfferDetail> betterOffers})
      : _betterOffers = betterOffers;

  factory _$BetterOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$BetterOfferImplFromJson(json);

  @override
  @JsonKey(name: 'originalItem')
  final ExtractedItem originalItem;
  final List<OfferDetail> _betterOffers;
  @override
  @JsonKey(name: 'betterOffers')
  List<OfferDetail> get betterOffers {
    if (_betterOffers is EqualUnmodifiableListView) return _betterOffers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_betterOffers);
  }

  @override
  String toString() {
    return 'BetterOffer(originalItem: $originalItem, betterOffers: $betterOffers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BetterOfferImpl &&
            (identical(other.originalItem, originalItem) ||
                other.originalItem == originalItem) &&
            const DeepCollectionEquality()
                .equals(other._betterOffers, _betterOffers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, originalItem,
      const DeepCollectionEquality().hash(_betterOffers));

  /// Create a copy of BetterOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BetterOfferImplCopyWith<_$BetterOfferImpl> get copyWith =>
      __$$BetterOfferImplCopyWithImpl<_$BetterOfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BetterOfferImplToJson(
      this,
    );
  }
}

abstract class _BetterOffer implements BetterOffer {
  const factory _BetterOffer(
      {@JsonKey(name: 'originalItem') required final ExtractedItem originalItem,
      @JsonKey(name: 'betterOffers')
      required final List<OfferDetail> betterOffers}) = _$BetterOfferImpl;

  factory _BetterOffer.fromJson(Map<String, dynamic> json) =
      _$BetterOfferImpl.fromJson;

  @override
  @JsonKey(name: 'originalItem')
  ExtractedItem get originalItem;
  @override
  @JsonKey(name: 'betterOffers')
  List<OfferDetail> get betterOffers;

  /// Create a copy of BetterOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BetterOfferImplCopyWith<_$BetterOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OfferDetail _$OfferDetailFromJson(Map<String, dynamic> json) {
  return _OfferDetail.fromJson(json);
}

/// @nodoc
mixin _$OfferDetail {
  @JsonKey(name: 'productId')
  String get productId => throw _privateConstructorUsedError;
  @JsonKey(name: 'productName')
  String get productName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shopName')
  String get shopName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shopAddress')
  String get shopAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'shopRating')
  String get shopRating => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get savings => throw _privateConstructorUsedError;
  @JsonKey(name: 'savingsPercentage')
  String get savingsPercentage => throw _privateConstructorUsedError;

  /// Serializes this OfferDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OfferDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfferDetailCopyWith<OfferDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfferDetailCopyWith<$Res> {
  factory $OfferDetailCopyWith(
          OfferDetail value, $Res Function(OfferDetail) then) =
      _$OfferDetailCopyWithImpl<$Res, OfferDetail>;
  @useResult
  $Res call(
      {@JsonKey(name: 'productId') String productId,
      @JsonKey(name: 'productName') String productName,
      @JsonKey(name: 'shopName') String shopName,
      @JsonKey(name: 'shopAddress') String shopAddress,
      @JsonKey(name: 'shopRating') String shopRating,
      double price,
      double savings,
      @JsonKey(name: 'savingsPercentage') String savingsPercentage});
}

/// @nodoc
class _$OfferDetailCopyWithImpl<$Res, $Val extends OfferDetail>
    implements $OfferDetailCopyWith<$Res> {
  _$OfferDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfferDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? shopName = null,
    Object? shopAddress = null,
    Object? shopRating = null,
    Object? price = null,
    Object? savings = null,
    Object? savingsPercentage = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      shopAddress: null == shopAddress
          ? _value.shopAddress
          : shopAddress // ignore: cast_nullable_to_non_nullable
              as String,
      shopRating: null == shopRating
          ? _value.shopRating
          : shopRating // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      savings: null == savings
          ? _value.savings
          : savings // ignore: cast_nullable_to_non_nullable
              as double,
      savingsPercentage: null == savingsPercentage
          ? _value.savingsPercentage
          : savingsPercentage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OfferDetailImplCopyWith<$Res>
    implements $OfferDetailCopyWith<$Res> {
  factory _$$OfferDetailImplCopyWith(
          _$OfferDetailImpl value, $Res Function(_$OfferDetailImpl) then) =
      __$$OfferDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'productId') String productId,
      @JsonKey(name: 'productName') String productName,
      @JsonKey(name: 'shopName') String shopName,
      @JsonKey(name: 'shopAddress') String shopAddress,
      @JsonKey(name: 'shopRating') String shopRating,
      double price,
      double savings,
      @JsonKey(name: 'savingsPercentage') String savingsPercentage});
}

/// @nodoc
class __$$OfferDetailImplCopyWithImpl<$Res>
    extends _$OfferDetailCopyWithImpl<$Res, _$OfferDetailImpl>
    implements _$$OfferDetailImplCopyWith<$Res> {
  __$$OfferDetailImplCopyWithImpl(
      _$OfferDetailImpl _value, $Res Function(_$OfferDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of OfferDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? productName = null,
    Object? shopName = null,
    Object? shopAddress = null,
    Object? shopRating = null,
    Object? price = null,
    Object? savings = null,
    Object? savingsPercentage = null,
  }) {
    return _then(_$OfferDetailImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      shopName: null == shopName
          ? _value.shopName
          : shopName // ignore: cast_nullable_to_non_nullable
              as String,
      shopAddress: null == shopAddress
          ? _value.shopAddress
          : shopAddress // ignore: cast_nullable_to_non_nullable
              as String,
      shopRating: null == shopRating
          ? _value.shopRating
          : shopRating // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      savings: null == savings
          ? _value.savings
          : savings // ignore: cast_nullable_to_non_nullable
              as double,
      savingsPercentage: null == savingsPercentage
          ? _value.savingsPercentage
          : savingsPercentage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OfferDetailImpl implements _OfferDetail {
  const _$OfferDetailImpl(
      {@JsonKey(name: 'productId') required this.productId,
      @JsonKey(name: 'productName') required this.productName,
      @JsonKey(name: 'shopName') required this.shopName,
      @JsonKey(name: 'shopAddress') required this.shopAddress,
      @JsonKey(name: 'shopRating') required this.shopRating,
      required this.price,
      required this.savings,
      @JsonKey(name: 'savingsPercentage') required this.savingsPercentage});

  factory _$OfferDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfferDetailImplFromJson(json);

  @override
  @JsonKey(name: 'productId')
  final String productId;
  @override
  @JsonKey(name: 'productName')
  final String productName;
  @override
  @JsonKey(name: 'shopName')
  final String shopName;
  @override
  @JsonKey(name: 'shopAddress')
  final String shopAddress;
  @override
  @JsonKey(name: 'shopRating')
  final String shopRating;
  @override
  final double price;
  @override
  final double savings;
  @override
  @JsonKey(name: 'savingsPercentage')
  final String savingsPercentage;

  @override
  String toString() {
    return 'OfferDetail(productId: $productId, productName: $productName, shopName: $shopName, shopAddress: $shopAddress, shopRating: $shopRating, price: $price, savings: $savings, savingsPercentage: $savingsPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfferDetailImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.shopName, shopName) ||
                other.shopName == shopName) &&
            (identical(other.shopAddress, shopAddress) ||
                other.shopAddress == shopAddress) &&
            (identical(other.shopRating, shopRating) ||
                other.shopRating == shopRating) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.savings, savings) || other.savings == savings) &&
            (identical(other.savingsPercentage, savingsPercentage) ||
                other.savingsPercentage == savingsPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productId, productName, shopName,
      shopAddress, shopRating, price, savings, savingsPercentage);

  /// Create a copy of OfferDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfferDetailImplCopyWith<_$OfferDetailImpl> get copyWith =>
      __$$OfferDetailImplCopyWithImpl<_$OfferDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfferDetailImplToJson(
      this,
    );
  }
}

abstract class _OfferDetail implements OfferDetail {
  const factory _OfferDetail(
      {@JsonKey(name: 'productId') required final String productId,
      @JsonKey(name: 'productName') required final String productName,
      @JsonKey(name: 'shopName') required final String shopName,
      @JsonKey(name: 'shopAddress') required final String shopAddress,
      @JsonKey(name: 'shopRating') required final String shopRating,
      required final double price,
      required final double savings,
      @JsonKey(name: 'savingsPercentage')
      required final String savingsPercentage}) = _$OfferDetailImpl;

  factory _OfferDetail.fromJson(Map<String, dynamic> json) =
      _$OfferDetailImpl.fromJson;

  @override
  @JsonKey(name: 'productId')
  String get productId;
  @override
  @JsonKey(name: 'productName')
  String get productName;
  @override
  @JsonKey(name: 'shopName')
  String get shopName;
  @override
  @JsonKey(name: 'shopAddress')
  String get shopAddress;
  @override
  @JsonKey(name: 'shopRating')
  String get shopRating;
  @override
  double get price;
  @override
  double get savings;
  @override
  @JsonKey(name: 'savingsPercentage')
  String get savingsPercentage;

  /// Create a copy of OfferDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfferDetailImplCopyWith<_$OfferDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanResult _$ScanResultFromJson(Map<String, dynamic> json) {
  return _ScanResult.fromJson(json);
}

/// @nodoc
mixin _$ScanResult {
  String get scanId => throw _privateConstructorUsedError;
  List<ScannedItem> get scannedItems => throw _privateConstructorUsedError;
  List<Alternative> get alternatives => throw _privateConstructorUsedError;
  ScanSummary get summary => throw _privateConstructorUsedError;
  int get processingTimeMs => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  @JsonKey(name: 'model_used')
  String? get modelUsed => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this ScanResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanResultCopyWith<ScanResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanResultCopyWith<$Res> {
  factory $ScanResultCopyWith(
          ScanResult value, $Res Function(ScanResult) then) =
      _$ScanResultCopyWithImpl<$Res, ScanResult>;
  @useResult
  $Res call(
      {String scanId,
      List<ScannedItem> scannedItems,
      List<Alternative> alternatives,
      ScanSummary summary,
      int processingTimeMs,
      String? error,
      @JsonKey(name: 'model_used') String? modelUsed,
      Map<String, dynamic>? metadata});

  $ScanSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$ScanResultCopyWithImpl<$Res, $Val extends ScanResult>
    implements $ScanResultCopyWith<$Res> {
  _$ScanResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scanId = null,
    Object? scannedItems = null,
    Object? alternatives = null,
    Object? summary = null,
    Object? processingTimeMs = null,
    Object? error = freezed,
    Object? modelUsed = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      scanId: null == scanId
          ? _value.scanId
          : scanId // ignore: cast_nullable_to_non_nullable
              as String,
      scannedItems: null == scannedItems
          ? _value.scannedItems
          : scannedItems // ignore: cast_nullable_to_non_nullable
              as List<ScannedItem>,
      alternatives: null == alternatives
          ? _value.alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<Alternative>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as ScanSummary,
      processingTimeMs: null == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      modelUsed: freezed == modelUsed
          ? _value.modelUsed
          : modelUsed // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScanSummaryCopyWith<$Res> get summary {
    return $ScanSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScanResultImplCopyWith<$Res>
    implements $ScanResultCopyWith<$Res> {
  factory _$$ScanResultImplCopyWith(
          _$ScanResultImpl value, $Res Function(_$ScanResultImpl) then) =
      __$$ScanResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String scanId,
      List<ScannedItem> scannedItems,
      List<Alternative> alternatives,
      ScanSummary summary,
      int processingTimeMs,
      String? error,
      @JsonKey(name: 'model_used') String? modelUsed,
      Map<String, dynamic>? metadata});

  @override
  $ScanSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$ScanResultImplCopyWithImpl<$Res>
    extends _$ScanResultCopyWithImpl<$Res, _$ScanResultImpl>
    implements _$$ScanResultImplCopyWith<$Res> {
  __$$ScanResultImplCopyWithImpl(
      _$ScanResultImpl _value, $Res Function(_$ScanResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scanId = null,
    Object? scannedItems = null,
    Object? alternatives = null,
    Object? summary = null,
    Object? processingTimeMs = null,
    Object? error = freezed,
    Object? modelUsed = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$ScanResultImpl(
      scanId: null == scanId
          ? _value.scanId
          : scanId // ignore: cast_nullable_to_non_nullable
              as String,
      scannedItems: null == scannedItems
          ? _value._scannedItems
          : scannedItems // ignore: cast_nullable_to_non_nullable
              as List<ScannedItem>,
      alternatives: null == alternatives
          ? _value._alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<Alternative>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as ScanSummary,
      processingTimeMs: null == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      modelUsed: freezed == modelUsed
          ? _value.modelUsed
          : modelUsed // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanResultImpl implements _ScanResult {
  const _$ScanResultImpl(
      {required this.scanId,
      required final List<ScannedItem> scannedItems,
      required final List<Alternative> alternatives,
      required this.summary,
      required this.processingTimeMs,
      this.error,
      @JsonKey(name: 'model_used') this.modelUsed,
      final Map<String, dynamic>? metadata})
      : _scannedItems = scannedItems,
        _alternatives = alternatives,
        _metadata = metadata;

  factory _$ScanResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanResultImplFromJson(json);

  @override
  final String scanId;
  final List<ScannedItem> _scannedItems;
  @override
  List<ScannedItem> get scannedItems {
    if (_scannedItems is EqualUnmodifiableListView) return _scannedItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scannedItems);
  }

  final List<Alternative> _alternatives;
  @override
  List<Alternative> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  @override
  final ScanSummary summary;
  @override
  final int processingTimeMs;
  @override
  final String? error;
  @override
  @JsonKey(name: 'model_used')
  final String? modelUsed;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ScanResult(scanId: $scanId, scannedItems: $scannedItems, alternatives: $alternatives, summary: $summary, processingTimeMs: $processingTimeMs, error: $error, modelUsed: $modelUsed, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanResultImpl &&
            (identical(other.scanId, scanId) || other.scanId == scanId) &&
            const DeepCollectionEquality()
                .equals(other._scannedItems, _scannedItems) &&
            const DeepCollectionEquality()
                .equals(other._alternatives, _alternatives) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.processingTimeMs, processingTimeMs) ||
                other.processingTimeMs == processingTimeMs) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.modelUsed, modelUsed) ||
                other.modelUsed == modelUsed) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      scanId,
      const DeepCollectionEquality().hash(_scannedItems),
      const DeepCollectionEquality().hash(_alternatives),
      summary,
      processingTimeMs,
      error,
      modelUsed,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanResultImplCopyWith<_$ScanResultImpl> get copyWith =>
      __$$ScanResultImplCopyWithImpl<_$ScanResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanResultImplToJson(
      this,
    );
  }
}

abstract class _ScanResult implements ScanResult {
  const factory _ScanResult(
      {required final String scanId,
      required final List<ScannedItem> scannedItems,
      required final List<Alternative> alternatives,
      required final ScanSummary summary,
      required final int processingTimeMs,
      final String? error,
      @JsonKey(name: 'model_used') final String? modelUsed,
      final Map<String, dynamic>? metadata}) = _$ScanResultImpl;

  factory _ScanResult.fromJson(Map<String, dynamic> json) =
      _$ScanResultImpl.fromJson;

  @override
  String get scanId;
  @override
  List<ScannedItem> get scannedItems;
  @override
  List<Alternative> get alternatives;
  @override
  ScanSummary get summary;
  @override
  int get processingTimeMs;
  @override
  String? get error;
  @override
  @JsonKey(name: 'model_used')
  String? get modelUsed;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanResultImplCopyWith<_$ScanResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScannedItem _$ScannedItemFromJson(Map<String, dynamic> json) {
  return _ScannedItem.fromJson(json);
}

/// @nodoc
mixin _$ScannedItem {
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'normalized_name')
  String get normalizedName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  double? get confidence => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this ScannedItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScannedItemCopyWith<ScannedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScannedItemCopyWith<$Res> {
  factory $ScannedItemCopyWith(
          ScannedItem value, $Res Function(ScannedItem) then) =
      _$ScannedItemCopyWithImpl<$Res, ScannedItem>;
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: 'normalized_name') String normalizedName,
      double price,
      int quantity,
      String? category,
      double? confidence,
      String? brand,
      String? description});
}

/// @nodoc
class _$ScannedItemCopyWithImpl<$Res, $Val extends ScannedItem>
    implements $ScannedItemCopyWith<$Res> {
  _$ScannedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? normalizedName = null,
    Object? price = null,
    Object? quantity = null,
    Object? category = freezed,
    Object? confidence = freezed,
    Object? brand = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      normalizedName: null == normalizedName
          ? _value.normalizedName
          : normalizedName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScannedItemImplCopyWith<$Res>
    implements $ScannedItemCopyWith<$Res> {
  factory _$$ScannedItemImplCopyWith(
          _$ScannedItemImpl value, $Res Function(_$ScannedItemImpl) then) =
      __$$ScannedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      @JsonKey(name: 'normalized_name') String normalizedName,
      double price,
      int quantity,
      String? category,
      double? confidence,
      String? brand,
      String? description});
}

/// @nodoc
class __$$ScannedItemImplCopyWithImpl<$Res>
    extends _$ScannedItemCopyWithImpl<$Res, _$ScannedItemImpl>
    implements _$$ScannedItemImplCopyWith<$Res> {
  __$$ScannedItemImplCopyWithImpl(
      _$ScannedItemImpl _value, $Res Function(_$ScannedItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? normalizedName = null,
    Object? price = null,
    Object? quantity = null,
    Object? category = freezed,
    Object? confidence = freezed,
    Object? brand = freezed,
    Object? description = freezed,
  }) {
    return _then(_$ScannedItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      normalizedName: null == normalizedName
          ? _value.normalizedName
          : normalizedName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScannedItemImpl implements _ScannedItem {
  const _$ScannedItemImpl(
      {required this.name,
      @JsonKey(name: 'normalized_name') required this.normalizedName,
      required this.price,
      required this.quantity,
      this.category,
      this.confidence,
      this.brand,
      this.description});

  factory _$ScannedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScannedItemImplFromJson(json);

  @override
  final String name;
  @override
  @JsonKey(name: 'normalized_name')
  final String normalizedName;
  @override
  final double price;
  @override
  final int quantity;
  @override
  final String? category;
  @override
  final double? confidence;
  @override
  final String? brand;
  @override
  final String? description;

  @override
  String toString() {
    return 'ScannedItem(name: $name, normalizedName: $normalizedName, price: $price, quantity: $quantity, category: $category, confidence: $confidence, brand: $brand, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScannedItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.normalizedName, normalizedName) ||
                other.normalizedName == normalizedName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, normalizedName, price,
      quantity, category, confidence, brand, description);

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScannedItemImplCopyWith<_$ScannedItemImpl> get copyWith =>
      __$$ScannedItemImplCopyWithImpl<_$ScannedItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScannedItemImplToJson(
      this,
    );
  }
}

abstract class _ScannedItem implements ScannedItem {
  const factory _ScannedItem(
      {required final String name,
      @JsonKey(name: 'normalized_name') required final String normalizedName,
      required final double price,
      required final int quantity,
      final String? category,
      final double? confidence,
      final String? brand,
      final String? description}) = _$ScannedItemImpl;

  factory _ScannedItem.fromJson(Map<String, dynamic> json) =
      _$ScannedItemImpl.fromJson;

  @override
  String get name;
  @override
  @JsonKey(name: 'normalized_name')
  String get normalizedName;
  @override
  double get price;
  @override
  int get quantity;
  @override
  String? get category;
  @override
  double? get confidence;
  @override
  String? get brand;
  @override
  String? get description;

  /// Create a copy of ScannedItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScannedItemImplCopyWith<_$ScannedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Alternative _$AlternativeFromJson(Map<String, dynamic> json) {
  return _Alternative.fromJson(json);
}

/// @nodoc
mixin _$Alternative {
  @JsonKey(name: 'original_item')
  String get originalItem => throw _privateConstructorUsedError;
  Shop get shop => throw _privateConstructorUsedError;
  Product get product => throw _privateConstructorUsedError;
  double get savings => throw _privateConstructorUsedError;
  @JsonKey(name: 'savings_percentage')
  double get savingsPercentage => throw _privateConstructorUsedError;
  double get distance => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_time')
  int? get estimatedTime => throw _privateConstructorUsedError;

  /// Serializes this Alternative to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alternative
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlternativeCopyWith<Alternative> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlternativeCopyWith<$Res> {
  factory $AlternativeCopyWith(
          Alternative value, $Res Function(Alternative) then) =
      _$AlternativeCopyWithImpl<$Res, Alternative>;
  @useResult
  $Res call(
      {@JsonKey(name: 'original_item') String originalItem,
      Shop shop,
      Product product,
      double savings,
      @JsonKey(name: 'savings_percentage') double savingsPercentage,
      double distance,
      @JsonKey(name: 'estimated_time') int? estimatedTime});

  $ShopCopyWith<$Res> get shop;
  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class _$AlternativeCopyWithImpl<$Res, $Val extends Alternative>
    implements $AlternativeCopyWith<$Res> {
  _$AlternativeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alternative
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalItem = null,
    Object? shop = null,
    Object? product = null,
    Object? savings = null,
    Object? savingsPercentage = null,
    Object? distance = null,
    Object? estimatedTime = freezed,
  }) {
    return _then(_value.copyWith(
      originalItem: null == originalItem
          ? _value.originalItem
          : originalItem // ignore: cast_nullable_to_non_nullable
              as String,
      shop: null == shop
          ? _value.shop
          : shop // ignore: cast_nullable_to_non_nullable
              as Shop,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
      savings: null == savings
          ? _value.savings
          : savings // ignore: cast_nullable_to_non_nullable
              as double,
      savingsPercentage: null == savingsPercentage
          ? _value.savingsPercentage
          : savingsPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedTime: freezed == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of Alternative
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShopCopyWith<$Res> get shop {
    return $ShopCopyWith<$Res>(_value.shop, (value) {
      return _then(_value.copyWith(shop: value) as $Val);
    });
  }

  /// Create a copy of Alternative
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AlternativeImplCopyWith<$Res>
    implements $AlternativeCopyWith<$Res> {
  factory _$$AlternativeImplCopyWith(
          _$AlternativeImpl value, $Res Function(_$AlternativeImpl) then) =
      __$$AlternativeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'original_item') String originalItem,
      Shop shop,
      Product product,
      double savings,
      @JsonKey(name: 'savings_percentage') double savingsPercentage,
      double distance,
      @JsonKey(name: 'estimated_time') int? estimatedTime});

  @override
  $ShopCopyWith<$Res> get shop;
  @override
  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$AlternativeImplCopyWithImpl<$Res>
    extends _$AlternativeCopyWithImpl<$Res, _$AlternativeImpl>
    implements _$$AlternativeImplCopyWith<$Res> {
  __$$AlternativeImplCopyWithImpl(
      _$AlternativeImpl _value, $Res Function(_$AlternativeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Alternative
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originalItem = null,
    Object? shop = null,
    Object? product = null,
    Object? savings = null,
    Object? savingsPercentage = null,
    Object? distance = null,
    Object? estimatedTime = freezed,
  }) {
    return _then(_$AlternativeImpl(
      originalItem: null == originalItem
          ? _value.originalItem
          : originalItem // ignore: cast_nullable_to_non_nullable
              as String,
      shop: null == shop
          ? _value.shop
          : shop // ignore: cast_nullable_to_non_nullable
              as Shop,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
      savings: null == savings
          ? _value.savings
          : savings // ignore: cast_nullable_to_non_nullable
              as double,
      savingsPercentage: null == savingsPercentage
          ? _value.savingsPercentage
          : savingsPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      distance: null == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedTime: freezed == estimatedTime
          ? _value.estimatedTime
          : estimatedTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlternativeImpl implements _Alternative {
  const _$AlternativeImpl(
      {@JsonKey(name: 'original_item') required this.originalItem,
      required this.shop,
      required this.product,
      required this.savings,
      @JsonKey(name: 'savings_percentage') required this.savingsPercentage,
      required this.distance,
      @JsonKey(name: 'estimated_time') this.estimatedTime});

  factory _$AlternativeImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlternativeImplFromJson(json);

  @override
  @JsonKey(name: 'original_item')
  final String originalItem;
  @override
  final Shop shop;
  @override
  final Product product;
  @override
  final double savings;
  @override
  @JsonKey(name: 'savings_percentage')
  final double savingsPercentage;
  @override
  final double distance;
  @override
  @JsonKey(name: 'estimated_time')
  final int? estimatedTime;

  @override
  String toString() {
    return 'Alternative(originalItem: $originalItem, shop: $shop, product: $product, savings: $savings, savingsPercentage: $savingsPercentage, distance: $distance, estimatedTime: $estimatedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlternativeImpl &&
            (identical(other.originalItem, originalItem) ||
                other.originalItem == originalItem) &&
            (identical(other.shop, shop) || other.shop == shop) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.savings, savings) || other.savings == savings) &&
            (identical(other.savingsPercentage, savingsPercentage) ||
                other.savingsPercentage == savingsPercentage) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.estimatedTime, estimatedTime) ||
                other.estimatedTime == estimatedTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, originalItem, shop, product,
      savings, savingsPercentage, distance, estimatedTime);

  /// Create a copy of Alternative
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlternativeImplCopyWith<_$AlternativeImpl> get copyWith =>
      __$$AlternativeImplCopyWithImpl<_$AlternativeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlternativeImplToJson(
      this,
    );
  }
}

abstract class _Alternative implements Alternative {
  const factory _Alternative(
          {@JsonKey(name: 'original_item') required final String originalItem,
          required final Shop shop,
          required final Product product,
          required final double savings,
          @JsonKey(name: 'savings_percentage')
          required final double savingsPercentage,
          required final double distance,
          @JsonKey(name: 'estimated_time') final int? estimatedTime}) =
      _$AlternativeImpl;

  factory _Alternative.fromJson(Map<String, dynamic> json) =
      _$AlternativeImpl.fromJson;

  @override
  @JsonKey(name: 'original_item')
  String get originalItem;
  @override
  Shop get shop;
  @override
  Product get product;
  @override
  double get savings;
  @override
  @JsonKey(name: 'savings_percentage')
  double get savingsPercentage;
  @override
  double get distance;
  @override
  @JsonKey(name: 'estimated_time')
  int? get estimatedTime;

  /// Create a copy of Alternative
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlternativeImplCopyWith<_$AlternativeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Shop _$ShopFromJson(Map<String, dynamic> json) {
  return _Shop.fromJson(json);
}

/// @nodoc
mixin _$Shop {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_premium')
  bool get isPremium => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'opening_hours')
  String? get openingHours => throw _privateConstructorUsedError;

  /// Serializes this Shop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShopCopyWith<Shop> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShopCopyWith<$Res> {
  factory $ShopCopyWith(Shop value, $Res Function(Shop) then) =
      _$ShopCopyWithImpl<$Res, Shop>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? address,
      double latitude,
      double longitude,
      String? phone,
      double? rating,
      @JsonKey(name: 'is_premium') bool isPremium,
      String? category,
      @JsonKey(name: 'image_url') String? imageUrl,
      String? description,
      @JsonKey(name: 'opening_hours') String? openingHours});
}

/// @nodoc
class _$ShopCopyWithImpl<$Res, $Val extends Shop>
    implements $ShopCopyWith<$Res> {
  _$ShopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? phone = freezed,
    Object? rating = freezed,
    Object? isPremium = null,
    Object? category = freezed,
    Object? imageUrl = freezed,
    Object? description = freezed,
    Object? openingHours = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShopImplCopyWith<$Res> implements $ShopCopyWith<$Res> {
  factory _$$ShopImplCopyWith(
          _$ShopImpl value, $Res Function(_$ShopImpl) then) =
      __$$ShopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? address,
      double latitude,
      double longitude,
      String? phone,
      double? rating,
      @JsonKey(name: 'is_premium') bool isPremium,
      String? category,
      @JsonKey(name: 'image_url') String? imageUrl,
      String? description,
      @JsonKey(name: 'opening_hours') String? openingHours});
}

/// @nodoc
class __$$ShopImplCopyWithImpl<$Res>
    extends _$ShopCopyWithImpl<$Res, _$ShopImpl>
    implements _$$ShopImplCopyWith<$Res> {
  __$$ShopImplCopyWithImpl(_$ShopImpl _value, $Res Function(_$ShopImpl) _then)
      : super(_value, _then);

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? phone = freezed,
    Object? rating = freezed,
    Object? isPremium = null,
    Object? category = freezed,
    Object? imageUrl = freezed,
    Object? description = freezed,
    Object? openingHours = freezed,
  }) {
    return _then(_$ShopImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      isPremium: null == isPremium
          ? _value.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShopImpl implements _Shop {
  const _$ShopImpl(
      {required this.id,
      required this.name,
      this.address,
      required this.latitude,
      required this.longitude,
      this.phone,
      this.rating,
      @JsonKey(name: 'is_premium') required this.isPremium,
      this.category,
      @JsonKey(name: 'image_url') this.imageUrl,
      this.description,
      @JsonKey(name: 'opening_hours') this.openingHours});

  factory _$ShopImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShopImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final String? phone;
  @override
  final double? rating;
  @override
  @JsonKey(name: 'is_premium')
  final bool isPremium;
  @override
  final String? category;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final String? description;
  @override
  @JsonKey(name: 'opening_hours')
  final String? openingHours;

  @override
  String toString() {
    return 'Shop(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, phone: $phone, rating: $rating, isPremium: $isPremium, category: $category, imageUrl: $imageUrl, description: $description, openingHours: $openingHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.openingHours, openingHours) ||
                other.openingHours == openingHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      address,
      latitude,
      longitude,
      phone,
      rating,
      isPremium,
      category,
      imageUrl,
      description,
      openingHours);

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShopImplCopyWith<_$ShopImpl> get copyWith =>
      __$$ShopImplCopyWithImpl<_$ShopImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShopImplToJson(
      this,
    );
  }
}

abstract class _Shop implements Shop {
  const factory _Shop(
      {required final String id,
      required final String name,
      final String? address,
      required final double latitude,
      required final double longitude,
      final String? phone,
      final double? rating,
      @JsonKey(name: 'is_premium') required final bool isPremium,
      final String? category,
      @JsonKey(name: 'image_url') final String? imageUrl,
      final String? description,
      @JsonKey(name: 'opening_hours') final String? openingHours}) = _$ShopImpl;

  factory _Shop.fromJson(Map<String, dynamic> json) = _$ShopImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String? get phone;
  @override
  double? get rating;
  @override
  @JsonKey(name: 'is_premium')
  bool get isPremium;
  @override
  String? get category;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  String? get description;
  @override
  @JsonKey(name: 'opening_hours')
  String? get openingHours;

  /// Create a copy of Shop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShopImplCopyWith<_$ShopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'shop_id')
  String get shopId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'normalized_name')
  String get normalizedName => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get keywords => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;
  @JsonKey(name: 'stock_quantity')
  int? get stockQuantity => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  double? get weight => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'shop_id') String shopId,
      String name,
      @JsonKey(name: 'normalized_name') String normalizedName,
      String? category,
      double price,
      @JsonKey(name: 'image_url') String? imageUrl,
      String? brand,
      String? description,
      List<String> keywords,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'stock_quantity') int? stockQuantity,
      String? barcode,
      double? weight,
      String? unit});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? name = null,
    Object? normalizedName = null,
    Object? category = freezed,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? brand = freezed,
    Object? description = freezed,
    Object? keywords = null,
    Object? isAvailable = null,
    Object? stockQuantity = freezed,
    Object? barcode = freezed,
    Object? weight = freezed,
    Object? unit = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      normalizedName: null == normalizedName
          ? _value.normalizedName
          : normalizedName // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: null == keywords
          ? _value.keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      stockQuantity: freezed == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'shop_id') String shopId,
      String name,
      @JsonKey(name: 'normalized_name') String normalizedName,
      String? category,
      double price,
      @JsonKey(name: 'image_url') String? imageUrl,
      String? brand,
      String? description,
      List<String> keywords,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'stock_quantity') int? stockQuantity,
      String? barcode,
      double? weight,
      String? unit});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? shopId = null,
    Object? name = null,
    Object? normalizedName = null,
    Object? category = freezed,
    Object? price = null,
    Object? imageUrl = freezed,
    Object? brand = freezed,
    Object? description = freezed,
    Object? keywords = null,
    Object? isAvailable = null,
    Object? stockQuantity = freezed,
    Object? barcode = freezed,
    Object? weight = freezed,
    Object? unit = freezed,
  }) {
    return _then(_$ProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      shopId: null == shopId
          ? _value.shopId
          : shopId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      normalizedName: null == normalizedName
          ? _value.normalizedName
          : normalizedName // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      keywords: null == keywords
          ? _value._keywords
          : keywords // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      stockQuantity: freezed == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl(
      {required this.id,
      @JsonKey(name: 'shop_id') required this.shopId,
      required this.name,
      @JsonKey(name: 'normalized_name') required this.normalizedName,
      this.category,
      required this.price,
      @JsonKey(name: 'image_url') this.imageUrl,
      this.brand,
      this.description,
      required final List<String> keywords,
      @JsonKey(name: 'is_available') required this.isAvailable,
      @JsonKey(name: 'stock_quantity') this.stockQuantity,
      this.barcode,
      this.weight,
      this.unit})
      : _keywords = keywords;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'shop_id')
  final String shopId;
  @override
  final String name;
  @override
  @JsonKey(name: 'normalized_name')
  final String normalizedName;
  @override
  final String? category;
  @override
  final double price;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  final String? brand;
  @override
  final String? description;
  final List<String> _keywords;
  @override
  List<String> get keywords {
    if (_keywords is EqualUnmodifiableListView) return _keywords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_keywords);
  }

  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;
  @override
  @JsonKey(name: 'stock_quantity')
  final int? stockQuantity;
  @override
  final String? barcode;
  @override
  final double? weight;
  @override
  final String? unit;

  @override
  String toString() {
    return 'Product(id: $id, shopId: $shopId, name: $name, normalizedName: $normalizedName, category: $category, price: $price, imageUrl: $imageUrl, brand: $brand, description: $description, keywords: $keywords, isAvailable: $isAvailable, stockQuantity: $stockQuantity, barcode: $barcode, weight: $weight, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.shopId, shopId) || other.shopId == shopId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.normalizedName, normalizedName) ||
                other.normalizedName == normalizedName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._keywords, _keywords) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      shopId,
      name,
      normalizedName,
      category,
      price,
      imageUrl,
      brand,
      description,
      const DeepCollectionEquality().hash(_keywords),
      isAvailable,
      stockQuantity,
      barcode,
      weight,
      unit);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {required final String id,
      @JsonKey(name: 'shop_id') required final String shopId,
      required final String name,
      @JsonKey(name: 'normalized_name') required final String normalizedName,
      final String? category,
      required final double price,
      @JsonKey(name: 'image_url') final String? imageUrl,
      final String? brand,
      final String? description,
      required final List<String> keywords,
      @JsonKey(name: 'is_available') required final bool isAvailable,
      @JsonKey(name: 'stock_quantity') final int? stockQuantity,
      final String? barcode,
      final double? weight,
      final String? unit}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'shop_id')
  String get shopId;
  @override
  String get name;
  @override
  @JsonKey(name: 'normalized_name')
  String get normalizedName;
  @override
  String? get category;
  @override
  double get price;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  String? get brand;
  @override
  String? get description;
  @override
  List<String> get keywords;
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;
  @override
  @JsonKey(name: 'stock_quantity')
  int? get stockQuantity;
  @override
  String? get barcode;
  @override
  double? get weight;
  @override
  String? get unit;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanSummary _$ScanSummaryFromJson(Map<String, dynamic> json) {
  return _ScanSummary.fromJson(json);
}

/// @nodoc
mixin _$ScanSummary {
  @JsonKey(name: 'items_found')
  int get itemsFound => throw _privateConstructorUsedError;
  @JsonKey(name: 'alternatives_found')
  int get alternativesFound => throw _privateConstructorUsedError;
  @JsonKey(name: 'potential_savings')
  double get potentialSavings => throw _privateConstructorUsedError;
  @JsonKey(name: 'confidence_score')
  double? get confidenceScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double get totalAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'processing_time_ms')
  int get processingTimeMs => throw _privateConstructorUsedError;

  /// Serializes this ScanSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanSummaryCopyWith<ScanSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanSummaryCopyWith<$Res> {
  factory $ScanSummaryCopyWith(
          ScanSummary value, $Res Function(ScanSummary) then) =
      _$ScanSummaryCopyWithImpl<$Res, ScanSummary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'items_found') int itemsFound,
      @JsonKey(name: 'alternatives_found') int alternativesFound,
      @JsonKey(name: 'potential_savings') double potentialSavings,
      @JsonKey(name: 'confidence_score') double? confidenceScore,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'processing_time_ms') int processingTimeMs});
}

/// @nodoc
class _$ScanSummaryCopyWithImpl<$Res, $Val extends ScanSummary>
    implements $ScanSummaryCopyWith<$Res> {
  _$ScanSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsFound = null,
    Object? alternativesFound = null,
    Object? potentialSavings = null,
    Object? confidenceScore = freezed,
    Object? totalAmount = null,
    Object? processingTimeMs = null,
  }) {
    return _then(_value.copyWith(
      itemsFound: null == itemsFound
          ? _value.itemsFound
          : itemsFound // ignore: cast_nullable_to_non_nullable
              as int,
      alternativesFound: null == alternativesFound
          ? _value.alternativesFound
          : alternativesFound // ignore: cast_nullable_to_non_nullable
              as int,
      potentialSavings: null == potentialSavings
          ? _value.potentialSavings
          : potentialSavings // ignore: cast_nullable_to_non_nullable
              as double,
      confidenceScore: freezed == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      processingTimeMs: null == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanSummaryImplCopyWith<$Res>
    implements $ScanSummaryCopyWith<$Res> {
  factory _$$ScanSummaryImplCopyWith(
          _$ScanSummaryImpl value, $Res Function(_$ScanSummaryImpl) then) =
      __$$ScanSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'items_found') int itemsFound,
      @JsonKey(name: 'alternatives_found') int alternativesFound,
      @JsonKey(name: 'potential_savings') double potentialSavings,
      @JsonKey(name: 'confidence_score') double? confidenceScore,
      @JsonKey(name: 'total_amount') double totalAmount,
      @JsonKey(name: 'processing_time_ms') int processingTimeMs});
}

/// @nodoc
class __$$ScanSummaryImplCopyWithImpl<$Res>
    extends _$ScanSummaryCopyWithImpl<$Res, _$ScanSummaryImpl>
    implements _$$ScanSummaryImplCopyWith<$Res> {
  __$$ScanSummaryImplCopyWithImpl(
      _$ScanSummaryImpl _value, $Res Function(_$ScanSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsFound = null,
    Object? alternativesFound = null,
    Object? potentialSavings = null,
    Object? confidenceScore = freezed,
    Object? totalAmount = null,
    Object? processingTimeMs = null,
  }) {
    return _then(_$ScanSummaryImpl(
      itemsFound: null == itemsFound
          ? _value.itemsFound
          : itemsFound // ignore: cast_nullable_to_non_nullable
              as int,
      alternativesFound: null == alternativesFound
          ? _value.alternativesFound
          : alternativesFound // ignore: cast_nullable_to_non_nullable
              as int,
      potentialSavings: null == potentialSavings
          ? _value.potentialSavings
          : potentialSavings // ignore: cast_nullable_to_non_nullable
              as double,
      confidenceScore: freezed == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double?,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      processingTimeMs: null == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanSummaryImpl implements _ScanSummary {
  const _$ScanSummaryImpl(
      {@JsonKey(name: 'items_found') required this.itemsFound,
      @JsonKey(name: 'alternatives_found') required this.alternativesFound,
      @JsonKey(name: 'potential_savings') required this.potentialSavings,
      @JsonKey(name: 'confidence_score') this.confidenceScore,
      @JsonKey(name: 'total_amount') required this.totalAmount,
      @JsonKey(name: 'processing_time_ms') required this.processingTimeMs});

  factory _$ScanSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanSummaryImplFromJson(json);

  @override
  @JsonKey(name: 'items_found')
  final int itemsFound;
  @override
  @JsonKey(name: 'alternatives_found')
  final int alternativesFound;
  @override
  @JsonKey(name: 'potential_savings')
  final double potentialSavings;
  @override
  @JsonKey(name: 'confidence_score')
  final double? confidenceScore;
  @override
  @JsonKey(name: 'total_amount')
  final double totalAmount;
  @override
  @JsonKey(name: 'processing_time_ms')
  final int processingTimeMs;

  @override
  String toString() {
    return 'ScanSummary(itemsFound: $itemsFound, alternativesFound: $alternativesFound, potentialSavings: $potentialSavings, confidenceScore: $confidenceScore, totalAmount: $totalAmount, processingTimeMs: $processingTimeMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanSummaryImpl &&
            (identical(other.itemsFound, itemsFound) ||
                other.itemsFound == itemsFound) &&
            (identical(other.alternativesFound, alternativesFound) ||
                other.alternativesFound == alternativesFound) &&
            (identical(other.potentialSavings, potentialSavings) ||
                other.potentialSavings == potentialSavings) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.processingTimeMs, processingTimeMs) ||
                other.processingTimeMs == processingTimeMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, itemsFound, alternativesFound,
      potentialSavings, confidenceScore, totalAmount, processingTimeMs);

  /// Create a copy of ScanSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanSummaryImplCopyWith<_$ScanSummaryImpl> get copyWith =>
      __$$ScanSummaryImplCopyWithImpl<_$ScanSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanSummaryImplToJson(
      this,
    );
  }
}

abstract class _ScanSummary implements ScanSummary {
  const factory _ScanSummary(
      {@JsonKey(name: 'items_found') required final int itemsFound,
      @JsonKey(name: 'alternatives_found') required final int alternativesFound,
      @JsonKey(name: 'potential_savings')
      required final double potentialSavings,
      @JsonKey(name: 'confidence_score') final double? confidenceScore,
      @JsonKey(name: 'total_amount') required final double totalAmount,
      @JsonKey(name: 'processing_time_ms')
      required final int processingTimeMs}) = _$ScanSummaryImpl;

  factory _ScanSummary.fromJson(Map<String, dynamic> json) =
      _$ScanSummaryImpl.fromJson;

  @override
  @JsonKey(name: 'items_found')
  int get itemsFound;
  @override
  @JsonKey(name: 'alternatives_found')
  int get alternativesFound;
  @override
  @JsonKey(name: 'potential_savings')
  double get potentialSavings;
  @override
  @JsonKey(name: 'confidence_score')
  double? get confidenceScore;
  @override
  @JsonKey(name: 'total_amount')
  double get totalAmount;
  @override
  @JsonKey(name: 'processing_time_ms')
  int get processingTimeMs;

  /// Create a copy of ScanSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanSummaryImplCopyWith<_$ScanSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanRequest _$ScanRequestFromJson(Map<String, dynamic> json) {
  return _ScanRequest.fromJson(json);
}

/// @nodoc
mixin _$ScanRequest {
  String get imagePath => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double? get radius => throw _privateConstructorUsedError;
  @JsonKey(name: 'premium_only')
  bool? get premiumOnly => throw _privateConstructorUsedError;
  @JsonKey(name: 'confidence_threshold')
  double? get confidenceThreshold => throw _privateConstructorUsedError;
  @JsonKey(name: 'use_fallback')
  bool? get useFallback => throw _privateConstructorUsedError;

  /// Serializes this ScanRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanRequestCopyWith<ScanRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanRequestCopyWith<$Res> {
  factory $ScanRequestCopyWith(
          ScanRequest value, $Res Function(ScanRequest) then) =
      _$ScanRequestCopyWithImpl<$Res, ScanRequest>;
  @useResult
  $Res call(
      {String imagePath,
      double latitude,
      double longitude,
      double? radius,
      @JsonKey(name: 'premium_only') bool? premiumOnly,
      @JsonKey(name: 'confidence_threshold') double? confidenceThreshold,
      @JsonKey(name: 'use_fallback') bool? useFallback});
}

/// @nodoc
class _$ScanRequestCopyWithImpl<$Res, $Val extends ScanRequest>
    implements $ScanRequestCopyWith<$Res> {
  _$ScanRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radius = freezed,
    Object? premiumOnly = freezed,
    Object? confidenceThreshold = freezed,
    Object? useFallback = freezed,
  }) {
    return _then(_value.copyWith(
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      radius: freezed == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double?,
      premiumOnly: freezed == premiumOnly
          ? _value.premiumOnly
          : premiumOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      confidenceThreshold: freezed == confidenceThreshold
          ? _value.confidenceThreshold
          : confidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double?,
      useFallback: freezed == useFallback
          ? _value.useFallback
          : useFallback // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanRequestImplCopyWith<$Res>
    implements $ScanRequestCopyWith<$Res> {
  factory _$$ScanRequestImplCopyWith(
          _$ScanRequestImpl value, $Res Function(_$ScanRequestImpl) then) =
      __$$ScanRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String imagePath,
      double latitude,
      double longitude,
      double? radius,
      @JsonKey(name: 'premium_only') bool? premiumOnly,
      @JsonKey(name: 'confidence_threshold') double? confidenceThreshold,
      @JsonKey(name: 'use_fallback') bool? useFallback});
}

/// @nodoc
class __$$ScanRequestImplCopyWithImpl<$Res>
    extends _$ScanRequestCopyWithImpl<$Res, _$ScanRequestImpl>
    implements _$$ScanRequestImplCopyWith<$Res> {
  __$$ScanRequestImplCopyWithImpl(
      _$ScanRequestImpl _value, $Res Function(_$ScanRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? radius = freezed,
    Object? premiumOnly = freezed,
    Object? confidenceThreshold = freezed,
    Object? useFallback = freezed,
  }) {
    return _then(_$ScanRequestImpl(
      imagePath: null == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      radius: freezed == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double?,
      premiumOnly: freezed == premiumOnly
          ? _value.premiumOnly
          : premiumOnly // ignore: cast_nullable_to_non_nullable
              as bool?,
      confidenceThreshold: freezed == confidenceThreshold
          ? _value.confidenceThreshold
          : confidenceThreshold // ignore: cast_nullable_to_non_nullable
              as double?,
      useFallback: freezed == useFallback
          ? _value.useFallback
          : useFallback // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanRequestImpl implements _ScanRequest {
  const _$ScanRequestImpl(
      {required this.imagePath,
      required this.latitude,
      required this.longitude,
      this.radius,
      @JsonKey(name: 'premium_only') this.premiumOnly,
      @JsonKey(name: 'confidence_threshold') this.confidenceThreshold,
      @JsonKey(name: 'use_fallback') this.useFallback});

  factory _$ScanRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanRequestImplFromJson(json);

  @override
  final String imagePath;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final double? radius;
  @override
  @JsonKey(name: 'premium_only')
  final bool? premiumOnly;
  @override
  @JsonKey(name: 'confidence_threshold')
  final double? confidenceThreshold;
  @override
  @JsonKey(name: 'use_fallback')
  final bool? useFallback;

  @override
  String toString() {
    return 'ScanRequest(imagePath: $imagePath, latitude: $latitude, longitude: $longitude, radius: $radius, premiumOnly: $premiumOnly, confidenceThreshold: $confidenceThreshold, useFallback: $useFallback)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanRequestImpl &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            (identical(other.premiumOnly, premiumOnly) ||
                other.premiumOnly == premiumOnly) &&
            (identical(other.confidenceThreshold, confidenceThreshold) ||
                other.confidenceThreshold == confidenceThreshold) &&
            (identical(other.useFallback, useFallback) ||
                other.useFallback == useFallback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, imagePath, latitude, longitude,
      radius, premiumOnly, confidenceThreshold, useFallback);

  /// Create a copy of ScanRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanRequestImplCopyWith<_$ScanRequestImpl> get copyWith =>
      __$$ScanRequestImplCopyWithImpl<_$ScanRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanRequestImplToJson(
      this,
    );
  }
}

abstract class _ScanRequest implements ScanRequest {
  const factory _ScanRequest(
      {required final String imagePath,
      required final double latitude,
      required final double longitude,
      final double? radius,
      @JsonKey(name: 'premium_only') final bool? premiumOnly,
      @JsonKey(name: 'confidence_threshold') final double? confidenceThreshold,
      @JsonKey(name: 'use_fallback')
      final bool? useFallback}) = _$ScanRequestImpl;

  factory _ScanRequest.fromJson(Map<String, dynamic> json) =
      _$ScanRequestImpl.fromJson;

  @override
  String get imagePath;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double? get radius;
  @override
  @JsonKey(name: 'premium_only')
  bool? get premiumOnly;
  @override
  @JsonKey(name: 'confidence_threshold')
  double? get confidenceThreshold;
  @override
  @JsonKey(name: 'use_fallback')
  bool? get useFallback;

  /// Create a copy of ScanRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanRequestImplCopyWith<_$ScanRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanHistory _$ScanHistoryFromJson(Map<String, dynamic> json) {
  return _ScanHistory.fromJson(json);
}

/// @nodoc
mixin _$ScanHistory {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_path')
  String? get imagePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'scan_result')
  ScanResult? get scanResult => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_found')
  int get itemsFound => throw _privateConstructorUsedError;
  @JsonKey(name: 'alternatives_found')
  int get alternativesFound => throw _privateConstructorUsedError;
  @JsonKey(name: 'potential_savings')
  double get potentialSavings => throw _privateConstructorUsedError;
  @JsonKey(name: 'confidence_score')
  double? get confidenceScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'processing_time')
  int? get processingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_latitude')
  double? get userLatitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_longitude')
  double? get userLongitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_info')
  Map<String, dynamic>? get deviceInfo => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ScanHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanHistoryCopyWith<ScanHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanHistoryCopyWith<$Res> {
  factory $ScanHistoryCopyWith(
          ScanHistory value, $Res Function(ScanHistory) then) =
      _$ScanHistoryCopyWithImpl<$Res, ScanHistory>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'image_path') String? imagePath,
      @JsonKey(name: 'scan_result') ScanResult? scanResult,
      @JsonKey(name: 'items_found') int itemsFound,
      @JsonKey(name: 'alternatives_found') int alternativesFound,
      @JsonKey(name: 'potential_savings') double potentialSavings,
      @JsonKey(name: 'confidence_score') double? confidenceScore,
      @JsonKey(name: 'processing_time') int? processingTime,
      @JsonKey(name: 'user_latitude') double? userLatitude,
      @JsonKey(name: 'user_longitude') double? userLongitude,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'device_info') Map<String, dynamic>? deviceInfo,
      @JsonKey(name: 'created_at') DateTime createdAt});

  $ScanResultCopyWith<$Res>? get scanResult;
}

/// @nodoc
class _$ScanHistoryCopyWithImpl<$Res, $Val extends ScanHistory>
    implements $ScanHistoryCopyWith<$Res> {
  _$ScanHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imagePath = freezed,
    Object? scanResult = freezed,
    Object? itemsFound = null,
    Object? alternativesFound = null,
    Object? potentialSavings = null,
    Object? confidenceScore = freezed,
    Object? processingTime = freezed,
    Object? userLatitude = freezed,
    Object? userLongitude = freezed,
    Object? userId = freezed,
    Object? deviceInfo = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      scanResult: freezed == scanResult
          ? _value.scanResult
          : scanResult // ignore: cast_nullable_to_non_nullable
              as ScanResult?,
      itemsFound: null == itemsFound
          ? _value.itemsFound
          : itemsFound // ignore: cast_nullable_to_non_nullable
              as int,
      alternativesFound: null == alternativesFound
          ? _value.alternativesFound
          : alternativesFound // ignore: cast_nullable_to_non_nullable
              as int,
      potentialSavings: null == potentialSavings
          ? _value.potentialSavings
          : potentialSavings // ignore: cast_nullable_to_non_nullable
              as double,
      confidenceScore: freezed == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double?,
      processingTime: freezed == processingTime
          ? _value.processingTime
          : processingTime // ignore: cast_nullable_to_non_nullable
              as int?,
      userLatitude: freezed == userLatitude
          ? _value.userLatitude
          : userLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      userLongitude: freezed == userLongitude
          ? _value.userLongitude
          : userLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: freezed == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of ScanHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScanResultCopyWith<$Res>? get scanResult {
    if (_value.scanResult == null) {
      return null;
    }

    return $ScanResultCopyWith<$Res>(_value.scanResult!, (value) {
      return _then(_value.copyWith(scanResult: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScanHistoryImplCopyWith<$Res>
    implements $ScanHistoryCopyWith<$Res> {
  factory _$$ScanHistoryImplCopyWith(
          _$ScanHistoryImpl value, $Res Function(_$ScanHistoryImpl) then) =
      __$$ScanHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'image_path') String? imagePath,
      @JsonKey(name: 'scan_result') ScanResult? scanResult,
      @JsonKey(name: 'items_found') int itemsFound,
      @JsonKey(name: 'alternatives_found') int alternativesFound,
      @JsonKey(name: 'potential_savings') double potentialSavings,
      @JsonKey(name: 'confidence_score') double? confidenceScore,
      @JsonKey(name: 'processing_time') int? processingTime,
      @JsonKey(name: 'user_latitude') double? userLatitude,
      @JsonKey(name: 'user_longitude') double? userLongitude,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'device_info') Map<String, dynamic>? deviceInfo,
      @JsonKey(name: 'created_at') DateTime createdAt});

  @override
  $ScanResultCopyWith<$Res>? get scanResult;
}

/// @nodoc
class __$$ScanHistoryImplCopyWithImpl<$Res>
    extends _$ScanHistoryCopyWithImpl<$Res, _$ScanHistoryImpl>
    implements _$$ScanHistoryImplCopyWith<$Res> {
  __$$ScanHistoryImplCopyWithImpl(
      _$ScanHistoryImpl _value, $Res Function(_$ScanHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imagePath = freezed,
    Object? scanResult = freezed,
    Object? itemsFound = null,
    Object? alternativesFound = null,
    Object? potentialSavings = null,
    Object? confidenceScore = freezed,
    Object? processingTime = freezed,
    Object? userLatitude = freezed,
    Object? userLongitude = freezed,
    Object? userId = freezed,
    Object? deviceInfo = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$ScanHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      scanResult: freezed == scanResult
          ? _value.scanResult
          : scanResult // ignore: cast_nullable_to_non_nullable
              as ScanResult?,
      itemsFound: null == itemsFound
          ? _value.itemsFound
          : itemsFound // ignore: cast_nullable_to_non_nullable
              as int,
      alternativesFound: null == alternativesFound
          ? _value.alternativesFound
          : alternativesFound // ignore: cast_nullable_to_non_nullable
              as int,
      potentialSavings: null == potentialSavings
          ? _value.potentialSavings
          : potentialSavings // ignore: cast_nullable_to_non_nullable
              as double,
      confidenceScore: freezed == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double?,
      processingTime: freezed == processingTime
          ? _value.processingTime
          : processingTime // ignore: cast_nullable_to_non_nullable
              as int?,
      userLatitude: freezed == userLatitude
          ? _value.userLatitude
          : userLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      userLongitude: freezed == userLongitude
          ? _value.userLongitude
          : userLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: freezed == deviceInfo
          ? _value._deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanHistoryImpl implements _ScanHistory {
  const _$ScanHistoryImpl(
      {required this.id,
      @JsonKey(name: 'image_path') this.imagePath,
      @JsonKey(name: 'scan_result') this.scanResult,
      @JsonKey(name: 'items_found') required this.itemsFound,
      @JsonKey(name: 'alternatives_found') required this.alternativesFound,
      @JsonKey(name: 'potential_savings') required this.potentialSavings,
      @JsonKey(name: 'confidence_score') this.confidenceScore,
      @JsonKey(name: 'processing_time') this.processingTime,
      @JsonKey(name: 'user_latitude') this.userLatitude,
      @JsonKey(name: 'user_longitude') this.userLongitude,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'device_info') final Map<String, dynamic>? deviceInfo,
      @JsonKey(name: 'created_at') required this.createdAt})
      : _deviceInfo = deviceInfo;

  factory _$ScanHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanHistoryImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'image_path')
  final String? imagePath;
  @override
  @JsonKey(name: 'scan_result')
  final ScanResult? scanResult;
  @override
  @JsonKey(name: 'items_found')
  final int itemsFound;
  @override
  @JsonKey(name: 'alternatives_found')
  final int alternativesFound;
  @override
  @JsonKey(name: 'potential_savings')
  final double potentialSavings;
  @override
  @JsonKey(name: 'confidence_score')
  final double? confidenceScore;
  @override
  @JsonKey(name: 'processing_time')
  final int? processingTime;
  @override
  @JsonKey(name: 'user_latitude')
  final double? userLatitude;
  @override
  @JsonKey(name: 'user_longitude')
  final double? userLongitude;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  final Map<String, dynamic>? _deviceInfo;
  @override
  @JsonKey(name: 'device_info')
  Map<String, dynamic>? get deviceInfo {
    final value = _deviceInfo;
    if (value == null) return null;
    if (_deviceInfo is EqualUnmodifiableMapView) return _deviceInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'ScanHistory(id: $id, imagePath: $imagePath, scanResult: $scanResult, itemsFound: $itemsFound, alternativesFound: $alternativesFound, potentialSavings: $potentialSavings, confidenceScore: $confidenceScore, processingTime: $processingTime, userLatitude: $userLatitude, userLongitude: $userLongitude, userId: $userId, deviceInfo: $deviceInfo, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.scanResult, scanResult) ||
                other.scanResult == scanResult) &&
            (identical(other.itemsFound, itemsFound) ||
                other.itemsFound == itemsFound) &&
            (identical(other.alternativesFound, alternativesFound) ||
                other.alternativesFound == alternativesFound) &&
            (identical(other.potentialSavings, potentialSavings) ||
                other.potentialSavings == potentialSavings) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.processingTime, processingTime) ||
                other.processingTime == processingTime) &&
            (identical(other.userLatitude, userLatitude) ||
                other.userLatitude == userLatitude) &&
            (identical(other.userLongitude, userLongitude) ||
                other.userLongitude == userLongitude) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._deviceInfo, _deviceInfo) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      imagePath,
      scanResult,
      itemsFound,
      alternativesFound,
      potentialSavings,
      confidenceScore,
      processingTime,
      userLatitude,
      userLongitude,
      userId,
      const DeepCollectionEquality().hash(_deviceInfo),
      createdAt);

  /// Create a copy of ScanHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanHistoryImplCopyWith<_$ScanHistoryImpl> get copyWith =>
      __$$ScanHistoryImplCopyWithImpl<_$ScanHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanHistoryImplToJson(
      this,
    );
  }
}

abstract class _ScanHistory implements ScanHistory {
  const factory _ScanHistory(
      {required final String id,
      @JsonKey(name: 'image_path') final String? imagePath,
      @JsonKey(name: 'scan_result') final ScanResult? scanResult,
      @JsonKey(name: 'items_found') required final int itemsFound,
      @JsonKey(name: 'alternatives_found') required final int alternativesFound,
      @JsonKey(name: 'potential_savings')
      required final double potentialSavings,
      @JsonKey(name: 'confidence_score') final double? confidenceScore,
      @JsonKey(name: 'processing_time') final int? processingTime,
      @JsonKey(name: 'user_latitude') final double? userLatitude,
      @JsonKey(name: 'user_longitude') final double? userLongitude,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'device_info') final Map<String, dynamic>? deviceInfo,
      @JsonKey(name: 'created_at')
      required final DateTime createdAt}) = _$ScanHistoryImpl;

  factory _ScanHistory.fromJson(Map<String, dynamic> json) =
      _$ScanHistoryImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'image_path')
  String? get imagePath;
  @override
  @JsonKey(name: 'scan_result')
  ScanResult? get scanResult;
  @override
  @JsonKey(name: 'items_found')
  int get itemsFound;
  @override
  @JsonKey(name: 'alternatives_found')
  int get alternativesFound;
  @override
  @JsonKey(name: 'potential_savings')
  double get potentialSavings;
  @override
  @JsonKey(name: 'confidence_score')
  double? get confidenceScore;
  @override
  @JsonKey(name: 'processing_time')
  int? get processingTime;
  @override
  @JsonKey(name: 'user_latitude')
  double? get userLatitude;
  @override
  @JsonKey(name: 'user_longitude')
  double? get userLongitude;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'device_info')
  Map<String, dynamic>? get deviceInfo;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// Create a copy of ScanHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanHistoryImplCopyWith<_$ScanHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScanAnalytics _$ScanAnalyticsFromJson(Map<String, dynamic> json) {
  return _ScanAnalytics.fromJson(json);
}

/// @nodoc
mixin _$ScanAnalytics {
  @JsonKey(name: 'total_scans')
  int get totalScans => throw _privateConstructorUsedError;
  @JsonKey(name: 'successful_scans')
  int get successfulScans => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_savings')
  double get totalSavings => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_processing_time')
  int get avgProcessingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'unique_users')
  int get uniqueUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'popular_items')
  List<PopularItem>? get popularItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_rate')
  double get errorRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'date')
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this ScanAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanAnalyticsCopyWith<ScanAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanAnalyticsCopyWith<$Res> {
  factory $ScanAnalyticsCopyWith(
          ScanAnalytics value, $Res Function(ScanAnalytics) then) =
      _$ScanAnalyticsCopyWithImpl<$Res, ScanAnalytics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_scans') int totalScans,
      @JsonKey(name: 'successful_scans') int successfulScans,
      @JsonKey(name: 'total_savings') double totalSavings,
      @JsonKey(name: 'avg_processing_time') int avgProcessingTime,
      @JsonKey(name: 'unique_users') int uniqueUsers,
      @JsonKey(name: 'popular_items') List<PopularItem>? popularItems,
      @JsonKey(name: 'error_rate') double errorRate,
      @JsonKey(name: 'date') DateTime date});
}

/// @nodoc
class _$ScanAnalyticsCopyWithImpl<$Res, $Val extends ScanAnalytics>
    implements $ScanAnalyticsCopyWith<$Res> {
  _$ScanAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalScans = null,
    Object? successfulScans = null,
    Object? totalSavings = null,
    Object? avgProcessingTime = null,
    Object? uniqueUsers = null,
    Object? popularItems = freezed,
    Object? errorRate = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      totalScans: null == totalScans
          ? _value.totalScans
          : totalScans // ignore: cast_nullable_to_non_nullable
              as int,
      successfulScans: null == successfulScans
          ? _value.successfulScans
          : successfulScans // ignore: cast_nullable_to_non_nullable
              as int,
      totalSavings: null == totalSavings
          ? _value.totalSavings
          : totalSavings // ignore: cast_nullable_to_non_nullable
              as double,
      avgProcessingTime: null == avgProcessingTime
          ? _value.avgProcessingTime
          : avgProcessingTime // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueUsers: null == uniqueUsers
          ? _value.uniqueUsers
          : uniqueUsers // ignore: cast_nullable_to_non_nullable
              as int,
      popularItems: freezed == popularItems
          ? _value.popularItems
          : popularItems // ignore: cast_nullable_to_non_nullable
              as List<PopularItem>?,
      errorRate: null == errorRate
          ? _value.errorRate
          : errorRate // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanAnalyticsImplCopyWith<$Res>
    implements $ScanAnalyticsCopyWith<$Res> {
  factory _$$ScanAnalyticsImplCopyWith(
          _$ScanAnalyticsImpl value, $Res Function(_$ScanAnalyticsImpl) then) =
      __$$ScanAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_scans') int totalScans,
      @JsonKey(name: 'successful_scans') int successfulScans,
      @JsonKey(name: 'total_savings') double totalSavings,
      @JsonKey(name: 'avg_processing_time') int avgProcessingTime,
      @JsonKey(name: 'unique_users') int uniqueUsers,
      @JsonKey(name: 'popular_items') List<PopularItem>? popularItems,
      @JsonKey(name: 'error_rate') double errorRate,
      @JsonKey(name: 'date') DateTime date});
}

/// @nodoc
class __$$ScanAnalyticsImplCopyWithImpl<$Res>
    extends _$ScanAnalyticsCopyWithImpl<$Res, _$ScanAnalyticsImpl>
    implements _$$ScanAnalyticsImplCopyWith<$Res> {
  __$$ScanAnalyticsImplCopyWithImpl(
      _$ScanAnalyticsImpl _value, $Res Function(_$ScanAnalyticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalScans = null,
    Object? successfulScans = null,
    Object? totalSavings = null,
    Object? avgProcessingTime = null,
    Object? uniqueUsers = null,
    Object? popularItems = freezed,
    Object? errorRate = null,
    Object? date = null,
  }) {
    return _then(_$ScanAnalyticsImpl(
      totalScans: null == totalScans
          ? _value.totalScans
          : totalScans // ignore: cast_nullable_to_non_nullable
              as int,
      successfulScans: null == successfulScans
          ? _value.successfulScans
          : successfulScans // ignore: cast_nullable_to_non_nullable
              as int,
      totalSavings: null == totalSavings
          ? _value.totalSavings
          : totalSavings // ignore: cast_nullable_to_non_nullable
              as double,
      avgProcessingTime: null == avgProcessingTime
          ? _value.avgProcessingTime
          : avgProcessingTime // ignore: cast_nullable_to_non_nullable
              as int,
      uniqueUsers: null == uniqueUsers
          ? _value.uniqueUsers
          : uniqueUsers // ignore: cast_nullable_to_non_nullable
              as int,
      popularItems: freezed == popularItems
          ? _value._popularItems
          : popularItems // ignore: cast_nullable_to_non_nullable
              as List<PopularItem>?,
      errorRate: null == errorRate
          ? _value.errorRate
          : errorRate // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanAnalyticsImpl implements _ScanAnalytics {
  const _$ScanAnalyticsImpl(
      {@JsonKey(name: 'total_scans') required this.totalScans,
      @JsonKey(name: 'successful_scans') required this.successfulScans,
      @JsonKey(name: 'total_savings') required this.totalSavings,
      @JsonKey(name: 'avg_processing_time') required this.avgProcessingTime,
      @JsonKey(name: 'unique_users') required this.uniqueUsers,
      @JsonKey(name: 'popular_items') final List<PopularItem>? popularItems,
      @JsonKey(name: 'error_rate') required this.errorRate,
      @JsonKey(name: 'date') required this.date})
      : _popularItems = popularItems;

  factory _$ScanAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanAnalyticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_scans')
  final int totalScans;
  @override
  @JsonKey(name: 'successful_scans')
  final int successfulScans;
  @override
  @JsonKey(name: 'total_savings')
  final double totalSavings;
  @override
  @JsonKey(name: 'avg_processing_time')
  final int avgProcessingTime;
  @override
  @JsonKey(name: 'unique_users')
  final int uniqueUsers;
  final List<PopularItem>? _popularItems;
  @override
  @JsonKey(name: 'popular_items')
  List<PopularItem>? get popularItems {
    final value = _popularItems;
    if (value == null) return null;
    if (_popularItems is EqualUnmodifiableListView) return _popularItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'error_rate')
  final double errorRate;
  @override
  @JsonKey(name: 'date')
  final DateTime date;

  @override
  String toString() {
    return 'ScanAnalytics(totalScans: $totalScans, successfulScans: $successfulScans, totalSavings: $totalSavings, avgProcessingTime: $avgProcessingTime, uniqueUsers: $uniqueUsers, popularItems: $popularItems, errorRate: $errorRate, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanAnalyticsImpl &&
            (identical(other.totalScans, totalScans) ||
                other.totalScans == totalScans) &&
            (identical(other.successfulScans, successfulScans) ||
                other.successfulScans == successfulScans) &&
            (identical(other.totalSavings, totalSavings) ||
                other.totalSavings == totalSavings) &&
            (identical(other.avgProcessingTime, avgProcessingTime) ||
                other.avgProcessingTime == avgProcessingTime) &&
            (identical(other.uniqueUsers, uniqueUsers) ||
                other.uniqueUsers == uniqueUsers) &&
            const DeepCollectionEquality()
                .equals(other._popularItems, _popularItems) &&
            (identical(other.errorRate, errorRate) ||
                other.errorRate == errorRate) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalScans,
      successfulScans,
      totalSavings,
      avgProcessingTime,
      uniqueUsers,
      const DeepCollectionEquality().hash(_popularItems),
      errorRate,
      date);

  /// Create a copy of ScanAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanAnalyticsImplCopyWith<_$ScanAnalyticsImpl> get copyWith =>
      __$$ScanAnalyticsImplCopyWithImpl<_$ScanAnalyticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanAnalyticsImplToJson(
      this,
    );
  }
}

abstract class _ScanAnalytics implements ScanAnalytics {
  const factory _ScanAnalytics(
          {@JsonKey(name: 'total_scans') required final int totalScans,
          @JsonKey(name: 'successful_scans') required final int successfulScans,
          @JsonKey(name: 'total_savings') required final double totalSavings,
          @JsonKey(name: 'avg_processing_time')
          required final int avgProcessingTime,
          @JsonKey(name: 'unique_users') required final int uniqueUsers,
          @JsonKey(name: 'popular_items') final List<PopularItem>? popularItems,
          @JsonKey(name: 'error_rate') required final double errorRate,
          @JsonKey(name: 'date') required final DateTime date}) =
      _$ScanAnalyticsImpl;

  factory _ScanAnalytics.fromJson(Map<String, dynamic> json) =
      _$ScanAnalyticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_scans')
  int get totalScans;
  @override
  @JsonKey(name: 'successful_scans')
  int get successfulScans;
  @override
  @JsonKey(name: 'total_savings')
  double get totalSavings;
  @override
  @JsonKey(name: 'avg_processing_time')
  int get avgProcessingTime;
  @override
  @JsonKey(name: 'unique_users')
  int get uniqueUsers;
  @override
  @JsonKey(name: 'popular_items')
  List<PopularItem>? get popularItems;
  @override
  @JsonKey(name: 'error_rate')
  double get errorRate;
  @override
  @JsonKey(name: 'date')
  DateTime get date;

  /// Create a copy of ScanAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanAnalyticsImplCopyWith<_$ScanAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PopularItem _$PopularItemFromJson(Map<String, dynamic> json) {
  return _PopularItem.fromJson(json);
}

/// @nodoc
mixin _$PopularItem {
  String get name => throw _privateConstructorUsedError;
  int get scanCount => throw _privateConstructorUsedError;
  double get averagePrice => throw _privateConstructorUsedError;
  double get totalSavings => throw _privateConstructorUsedError;

  /// Serializes this PopularItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PopularItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PopularItemCopyWith<PopularItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PopularItemCopyWith<$Res> {
  factory $PopularItemCopyWith(
          PopularItem value, $Res Function(PopularItem) then) =
      _$PopularItemCopyWithImpl<$Res, PopularItem>;
  @useResult
  $Res call(
      {String name, int scanCount, double averagePrice, double totalSavings});
}

/// @nodoc
class _$PopularItemCopyWithImpl<$Res, $Val extends PopularItem>
    implements $PopularItemCopyWith<$Res> {
  _$PopularItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PopularItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? scanCount = null,
    Object? averagePrice = null,
    Object? totalSavings = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scanCount: null == scanCount
          ? _value.scanCount
          : scanCount // ignore: cast_nullable_to_non_nullable
              as int,
      averagePrice: null == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalSavings: null == totalSavings
          ? _value.totalSavings
          : totalSavings // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PopularItemImplCopyWith<$Res>
    implements $PopularItemCopyWith<$Res> {
  factory _$$PopularItemImplCopyWith(
          _$PopularItemImpl value, $Res Function(_$PopularItemImpl) then) =
      __$$PopularItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, int scanCount, double averagePrice, double totalSavings});
}

/// @nodoc
class __$$PopularItemImplCopyWithImpl<$Res>
    extends _$PopularItemCopyWithImpl<$Res, _$PopularItemImpl>
    implements _$$PopularItemImplCopyWith<$Res> {
  __$$PopularItemImplCopyWithImpl(
      _$PopularItemImpl _value, $Res Function(_$PopularItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PopularItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? scanCount = null,
    Object? averagePrice = null,
    Object? totalSavings = null,
  }) {
    return _then(_$PopularItemImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      scanCount: null == scanCount
          ? _value.scanCount
          : scanCount // ignore: cast_nullable_to_non_nullable
              as int,
      averagePrice: null == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double,
      totalSavings: null == totalSavings
          ? _value.totalSavings
          : totalSavings // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PopularItemImpl implements _PopularItem {
  const _$PopularItemImpl(
      {required this.name,
      required this.scanCount,
      required this.averagePrice,
      required this.totalSavings});

  factory _$PopularItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PopularItemImplFromJson(json);

  @override
  final String name;
  @override
  final int scanCount;
  @override
  final double averagePrice;
  @override
  final double totalSavings;

  @override
  String toString() {
    return 'PopularItem(name: $name, scanCount: $scanCount, averagePrice: $averagePrice, totalSavings: $totalSavings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PopularItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.scanCount, scanCount) ||
                other.scanCount == scanCount) &&
            (identical(other.averagePrice, averagePrice) ||
                other.averagePrice == averagePrice) &&
            (identical(other.totalSavings, totalSavings) ||
                other.totalSavings == totalSavings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, scanCount, averagePrice, totalSavings);

  /// Create a copy of PopularItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PopularItemImplCopyWith<_$PopularItemImpl> get copyWith =>
      __$$PopularItemImplCopyWithImpl<_$PopularItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PopularItemImplToJson(
      this,
    );
  }
}

abstract class _PopularItem implements PopularItem {
  const factory _PopularItem(
      {required final String name,
      required final int scanCount,
      required final double averagePrice,
      required final double totalSavings}) = _$PopularItemImpl;

  factory _PopularItem.fromJson(Map<String, dynamic> json) =
      _$PopularItemImpl.fromJson;

  @override
  String get name;
  @override
  int get scanCount;
  @override
  double get averagePrice;
  @override
  double get totalSavings;

  /// Create a copy of PopularItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PopularItemImplCopyWith<_$PopularItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
