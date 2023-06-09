class User {
  late String email;
  late int nbPoints;
  late String username;
  late String image;

  User(
      {required this.email,
      required this.nbPoints,
      required this.username,
      required this.image});
  User.empty() {
    email = "";
    nbPoints = 0;
    username = "";
    image = "";
  }
}
