import 'base_repository.dart';

abstract class ModelRepositoryInsert<InsertRequest> {
  /// Inserts a single row.
  /// Updated: void to dynamic
  Future<dynamic> insertOne(InsertRequest request);

  /// Inserts multiple rows.
  /// Updated: void to dynamic
  Future<dynamic> insertMany(List<InsertRequest> requests);
}

abstract class KeyedModelRepositoryInsert<InsertRequest> {
  /// Inserts a single row and returns its generated key.
  Future<int> insertOne(InsertRequest request);

  /// Inserts multiple rows and returns their generated keys.
  Future<List<int>> insertMany(List<InsertRequest> requests);
}

mixin RepositoryInsertMixin<InsertRequest> on BaseRepository
    implements ModelRepositoryInsert<InsertRequest> {
  Future<dynamic> insert(List<InsertRequest> requests);

  @override
  Future<dynamic> insertOne(InsertRequest request) => insert([request]);
  @override
  Future<dynamic> insertMany(List<InsertRequest> requests) => insert(requests);
}

mixin KeyedRepositoryInsertMixin<InsertRequest> on BaseRepository
    implements KeyedModelRepositoryInsert<InsertRequest> {
  Future<List<int>> insert(List<InsertRequest> requests);

  @override
  Future<int> insertOne(InsertRequest request) async {
    final results = await insert([request]);
    return results.first;
  }

  @override
  Future<List<int>> insertMany(List<InsertRequest> requests) => insert(requests);
}
