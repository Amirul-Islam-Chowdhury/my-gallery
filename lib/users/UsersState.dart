class UserState {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;

  UserState({this.uid, this.email, this.firstName, this.secondName});

  factory UserState.fromMap(map) {
    return UserState(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
    };
  }
}
