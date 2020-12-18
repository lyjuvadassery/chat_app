import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:firebase_chat_app/helpers/color_theme.dart';
import 'package:firebase_chat_app/widgets/common_widgets.dart';
import 'package:flutter/material.dart';

import 'package:firebase_chat_app/helpers/app_constants.dart';
import 'package:firebase_chat_app/helpers/app_utils.dart';
import 'package:firebase_chat_app/helpers/authentication_helper.dart';
import 'package:firebase_chat_app/services/auth_service.dart';
import 'package:firebase_chat_app/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_chat_app/models/message_model.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double _mediaHeight;
  double _mediaWidth;
  AuthService _authService = AuthService();
  DatabaseService _databaseService = DatabaseService();
  Stream<QuerySnapshot> _rawMessages;
  List<MessageModel> _messages = [];
  List<dynamic> _messagesWithDateMarkers = [];
  TextEditingController _messageFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isSentByMe;

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  @override
  void dispose() {
    _messageFieldController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollToBottom() {
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }

  _loadData() async {
    AppConstants.myName = await AppUtils.getUserName();
    _databaseService.getChatMessages().then((value) {
      setState(() {
        _rawMessages = value;
      });
    });
  }

  _sendMessage() async {
    if (_messageFieldController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sentBy": AppConstants.myName,
        "message": _messageFieldController.text.trim(),
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      setState(() {
        _messageFieldController.text = "";
      });

      await _databaseService.addMessage(chatMessageMap);

      _scrollToBottom();
    }
  }

  Future<bool> _onWillPop() async {
    bool _isLeaveApp = await AppUtils.showYesOrNoAlertDialog(
        context: context,
        alertDialogTitle: 'Exiting the app',
        alertDialogMessage: 'Are you sure you want to exit?');

    return _isLeaveApp;
  }

  @override
  Widget build(BuildContext context) {
    _mediaHeight = MediaQuery.of(context).size.height;
    _mediaWidth = MediaQuery.of(context).size.width;

    ScreenUtil.init(
      context,
      designSize: Size(_mediaWidth, _mediaHeight),
      allowFontScaling: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) _scrollToBottom();
    });

    if (_messages.length > 1) {
      if (_scrollController.hasClients) _scrollToBottom();
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: ColorTheme.backgroundGreen,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () {
                _authService.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthenticationHelper(),
                  ),
                );
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app)),
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22.0,
                backgroundImage: NetworkImage(
                  'https://flutter.dev/images/catalog-widget-placeholder.png',
                ),
                backgroundColor: Colors.transparent,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 15.0,
                ),
                child: Text(
                  'Flutter Devs',
                  style: appbarTextStyle(),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          // physics: ScrollPhysics(),
          child: SizedBox(
            height: _mediaHeight * 0.89,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 12,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(8.0),
                      right: ScreenUtil().setWidth(8.0),
                    ),
                    child: _buildChatMessages(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(5.0)),
                  height: ScreenUtil().setHeight(50.0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      // color: Colors.red[100],
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10.0),
                        vertical: ScreenUtil().setHeight(0.0)),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 15,
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                // color: Colors.red[100],
                                borderRadius: BorderRadius.circular(50.0)),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextField(
                                controller: _messageFieldController,
                                cursorColor: Theme.of(context).primaryColor,
                                style: simpleTextStyle(),
                                decoration: InputDecoration(
                                  hintText: "Type a message",
                                  hintStyle: hintTextStyle(),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.sentiment_satisfied,
                                    size: ScreenUtil().setSp(30.0),
                                    color: ColorTheme.lightGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(8.0),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Center(
                                child: Icon(
                                  Icons.send,
                                  size: ScreenUtil().setSp(20.0),
                                  color: Colors.white,
                                ),
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
        ),
      ),
    );
  }

  Widget _buildChatMessages() {
    return StreamBuilder(
      stream: _rawMessages,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _messages = List<MessageModel>.from(
            snapshot.data.docs.map(
              (rawMessage) => MessageModel.fromJson(rawMessage.data()),
            ),
          );

          _messagesWithDateMarkers = AppUtils.processRawMessages(_messages);

          // if (_scrollController.hasClients) _scrollToBottom();
          Timer(Duration(milliseconds: 1000), _scrollToBottom);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListView.builder(
              itemCount: _messagesWithDateMarkers.length,
              controller: _scrollController,
              // reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (_messagesWithDateMarkers[index].runtimeType == String) {
                  return SizedBox(
                    width: _mediaWidth * 0.4,
                    child: Card(
                      color: Colors.blue[50],
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Container(
                          // width: _mediaWidth * 0.4,
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _messagesWithDateMarkers[index],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  print('$index | ${_messagesWithDateMarkers[index].message}');

                  _isSentByMe = AppConstants.myName ==
                      _messagesWithDateMarkers[index].sentBy;
                  return _isSentByMe
                      ? Bubble(
                          margin: BubbleEdges.only(
                              top: (index <
                                          _messagesWithDateMarkers.length - 1 &&
                                      _isSentByMe)
                                  ? ScreenUtil().setHeight(5.0)
                                  : ScreenUtil().setHeight(20.0),
                              left: ScreenUtil().setWidth(100.0),
                              bottom: index == 0
                                  ? ScreenUtil().setHeight(10.0)
                                  : ScreenUtil().setHeight(0.0)),
                          nip: (index < _messagesWithDateMarkers.length - 2 &&
                                  _isSentByMe)
                              ? BubbleNip.no
                              : BubbleNip.rightTop,
                          color: Color.fromRGBO(225, 255, 199, 1.0),
                          nipHeight: ScreenUtil().setHeight(12.0),
                          alignment: Alignment.centerRight,
                          elevation: 0.4,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _messagesWithDateMarkers[index].message,
                                style: simpleTextStyle(),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(10.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    // DateFormat('dd-MMM-yyyy').format(
                                    //     _messagesWithDateMarkers[index].time),
                                    DateFormat('hh:mm').format(
                                        _messagesWithDateMarkers[index].time),
                                    style: messageDateTextStyle(),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(10.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : Bubble(
                          margin: BubbleEdges.only(
                              top: (index <
                                          _messagesWithDateMarkers.length - 2 &&
                                      _isSentByMe)
                                  ? ScreenUtil().setHeight(20.0)
                                  : ScreenUtil().setHeight(5.0),
                              right: ScreenUtil().setWidth(100.0)),
                          nip: (index < _messagesWithDateMarkers.length - 1 &&
                                  _isSentByMe)
                              ? BubbleNip.leftTop
                              : BubbleNip.no,
                          nipHeight: ScreenUtil().setHeight(12.0),
                          alignment: Alignment.centerLeft,
                          elevation: 0.4,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  _messagesWithDateMarkers[index].sentBy ?? '',
                                  style: messageSentByTextStyle(),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(8.0),
                              ),
                              Text(
                                _messagesWithDateMarkers[index].message,
                                style: simpleTextStyle(),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(8.0),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    // DateFormat('dd-MMM-yyyy').format(
                                    //     _messagesWithDateMarkers[index].time),
                                    DateFormat('hh:mm').format(
                                        _messagesWithDateMarkers[index].time),
                                    style: messageDateTextStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                }
              },
            ),
          );
        } else {
          // if (!snapshot.hasData)
          return Container();
        }
      },
    );
  }
}
