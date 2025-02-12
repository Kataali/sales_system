import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product{
   const factory Product({
    required String? imgUrl,
    required int? id,
    required String? name,
    required double? price,
    required int? quantity,
    required String? category,
    required String? size}) = _Product;

    factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}