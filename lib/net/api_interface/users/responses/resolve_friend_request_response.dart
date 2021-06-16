import 'package:azkar/net/payload/response_base.dart';

class ResolveFriendRequestResponse extends ResponseBase {
  static ResolveFriendRequestResponse fromJson(Map<String, dynamic> json) {
    ResolveFriendRequestResponse response = new ResolveFriendRequestResponse();
    response.setError(json);
    return response;
  }
}
