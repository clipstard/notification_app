class Oauth {
  final String access_token;
  final int expires_in;
  final String jti;
  final String scope;
  final String token_type;

  Oauth({
    required this.access_token,
    required this.expires_in,
    required this.jti,
    required this.scope,
    required this.token_type,
  });

  factory Oauth.fromJson(dynamic json) => Oauth(
        access_token: json['access_token'] as String,
        expires_in: int.parse(json['expires_in'].toString()),
        jti: json['jti'] as String,
        scope: json['scope'] as String,
        token_type: json['token_type'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'access_token': this.access_token,
        'expires_in': this.expires_in.toString(),
        'jti': this.jti,
        'scope': this.scope,
        'token_type': this.token_type,
      };
}
