import 'package:convo/models/chat.dart';
import 'package:convo/models/chat_message.dart';
import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/provider/chat_detail_page_provider.dart';
import 'package:convo/widgets/custom_input_fields.dart';
import 'package:convo/widgets/custom_list_view_tile.dart';
import 'package:convo/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatefulWidget {
  final Chat chat;

  const ChatDetailPage({super.key, required this.chat});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  late double height;
  late double width;

  late AuthenticationProvider _auth;
  late ChatDetailPageProvider _pageProvider;
  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messagesListViewController;

  @override
  void initState() {
    _messageFormState = GlobalKey<FormState>();
    _messagesListViewController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatDetailPageProvider>(
          create: (_) => ChatDetailPageProvider(
            widget.chat.uid,
            _auth,
            _messagesListViewController,
          ),
        ),
      ],
      child: _buildUI(this.widget.chat),
    );
  }

  Widget _buildUI(Chat chat) {
    return Builder(builder: (BuildContext context) {
      _pageProvider = context.watch<ChatDetailPageProvider>();
      return Scaffold(
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          height: height,
          width: width * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                chat.title(),
                fontSize: 10,
                primaryAction: IconButton(
                  onPressed: () {
                    _pageProvider.deleteChat();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
                secondaryAction: IconButton(
                  onPressed: () {
                    _pageProvider.goBack();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              _messagesListView(),
              _sendMessageForm()
            ],
          ),
        )),
      );
    });
  }

  Widget _messagesListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.length != 0) {
        return Container(
          height: height * 0.74,
          child: ListView.builder(
            controller: _messagesListViewController,
              itemCount: _pageProvider.messages!.length,
              itemBuilder: (context, index) {
                ChatMessage _message = _pageProvider.messages![index];
                bool isOwnMessage = _message.senderID == _auth.user.uid;
                return Container(
                  child: CustomChatListViewTile(
                    width: width,
                    height: height,
                    message: _message,
                    isOwnMessage: isOwnMessage,
                    sender: widget.chat.members
                        .where((_m) => _m.uid == _message.senderID).first,
                  ),
                );
              }),
        );
      } else {
        return Align(
          alignment: Alignment.center,
          child: Text(
            'Be the first to say hii...',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: height * 0.06,
      decoration: BoxDecoration(
          color: Color.fromRGBO(30, 29, 37, 1.0),
          borderRadius: BorderRadius.circular(100)),
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.03),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: width * 0.65,
      child: CustomTextFormField(
          onSaved: (_value) {
            _pageProvider.message = _value;
          },
          regEx: r"^(?!\s*$).+",
          hintText: "Type a message",
          obscureText: false),
    );
  }

  Widget _sendMessageButton() {
    double _size = height * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        icon: Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = height * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(
          0,
          82,
          218,
          1.0,
        ),
        onPressed: () {
          _pageProvider.sendImageMessage();
        },
        child: Icon(Icons.camera_enhance),
      ),
    );
  }
}
