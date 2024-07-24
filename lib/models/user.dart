class User {
  String? name;
  String? email;
  String? createTicketLink;
  String? contactMobile;
  String? token;

  User(
      {this.name,
        this.email,
        this.createTicketLink,
        this.contactMobile,
        this.token});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    createTicketLink = json['createTicketLink'];
    contactMobile = json['contactMobile'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['createTicketLink'] = this.createTicketLink;
    data['contactMobile'] = this.contactMobile;
    data['token'] = this.token;
    return data;
  }
}