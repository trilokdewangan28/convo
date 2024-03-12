import 'package:convo/models/chat.dart';
import 'package:convo/models/chat_message.dart';
import 'package:convo/models/chat_user.dart';
import 'package:convo/pages/chat_detail_page.dart';
import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/provider/chat_page_provider.dart';
import 'package:convo/services/navigation_service.dart';
import 'package:convo/widgets/custom_list_view_tile.dart';
import 'package:convo/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double height;
  late double width;
  late AuthenticationProvider _auth;
  late ChatPageProvider _pageProvider;
  late NavigationService _navigation;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext context) {
      _pageProvider = context.watch<ChatPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        height: height * 0.98,
        width: width * 0.97,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            TopBar(
              'Chats',
              primaryAction: IconButton(
                onPressed: () {
                  _auth.logout();
                },
                icon: Icon(
                  Icons.logout,
                  color: Color.fromRGBO(0, 82, 218, 1.0),
                ),
              ),
            ),
            _chatList()
          ],
        ),
      );
    });
  }

  Widget _chatList() {
    List<Chat>? _chats = _pageProvider.chats;
    print(_chats);
    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.length != 0) {
            return ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (BuildContext _context, int _index) {
                return _chatTile(_chats[_index]);
              },
            );
          } else {
            return Center(
              child: Text(
                'no chat found',
                style: TextStyle(
                  color: Colors.white,
                ),
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
      })(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((_d) => _d.wasRecentlyActive());
    String _subTitle = "";
    if (_chat.messages.isNotEmpty) {
      _subTitle = _chat.messages.first.type != MessageType.TEXT
          ? " Media Attachment"
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: height * 0.10,
      title: _chat.title(),
      subtitle: _subTitle,
      imagePath: _chat.imageURL(),
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigation.navigateToPage(ChatDetailPage(chat: _chat));
      },
    );
  }
}
