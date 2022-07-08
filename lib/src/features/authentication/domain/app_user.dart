class AppUser {
  const AppUser({
    required this.uid,
    this.email,
  });
  final String uid;
  final String? email;
}