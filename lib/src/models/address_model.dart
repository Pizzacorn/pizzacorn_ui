/// Modelo reutilizable para direcciones guardadas desde Firebase.
class AddressModel {
  final String city;
  final String community;
  final String country;
  final String street;
  final String name;
  final String state;
  final String province;
  final String placeID;

  AddressModel({
    this.city = '',
    this.community = '',
    this.country = '',
    this.street = '',
    this.name = '',
    this.state = '',
    this.province = '',
    this.placeID = '',
  });

  factory AddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AddressModel();
    }

    final String streetValue =
        json['street'] as String? ?? json['name'] as String? ?? '';
    final String provinceValue =
        json['province'] as String? ?? json['state'] as String? ?? '';

    return AddressModel(
      city: json['city'] as String? ?? '',
      community: json['community'] as String? ?? '',
      country: json['country'] as String? ?? '',
      street: streetValue,
      name: streetValue,
      state: provinceValue,
      province: provinceValue,
      placeID: json['placeID'] as String? ?? '',
    );
  }

  AddressModel copyWith({
    String? city,
    String? community,
    String? country,
    String? street,
    String? name,
    String? state,
    String? province,
    String? placeID,
  }) {
    return AddressModel(
      city: city ?? this.city,
      community: community ?? this.community,
      country: country ?? this.country,
      street: street ?? this.street,
      name: name ?? this.name,
      state: state ?? this.state,
      province: province ?? this.province,
      placeID: placeID ?? this.placeID,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'community': community,
      'country': country,
      'street': street.isNotEmpty ? street : name,
      'province': province.isNotEmpty ? province : state,
      'placeID': placeID,
    };
  }
}
