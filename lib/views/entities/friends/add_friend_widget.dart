import 'package:azkar/models/user.dart';
import 'package:azkar/net/payload/authentication/responses/facebook_authentication_response.dart';
import 'package:azkar/net/payload/authentication/responses/facebook_friends_response.dart';
import 'package:azkar/net/payload/users/responses/add_friend_response.dart';
import 'package:azkar/net/payload/users/responses/get_friends_response.dart';
import 'package:azkar/net/payload/users/responses/get_user_response.dart';
import 'package:azkar/net/service_provider.dart';
import 'package:azkar/views/entities/friends/facebook_friends_screen.dart';
import 'package:azkar/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class AddFriendWidget extends StatefulWidget {

  AddFriendWidget({Key key})
      : super(key: key) {
    HomePage.setAppBarTitle('Add Friend');
  }

  @override
  _AddFriendWidgetState createState() => _AddFriendWidgetState();
}

class _AddFriendWidgetState extends State<AddFriendWidget> {
  final _formKey = GlobalKey<FormState>();

  String _friendUsername;
  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite friends'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  decoration: new InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    hintText: "Enter a username",
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                  ),
                  onChanged: (String username) {
                    _friendUsername = username;
                  },
                  validator: (val) {
                    if (val.contains(" ")) {
                      return "Username should have no spaces";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.text,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              // new Padding(
              //   padding: EdgeInsets.all(5),
              // ),
              buildTextWithIcon(),
              new Padding(
                padding: EdgeInsets.all(20),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.all(8.0),
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.25)),
                      ),
                    ),
                    Text(
                      "OR ADD FRIENDS WITH",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.all(8.0),
                        decoration:
                            BoxDecoration(border: Border.all(width: 0.25)),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: Color(0Xff3B5998),
                                onPressed: () => {},
                                child: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(
                                          left: 20.0,
                                        ),
                                      ),
                                      new Expanded(
                                        child: new FlatButton(
                                          onPressed: () =>
                                              onConnectFacebookPressed(),
                                          padding: EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                          ),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                const IconData(0xea90,
                                                    fontFamily: 'icomoon'),
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "CONNECT WITH FACEBOOK",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        padding: EdgeInsets.only(
                                          right: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(
                        alignment: Alignment.center,
                        child: new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new FlatButton(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                color: Color(0Xff3B5998),
                                onPressed: () => {},
                                child: new Container(
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Container(
                                        padding: EdgeInsets.only(
                                          left: 20.0,
                                        ),
                                      ),
                                      new Expanded(
                                        child: new FlatButton(
                                          onPressed: () =>
                                              onFindFriendsWithFacebookPressed(),
                                          padding: EdgeInsets.only(
                                            top: 20.0,
                                            bottom: 20.0,
                                          ),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                const IconData(0xea90,
                                                    fontFamily: 'icomoon'),
                                                color: Colors.white,
                                                size: 20.0,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "ADD FACEBOOK FRIEND",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      new Container(
                                        padding: EdgeInsets.only(
                                          right: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
      textStyle: TextStyle(
        color: Colors.black,
      ),
      iconedButtons: {
        ButtonState.idle: IconedButton(
            text: "Invite",
            icon: Icon(Icons.add, color: Colors.black),
            color: Theme.of(context).buttonColor),
        ButtonState.loading:
            IconedButton(text: "Sending", color: Colors.deepPurple.shade700),
        ButtonState.fail: IconedButton(
            text: "Failed",
            icon: Icon(Icons.cancel, color: Colors.white),
            color: Colors.red.shade300),
        ButtonState.success: IconedButton(
            text: "Sent",
            icon: Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            color: Colors.green.shade400)
      },
      onPressed: onPressedIconWithText,
      state: stateTextWithIcon,
    );
  }

  void onPressedIconWithText() {
    switch (stateTextWithIcon) {
      case ButtonState.idle:
        if (!_formKey.currentState.validate()) {
          break;
        }

        setState(() {
          stateTextWithIcon = ButtonState.loading;
        });

        addFriend();
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        stateTextWithIcon = ButtonState.idle;
        break;
      case ButtonState.fail:
        stateTextWithIcon = ButtonState.idle;
        break;
    }
    setState(() {
      stateTextWithIcon = stateTextWithIcon;
    });
  }

  void addFriend() async {
    AddFriendResponse response =
        await ServiceProvider.usersService.addFriend(_friendUsername);
    if (response.hasError()) {
      setState(() {
        stateTextWithIcon = ButtonState.fail;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
      return;
    }

    setState(() {
      stateTextWithIcon = ButtonState.success;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content:
          Text('An invitation to $_friendUsername has been sent successfully.'),
    ));
  }

  void onConnectFacebookPressed() async {
    FacebookAuthenticationResponse response =
        await ServiceProvider.authenticationService.connectFacebook();
    if (response.hasError()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error.errorMessage)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green.shade400,
          content: Text('Connected Facebook Successfully')));
    }
  }

  void onFindFriendsWithFacebookPressed() async {
    List<User> friends = await getFacebookFriends();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                FacebookFriendsScreen(facebookFriends: friends)));
  }

  Future<List<User>> getFacebookFriends() async {
    FacebookFriendsResponse getFacebookFriendsResponse =
        await ServiceProvider.authenticationService.getFacebookFriends();
    List<User> facebookFriends = [];
    for (var facebookFriend in getFacebookFriendsResponse.facebookFriends) {
      GetUserResponse getUserResponse = await ServiceProvider.usersService
          .getUserByFacebookUserId(facebookFriend.id);
      if (getUserResponse.hasError()) {
      } else {
        facebookFriends.add(getUserResponse.user);
      }
    }

    return getNotYetInvitedAppFriends(facebookFriends);
  }

  Future<List<User>> getNotYetInvitedAppFriends(
      List<User> facebookFriends) async {
    GetFriendsResponse response =
        await ServiceProvider.usersService.getFriends();

    if (response.hasError()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.error.errorMessage)));
      return facebookFriends;
    }

    List<User> notYetAppFriends = [];
    for (User user in facebookFriends) {
      if (!response.friendship.friends
          .any((friend) => friend.userId == user.id)) {
        notYetAppFriends.add(user);
      }
    }

    return notYetAppFriends;
  }
}
