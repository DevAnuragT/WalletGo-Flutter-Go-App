class User {
  final String name;
  final String email;
  final String phone;
  final int balance;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.balance,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        balance: json['balance'],
      );
}
