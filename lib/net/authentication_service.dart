import 'dart:convert';
import 'dart:io';

import 'package:azkar/net/api_caller.dart';
import 'package:azkar/net/endpoints.dart';
import 'package:azkar/net/payload/authentication/requests/email_login_request_body.dart';
import 'package:azkar/net/payload/authentication/requests/email_registration_request_body.dart';
import 'package:azkar/net/payload/authentication/requests/email_verification_request_body.dart';
import 'package:azkar/net/payload/authentication/requests/facebook_authentication_request_body.dart';
import 'package:azkar/net/payload/authentication/responses/email_login_response.dart';
import 'package:azkar/net/payload/authentication/responses/email_registration_response.dart';
import 'package:azkar/net/payload/authentication/responses/email_verification_response.dart';
import 'package:azkar/net/payload/authentication/responses/facebook_friends_response.dart';
import 'package:azkar/net/payload/response_error.dart';
import 'package:azkar/net/secure_storage_util.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

import '../net/payload/authentication/responses/facebook_authentication_response.dart';

class AuthenticationService {
  static const int FACEBOOK_INVALID_OAUTH_TOKEN_ERROR_CODE = 190;
  static const int MAXIMUM_FRIENDS_USING_APP_COUNT = 100;

  Future<FacebookAuthenticationResponse> loginWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final facebookGraphApiResponse = await _facebookLogin.logIn(['email']);

    FacebookAuthenticationResponse facebookAuthenticationResponse;
    switch (facebookGraphApiResponse.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken _facebookAccessToken =
            facebookGraphApiResponse.accessToken;
        await SecureStorageUtil.setFacebookToken(_facebookAccessToken.token);

        return _loginWithFacebookAccessToken(_facebookAccessToken);
      case FacebookLoginStatus.cancelledByUser:
        facebookAuthenticationResponse.error = new Error("Cancelled by user.");
        return new Future.value(facebookAuthenticationResponse);
      case FacebookLoginStatus.error:
        facebookAuthenticationResponse.error =
            new Error("Facebook login error.");
        return new Future.value(facebookAuthenticationResponse);
      default:
        facebookAuthenticationResponse.error = new Error("Internal Error");
        return new Future.value(facebookAuthenticationResponse);
    }
  }

  Future<FacebookAuthenticationResponse> _loginWithFacebookAccessToken(
      FacebookAccessToken facebookAccessToken) async {
    final http.Response apiResponse = await http.put(
        Uri.http(
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.LOGIN_WITH_FACEBOOK))),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(new FacebookAuthenticationRequestBody(
          facebookUserId: facebookAccessToken.userId,
          token: facebookAccessToken.token,
        ).toJson()));

    FacebookAuthenticationResponse response =
        FacebookAuthenticationResponse.fromJson(jsonDecode(apiResponse.body));
    if (!response.hasError()) {
      final jwtToken = apiResponse.headers[HttpHeaders.authorizationHeader];
      await SecureStorageUtil.setJwtToken(jwtToken);
    }
    return response;
  }

  Future<FacebookAuthenticationResponse> connectFacebook() async {
    final _facebookLogin = FacebookLogin();
    _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    final facebookGraphApiResponse =
        await _facebookLogin.logIn(['email', 'user_friends']);

    FacebookAuthenticationResponse facebookAuthenticationResponse;
    switch (facebookGraphApiResponse.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken facebookAccessToken =
            facebookGraphApiResponse.accessToken;
        await SecureStorageUtil.setFacebookToken(facebookAccessToken.token);

        return _connectFacebookWithFacebookAccessToken(facebookAccessToken);
      case FacebookLoginStatus.cancelledByUser:
        facebookAuthenticationResponse.error = new Error("Cancelled by user.");
        return facebookAuthenticationResponse;
      case FacebookLoginStatus.error:
        facebookAuthenticationResponse.error =
            new Error("Facebook login error.");
        return facebookAuthenticationResponse;
      default:
        facebookAuthenticationResponse.error = new Error("Internal Error");
        return facebookAuthenticationResponse;
    }
  }

  Future<FacebookAuthenticationResponse>
      _connectFacebookWithFacebookAccessToken(
          FacebookAccessToken facebookAccessToken) async {
    final http.Response apiResponse = await ApiCaller.put(
        route: Endpoint(endpointRoute: EndpointRoute.CONNECT_FACEBOOK),
        requestBody: FacebookAuthenticationRequestBody(
          facebookUserId: facebookAccessToken.userId,
          token: facebookAccessToken.token,
        ));

    FacebookAuthenticationResponse response =
        FacebookAuthenticationResponse.fromJson(jsonDecode(apiResponse.body));
    if (!response.hasError()) {
      final jwtToken = apiResponse.headers[HttpHeaders.authorizationHeader];
      await SecureStorageUtil.setJwtToken(jwtToken);
    }
    return response;
  }

  Future<FacebookFriendsResponse> getFacebookFriends() async {
    String facebookToken = await SecureStorageUtil.getFacebookToken();
    http.Response response = await http.get(
        "https://graph.facebook.com/v9.0/me/friends?access_token=$facebookToken&limit=$MAXIMUM_FRIENDS_USING_APP_COUNT");
    if (response.statusCode == FACEBOOK_INVALID_OAUTH_TOKEN_ERROR_CODE) {
      print('Invalid OAuth Token');
      // TODO('Ask the user to connect to facebook')
    }

    return FacebookFriendsResponse.fromJson(jsonDecode(response.body));
  }

  Future<EmailRegistrationResponse> signUp(
      EmailRegistrationRequestBody request) async {
    final http.Response apiResponse = await http.put(
      Uri.http(
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.REGISTER_WITH_EMAIL))),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    return EmailRegistrationResponse.fromJson(jsonDecode(apiResponse.body));
  }

  Future<EmailLoginResponse> login(EmailLoginRequestBody request) async {
    EmailLoginResponse emailLoginResponse;
    http.Response apiResponse;
    try {
      apiResponse = await http.put(
        Uri.http(
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
            ApiRoutesUtil.apiRouteToString(
                Endpoint(endpointRoute: EndpointRoute.LOGIN_WITH_EMAIL))),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );
    } catch (e) {
      print('Error: An exception while requesting:'
          '${ApiRoutesUtil.apiRouteToString(Endpoint(endpointRoute: EndpointRoute.LOGIN_WITH_EMAIL))} '
          'with stack trace: ${e.toString()}');
      emailLoginResponse = new EmailLoginResponse();
      emailLoginResponse.setErrorMessage(
          "Can't connect to the server. Please check your internet connection.");
      return emailLoginResponse;
    }

    emailLoginResponse =
        EmailLoginResponse.fromJson(jsonDecode(apiResponse.body));

    if (!emailLoginResponse.hasError()) {
      final jwtToken = apiResponse.headers[HttpHeaders.authorizationHeader];
      await SecureStorageUtil.setJwtToken(jwtToken);
    }
    return emailLoginResponse;
  }

  Future<EmailVerificationResponse> verifyEmail(
      EmailVerificationRequestBody request) async {
    final http.Response apiResponse = await http.put(
      Uri.http(
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.BASE_URL)),
          ApiRoutesUtil.apiRouteToString(
              Endpoint(endpointRoute: EndpointRoute.VERIFY_EMAIL))),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(request.toJson()),
    );

    return EmailVerificationResponse.fromJson(jsonDecode(apiResponse.body));
  }
}