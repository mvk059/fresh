abstract class DatabaseInterface {
  Future<int> insert(String table, Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> query(String table, {String? where});
  Future<int> update(String table, Map<String, dynamic> data, String where);
  Future<int> delete(String table, String where);
}