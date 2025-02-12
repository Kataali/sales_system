// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: (json['id'] as num?)?.toInt(),
      date: json['date'] as String?,
      status: json['status'] as String?,
      total: (json['total'] as num?)?.toDouble(),
      userId: (json['userId'] as num?)?.toInt(),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'status': instance.status,
      'total': instance.total,
      'userId': instance.userId,
      'products': instance.products,
    };
