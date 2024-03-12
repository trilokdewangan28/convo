import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/services/cloud_storage_service.dart';
import 'package:convo/services/database_service.dart';
import 'package:convo/services/media_service.dart';
import 'package:convo/services/navigation_service.dart';
import 'package:convo/widgets/custom_input_fields.dart';
import 'package:convo/widgets/rounded_button.dart';
import 'package:convo/widgets/rounded_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double height;
  late double width;
  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStorage;
  late NavigationService _navigation;

  PlatformFile? profileImage;
  final _registerFormKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _cloudStorage = GetIt.instance.get<CloudStorageService>();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        height: height * 0.98,
        width: width * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageField(),
            SizedBox(
              height: height * 0.05,
            ),
            _registerForm(),
            SizedBox(
              height: height * 0.05,
            ),
            _registerButton(),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
        onTap: () {
          GetIt.instance
              .get<MediaService>()
              .pickImageFromLibrary()
              .then((_file) {
            setState(() {
              print('file is : ${_file.toString()}');
              profileImage = _file;
            });
          });
        },
        child: profileImage != null
            ? RoundedImageFile(
                key: UniqueKey(), image: profileImage, size: height * 0.15)
            : RoundedImageNetwork(
                key: UniqueKey(),
                imagePath: 'https://i.pravatar.cc/1000?img=65',
                size: height * 0.15));
  }

  Widget _registerForm() {
    return Container(
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _name = _value;
                  });
                },
                regEx: r".{8,}",
                hintText: 'Name',
                obscureText: false),
            SizedBox(
              height: height * 0.03,
            ),
            CustomTextFormField(
                onSaved: (_value) {
                  setState(() {
                    _email = _value;
                  });
                },
                regEx:
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                hintText: 'Email',
                obscureText: false),
            SizedBox(
              height: height * 0.03,
            ),
            CustomTextFormField(
              obscureText: true,
              hintText: 'Password',
              onSaved: (_value) {
                setState(() {
                  _password = _value;
                });
              },
              regEx: r".{8,}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
        name: 'Register',
        height: height * 0.065,
        width: width * 0.65,
        onPressed: () async{
          print('register method called');
          if(_registerFormKey.currentState!.validate() && profileImage!=null){
            _registerFormKey.currentState!.save();
            String? _uid = await _auth.registerUserUsingEmailAndPassword(_email!, _password!);
            String? _imageURL = await _cloudStorage.saveUserImageToStorage(_uid!, profileImage!);
            await _db.createUser(_uid, _email!, _name!, _imageURL!);
            await _auth.logout();
            await _auth.loginUsingEmailAndPassword(_email!, _password!);
          }
        }
    );
  }
}
