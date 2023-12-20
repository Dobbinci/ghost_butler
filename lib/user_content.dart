
/*This class get contents from firestore collection 'user'*/
class UserContent {
  UserContent({required this.uid, required this.username, required this.age, required this.gender, required this.email});

  final String uid;
  final String username;
  final String age;
  final String gender;
  final String email;
}