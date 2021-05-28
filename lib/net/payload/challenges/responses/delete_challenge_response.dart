import 'package:azkar/net/payload/response_base.dart';

class DeleteChallengeResponse extends ResponseBase {
  static DeleteChallengeResponse fromJson(Map<String, dynamic> json) {
    DeleteChallengeResponse response = new DeleteChallengeResponse();
    response.setError(json);
    if (response.hasError()) {
      return response;
    }
    return response;
  }
}
