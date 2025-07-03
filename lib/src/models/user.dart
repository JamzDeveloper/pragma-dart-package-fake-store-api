import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  Address address;
  int id;
  String email;
  String username;
  String password;
  Name name;
  String phone;
  int v;

  UserModel({
    required this.address,
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.phone,
    required this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    address: Address.fromJson(json["address"]),
    id: json["id"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    name: Name.fromJson(json["name"]),
    phone: json["phone"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "address": address.toJson(),
    "id": id,
    "email": email,
    "username": username,
    "password": password,
    "name": name.toJson(),
    "phone": phone,
    "__v": v,
  };
  @override
  String toString() {
    return '''
👤 Usuario:
🧾 ID: $id
📛 Nombre: ${name.firstname} ${name.lastname}
📧 Email: $email
👤 Username: $username
📞 Teléfono: $phone
📍 Dirección: $address
''';
  }
}

class Address {
  Geolocation geolocation;
  String city;
  String street;
  int number;
  String zipcode;

  Address({
    required this.geolocation,
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    geolocation: Geolocation.fromJson(json["geolocation"]),
    city: json["city"],
    street: json["street"],
    number: json["number"],
    zipcode: json["zipcode"],
  );

  Map<String, dynamic> toJson() => {
    "geolocation": geolocation.toJson(),
    "city": city,
    "street": street,
    "number": number,
    "zipcode": zipcode,
  };
  @override
  String toString() {
    return '$street #$number, $city ($zipcode), 📍Geo: $geolocation';
  }
}

class Geolocation {
  String lat;
  String long;

  Geolocation({required this.lat, required this.long});

  factory Geolocation.fromJson(Map<String, dynamic> json) =>
      Geolocation(lat: json["lat"], long: json["long"]);

  Map<String, dynamic> toJson() => {"lat": lat, "long": long};
  @override
  String toString() {
    return 'lat: $lat, long: $long';
  }
}

class Name {
  String firstname;
  String lastname;

  Name({required this.firstname, required this.lastname});

  factory Name.fromJson(Map<String, dynamic> json) =>
      Name(firstname: json["firstname"], lastname: json["lastname"]);

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
  };
}
