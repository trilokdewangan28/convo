import 'package:convo/models/chat.dart';
import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/provider/chat_detail_page_provider.dart';
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
                secondaryAction: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
            ],
          ),
        )),
      );
    });
  }
}
