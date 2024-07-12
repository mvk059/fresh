abstract class NetworkInterface {
  Future<Map<String, dynamic>> get(String endpoint);

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data);

  Future<List<Map<String, dynamic>>> syncCoordinates(
      List<Map<String, dynamic>> coordinates);
}
