// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo_file.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getNameHash() => r'e6054c56073328d97e24e5240ce0775e3212af96';

/// See also [getName].
@ProviderFor(getName)
final getNameProvider = AutoDisposeProvider<String>.internal(
  getName,
  name: r'getNameProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getNameHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetNameRef = AutoDisposeProviderRef<String>;
String _$myStateNotifierHash() => r'6a685f1ac96bb880efe75018d60fa6ab2fe4e0ab';

/// See also [MyStateNotifier].
@ProviderFor(MyStateNotifier)
final myStateNotifierProvider =
    AutoDisposeNotifierProvider<MyStateNotifier, int>.internal(
  MyStateNotifier.new,
  name: r'myStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$myStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyStateNotifier = AutoDisposeNotifier<int>;
String _$myAddressHash() => r'e7f9e45fc5007bdd0c19b2df9e3e128ffbc1a0e6';

/// See also [MyAddress].
@ProviderFor(MyAddress)
final myAddressProvider =
    AutoDisposeAsyncNotifierProvider<MyAddress, Address>.internal(
  MyAddress.new,
  name: r'myAddressProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myAddressHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MyAddress = AutoDisposeAsyncNotifier<Address>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
