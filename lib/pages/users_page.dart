import 'package:convo/models/chat_user.dart';
import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/provider/users_page_provider.dart';
import 'package:convo/widgets/custom_input_fields.dart';
import 'package:convo/widgets/custom_list_view_tile.dart';
import 'package:convo/widgets/rounded_button.dart';
import 'package:convo/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double height;
  late double width;
  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;
  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
        providers:[
          ChangeNotifierProvider<UsersPageProvider>(create: (_)=>UsersPageProvider(_auth),),
        ],
      child: _buildUI(),
    );
  }

  _buildUI() {
    return Builder(builder: (context){
      _pageProvider = context.watch<UsersPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.02),
        height: height * 0.98,
        width: width * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Users',
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
            CustomTextField(
              onEditingComplete: (value){
                _pageProvider.getUsers(name: value);
                FocusScope.of(context).unfocus();
              },
              hintText: 'Search User',
              obscureText: false,
              controller: _searchFieldTextEditingController,
              icon: Icons.search,
            ),
            _userList(),
            _createChatButton()
          ],
        ),
      );
    });
  }
  Widget _userList(){
    List<ChatUser>? _users = _pageProvider.users; 
    return Expanded(
        child: (){
          if(_users!=null){
            if(_users.length!=0){
              return ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context,index){
                    return CustomListViewTile(
                        height: height*0.10,
                        title: "${_users[index].name}",
                        subtitle: "Last Active: ${_users[index].lastActive}",
                        imagePath: '${_users[index].imageURL}',
                        isActive: _users[index].wasRecentlyActive(),
                        isSelected: _pageProvider.selectedUsers.contains(_users[index]),
                        onTap:(){
                          _pageProvider.updateSelectedUsers(_users[index]);
                        }
                    );
                  }
              );
            }else{
              return Center(child: Text('No Users Found', style: TextStyle(color: Colors.white),),);
            }
          }else{
            return Center(child: CircularProgressIndicator(color: Colors.white,),);
          }
        }()
    );
  }
  Widget _createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        name: _pageProvider.selectedUsers.length == 1
            ? "Chat With ${_pageProvider.selectedUsers.first.name}"
            : "Create Group Chat",
        height: height * 0.08,
        width: width * 0.80,
        onPressed: () {
          _pageProvider.createChat();
        },
      ),
    );
  }
  
}
