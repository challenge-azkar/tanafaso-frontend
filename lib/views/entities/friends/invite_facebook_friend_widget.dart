import 'package:azkar/models/user.dart';
import 'package:azkar/net/payload/users/responses/add_friend_response.dart';
import 'package:azkar/net/users_service.dart';
import 'package:flutter/material.dart';

class InviteFacebookFriendWidget extends StatefulWidget {
  final User facebookFriend;

  InviteFacebookFriendWidget({@required this.facebookFriend});

  @override
  _InviteFacebookFriendWidgetState createState() =>
      _InviteFacebookFriendWidgetState();
}

class _InviteFacebookFriendWidgetState
    extends State<InviteFacebookFriendWidget> {
  bool invited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shadowColor: Colors.black,
        elevation: 10,
        child: Row(
          children: [
            Flexible(
              flex: 7,
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.facebookFriend.name}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: conditionallyGetInviteButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget conditionallyGetInviteButton() {
    print(invited);
    return RaisedButton(
      child: invited ? Text('Invited') : Text('Invite'),
      color: invited ? null : Colors.green.shade400,
      onPressed: () => invited ? null : onInvitePressed(),
    );
  }

  void onInvitePressed() async {
    AddFriendResponse response =
        await UsersService.addFriend(widget.facebookFriend.username);
    if (response.hasError()) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(response.error.errorMessage),
      ));
      return;
    }

    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green.shade400,
      content: Text(
          'An invitation to ${widget.facebookFriend.name} has been sent successfully.'),
    ));

    setState(() {
      invited = true;
    });
  }
}