class Users {
  late String userid;
  late String ip;
  late String cmp;
  late String database;
  late String username;
  late String password;

  Users(this.userid,this.ip,this.cmp,this.database,this.username,this.password);

  Users.fromJson(Map<String, dynamic> json)
      : userid = json['userid'],
        ip = json['ip'],
        cmp = json['cmp'],
        database = json['database'],
        username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'userid': userid,
        'ip': ip,
        'database': database,
        'username': username,
        'password': password
      };
}
