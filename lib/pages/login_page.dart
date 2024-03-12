import 'package:convo/provider/authentication_provider.dart';
import 'package:convo/services/navigation_service.dart';
import 'package:convo/widgets/custom_input_fields.dart';
import 'package:convo/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double height;
  late double width;
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  late AuthenticationProvider _auth;
  late NavigationService _navigation;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();
    return _buildUi();
  }

  Widget _buildUi() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.02),
        height: height * 0.98,
        width: width * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pageTitle(),
            SizedBox(
              height: height * 0.04,
            ),
            _loginForm(),
            SizedBox(
              height: height * 0.05,
            ),
            _loginBtn(),
            SizedBox(
              height: height * 0.02,
            ),
            _registerAccountLink()
          ],
        ),
      ),
    );
  }

  Widget _pageTitle() {
    return Container(
      height: height * 0.10,
      child: Text(
        'Convo',
        style: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
      //height: height * 0.18,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              obscureText: false,
              hintText: 'Email',
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
            ),
            SizedBox(height: height*0.04,),
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

  Widget _loginBtn() {
    return RoundedButton(
        name: 'Login',
        height: height * 0.065,
        width: width * 0.65,
        onPressed: () {
          if(_formKey.currentState!.validate()){
             _formKey.currentState!.save();
             print('email is $_email');
             print('pass is $_password');
             _auth.loginUsingEmailAndPassword(_email!, _password!);
          }
        });
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: ()=>_navigation.navigateToRoute('/register'),
      child: Container(
        child: Text(
          ''' Don't have an account? ''',
          style: TextStyle(color: Colors.blueAccent),
        ),
      ),
    );
  }
}
