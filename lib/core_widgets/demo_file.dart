import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'demo_file.g.dart';

@riverpod
String getName(GetNameRef ref) {
  return "Praneeth";
}

@riverpod
class MyStateNotifier extends _$MyStateNotifier {
  @override
  int build() {
    return 0; // Initial state
  }

  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }
}

@riverpod
class MyAddress extends _$MyAddress {
  @override
  Future<Address> build() async {
    await Future.delayed(const Duration(seconds: 2));

    return const Address(street: "123 Main St", city: "Springfield");
  }

  void updateStreet(String street) {
    state = state.whenData((address) => address.copyWith(
          street: street,
        ));
  }

  void updateCity(String city) {
    state = state.whenData((address) => address.copyWith(
          city: city,
        ));
  }
}

@immutable
class Address {
  final String street;
  final String city;

  const Address({required this.street, required this.city});

  Address copyWith({
    String? street,
    String? city,
  }) {
    return Address(
      street: street ?? this.street,
      city: city ?? this.city,
    );
  }

  @override
  String toString() {
    return 'Address(street: $street, city: $city)';
  }
}
