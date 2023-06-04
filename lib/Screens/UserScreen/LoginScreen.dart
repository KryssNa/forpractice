import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModel/auth_viewmodel.dart';
import '../../constant/Colors.dart';
import '../../widget/buttonWidget.dart';
import '../../widget/textFieldWidget.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? GlobalKey}) : super(key: GlobalKey);
  static String routeName = "/LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = true;
  late AuthViewModel _authen;

  @override
  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Error"),
          content: const Text("Failed to Login."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _authen = Provider.of<AuthViewModel>(context, listen: false);
    super.initState();
  }

  bool isLoading = false;
  void login() async {
    try {
      await _authen.login(emailController.text, passwordController.text).then((value) {
        if (_authen.loggedInUser!.fcmToken != "ADMIN") {
          //snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Successful"),
            ),
          );
          // Navigator.of(context).pushReplacementNamed('/adminDashboard');
        } else {
          // Navigator.of(context).pushReplacementNamed('/userDashboard');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Login Successful"),
            ),
          );
        }
        // Navigator.of(context).pushReplacementNamed('/userDashboard');
      }).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      });
    } catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ConstColors.primaryColor2,
        body: SafeArea(
          child: Container(
              decoration: const BoxDecoration(
                // color: ConstColors.primaryColor2,
                image: DecorationImage(
                  image: AssetImage('Assets/images/logo.png'),
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'lOG IN',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SSFPro',
                                letterSpacing: 1.2,
                                color: ConstColors.whiteColor,
                              ),
                            ),
                            SizedBox(
                              height: 150,
                              width: 200,
                              child: Image.asset('Assets/images/Login.png'),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: ConstColors.whiteColor,
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    textField(
                                      titleHeading: 'Email',
                                      hintText: 'Enter your email',
                                      controller: emailController,
                                      Validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Email is required";
                                        }
                                        if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                          return "Please enter valid email";
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    textField(
                                      titleHeading: 'Password',
                                      hintText: 'Enter your password',
                                      obscureText: true,
                                      suffixIcon: Icon(Icons.visibility),
                                      controller: passwordController,
                                      Validator: ( value) {
                                        if (value == null || value.isEmpty) {
                                          return "password is required";
                                        }
                                        if (value.length < 8 || value.length > 10) {
                                          return "enter password of 8 to 10 characters";
                                        }
                                        return null; //
                                      },
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: _isChecked,
                                            onChanged: (val) {
                                              setState(() {
                                                _isChecked = val!;
                                              });
                                            },
                                          ),
                                          const Text(
                                            'Remember me',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'SSFPro',
                                              // fontWeight: FontWeight.bold,
                                              color: ConstColors.primaryTextColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ButtonWidget(
                                      title: isLoading ? "lOGINGG..." : "lOGINGG",
                                      onPressed: isLoading ? null : login,
                                      showLoadingIndicator: isLoading,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Don\'t have an account?',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'SSFPro',
                                              // fontWeight: FontWeight.bold,
                                              color: ConstColors.primaryTextColor,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Navigate to login screen
                                              Navigator.of(context).pushReplacementNamed(RegisterScreen.routeName);
                                            },
                                            child: const Text(
                                              'Register Now',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'SSFPro',
                                                // fontWeight: FontWeight.bold,
                                                color: ConstColors.secondaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }
}
