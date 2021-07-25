import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tc_restaurant/Function/Loading.dart';
import 'package:tc_restaurant/MISC/GetSnackBar.dart';
import 'package:tc_restaurant/Model/ErrorObj.dart';
import 'package:tc_restaurant/RestaurantBloc.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = FlutterSecureStorage();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  getEmail () async {
    String? email = await storage.read(key: 'email');

    if(email != null){
      _email.text = email;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
  }
  @override
  Widget build(BuildContext context) {

    RestaurantBloc restaurantBloc = Provider.of<RestaurantBloc>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.music_off_outlined),
          onPressed: (){
            FlutterRingtonePlayer.stop();
          }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )
                ),
                controller: _email,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                autocorrect: false,
                enableSuggestions: false,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    )
                ),
                controller: _password,
              ),
              SizedBox(height: 20,),

              ElevatedButton(
                  onPressed: () async {
                    handleStartLoading();

                    try{
                      if(_email.text.isNotEmpty && _password.text.isNotEmpty){
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _email.text, password: _password.text
                        ).then((user) {
                          if(user.user!.uid == 'XYux0aXaVxdMlpgw6EAdFmysN9T2'){
                            restaurantBloc.setUserId(user.user!.uid);

                            final storage = FlutterSecureStorage();
                            storage.write(key: 'email', value: _email.text);

                            Navigator.pushNamed(context, 'new');
                          }
                        }).catchError((error) {
                          throw(ErrorObj(message: error.message != null ? error.message : 'Failed to login'));
                        });
                      }
                    } on ErrorObj catch(e){
                      showErrorSnackBar(e.message);
                    } catch(e){
                      showErrorSnackBar('Unexpected Error');
                    }
                    handleEndLoading();

                  },
                  child: Text('Login')
              )
            ],
          ),
        ),
      ),
    );
  }
}
