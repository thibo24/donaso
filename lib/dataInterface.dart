abstract class DataInterface {
  Future<List<Map<String, dynamic>>> getAllFromCollection(
      String collectionName);

  Future<void> addUser(
      String username, String password, String email, String phone);

  Future<bool> checkUserIsAvailable(String username);

  Future<bool> checkUser(String user, String password);

  Future<List<Map<String, dynamic>>> findLocationsNearby(
      double longitude, double latitude, double? maxDistance);

  Future<List<Map<String, dynamic>>> findLocationsNearbyByType(
      double longitude, double latitude, String type);

  Future<void> insertLocation(double longitude, double latitude, String name,
      String description, String type);

  Future<void> addUserGoogle(
      String email, String firstName, String lastName, String username);

  bool checkUserGoogle(String email);
}
