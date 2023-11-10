// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$csvRepositoryHash() => r'82097f5d95fea6a1f635bf1cc6a75295cbadd40d';

/// See also [csvRepository].
@ProviderFor(csvRepository)
final csvRepositoryProvider = AutoDisposeProvider<CsvRepository>.internal(
  csvRepository,
  name: r'csvRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$csvRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CsvRepositoryRef = AutoDisposeProviderRef<CsvRepository>;
String _$csvNotifierHash() => r'e20be8aa39ce8bce88c624c9359edf6e0d550f98';

/// See also [CsvNotifier].
@ProviderFor(CsvNotifier)
final csvNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CsvNotifier, bool>.internal(
  CsvNotifier.new,
  name: r'csvNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$csvNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CsvNotifier = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
