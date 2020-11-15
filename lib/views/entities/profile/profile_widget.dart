import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/users_service.dart';
import 'package:azkar/views/home_page.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {

  ProfileWidget() {
    HomePage.setAppBarTitle("Profile");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UsersService().getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<GetUserResponse> snapshot) {
          if (snapshot.hasData) {
            GetUserResponse response = snapshot.data;

            if (response.hasError()) {
              return Text(response.error.errorMessage);
            }

            return Column(children: [
                 Text('Name: ${response.user.name}'),
                 Text('Email: ${response.user.email}'),
                 Text('Username: ${response.user.username}'),
            ],);
          } else if (snapshot.hasError) {
            // TODO(omorsi): Handle error
            return Text('Error');
          } else {
            // TODO(omorsi): Show loader
            return Text('Waiting');
          }
        });
  }

}
