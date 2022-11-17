// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocoding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeocodingResponse _$GeocodingResponseFromJson(Map<String, dynamic> json) => GeocodingResponse(
      status: json['status'] as String,
      errorMessage: json['errorMessage'] as String?,
      results: (json['results'] as List<dynamic>?)?.map((e) => GeocodingResult.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );

Map<String, dynamic> _$GeocodingResponseToJson(GeocodingResponse instance) => <String, dynamic>{
      'status': instance.status,
      'errorMessage': instance.errorMessage,
      'results': instance.results,
    };

GeocodingResult _$GeocodingResultFromJson(Map<String, dynamic> json) => GeocodingResult(
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      placeId: json['placeId'] as String,
      types: (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      addressComponents: (json['addressComponents'] as List<dynamic>?)?.map((e) => AddressComponent.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      postcodeLocalities: (json['postcodeLocalities'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      partialMatch: json['partialMatch'] as bool? ?? false,
      formattedAddress: json['formattedAddress'] as String?,
    );

Map<String, dynamic> _$GeocodingResultToJson(GeocodingResult instance) => <String, dynamic>{
      'types': instance.types,
      'formattedAddress': instance.formattedAddress,
      'addressComponents': instance.addressComponents,
      'postcodeLocalities': instance.postcodeLocalities,
      'geometry': instance.geometry,
      'partialMatch': instance.partialMatch,
      'placeId': instance.placeId,
    };

StreetAddress _$StreetAddressFromJson(Map<String, dynamic> json) => StreetAddress(
      geometry: json['geometry'] == null ? null : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      addressLine: json['addressLine'] as String?,
      countryName: json['countryName'] as String?,
      countryCode: json['countryCode'] as String?,
      featureName: json['featureName'] as String?,
      postalCode: json['postalCode'] as String?,
      adminArea: json['adminArea'] as String?,
      subAdminArea: json['subAdminArea'] as String?,
      locality: json['locality'] as String?,
      subLocality: json['subLocality'] as String?,
      thoroughfare: json['thoroughfare'] as String?,
      subThoroughfare: json['subThoroughfare'] as String?,
    );

Map<String, dynamic> _$StreetAddressToJson(StreetAddress instance) => <String, dynamic>{
      'geometry': instance.geometry,
      'addressLine': instance.addressLine,
      'countryName': instance.countryName,
      'countryCode': instance.countryCode,
      'featureName': instance.featureName,
      'postalCode': instance.postalCode,
      'adminArea': instance.adminArea,
      'subAdminArea': instance.subAdminArea,
      'locality': instance.locality,
      'subLocality': instance.subLocality,
      'thoroughfare': instance.thoroughfare,
      'subThoroughfare': instance.subThoroughfare,
    };
