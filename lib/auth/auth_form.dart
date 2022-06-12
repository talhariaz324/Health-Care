import 'package:flutter/material.dart';
import 'package:health_care/routes/routes.dart';

import '../components/input_container.dart';
import '../components/rounded_button.dart';
import '../screens/components/cancel_button.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(String email, String password, String userName,
      bool _isLogin, BuildContext ctx) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _rFormKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  TextEditingController password =
      TextEditingController(); // for confirmation in register
  TextEditingController lEmail = TextEditingController();
  TextEditingController lPassword = TextEditingController();

  late Animation<double> containerSize;
  AnimationController? animationController;
  Duration animationDuration = const Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  void _trySubmit() {
    final isValid = _isLogin
        ? _formKey.currentState!.validate()
        : _rFormKey.currentState!.validate();
    FocusScope.of(context).unfocus(); // for closing soft keyboard

    // if (!_isLogin) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('You are not LogIn'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   return;
    // }

    if (isValid) {
      _isLogin ? _formKey.currentState!.save() : _rFormKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(), // for ignoring white spaces
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context)
        .viewInsets
        .bottom; // we are using this to determine Keyboard is opened or not
    double defaultLoginSize = size.height - (size.height * 0.2);
    double defaultRegisterSize = size.height - (size.height * 0.1);

    containerSize =
        Tween<double>(begin: size.height * 0.1, end: defaultRegisterSize)
            .animate(CurvedAnimation(
                parent: animationController!, curve: Curves.linear));

    return Stack(
      children: [
        // Lets add some decorations
        Positioned(
            top: 100,
            right: -50,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(140, 204, 132, 1),
                    Color.fromRGBO(171, 210, 200, 1),
                  ],
                ),
              ),
            )),

        Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(175, 203, 219, 1),
                    Color.fromRGBO(149, 171, 229, 1),
                  ],
                ),
              ),
            )),

        // Cancel Button
        CancelButton(
          isLogin: _isLogin,
          animationDuration: animationDuration,
          size: size,
          animationController: animationController,
          tapEvent: _isLogin
              ? null
              : () {
                  // returning null to disable the button
                  animationController!.reverse();
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
        ),
        AnimatedOpacity(
          opacity: _isLogin ? 1.0 : 0.0,
          duration: animationDuration * 4,
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: size.width,
              height: defaultLoginSize,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Wel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.06,
                                color: Theme.of(context).backgroundColor),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Text(
                            'come Back',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.06,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.08),

                      Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(size.width * 1))),
                          height: size.height * 0.25,
                          child: Image.asset(
                            'assets/images/login.png',
                            fit: BoxFit.cover,
                          )),

                      SizedBox(height: size.height * 0.03),

                      InputContainer(
                        child: TextFormField(
                          key: const ValueKey('email'),
                          autocorrect: false,
                          controller: lEmail,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          validator: _isLogin
                              ? (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email address.';
                                  }
                                  return null;
                                }
                              : null,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              icon: Icon(Icons.mail,
                                  color: Theme.of(context).primaryColor),
                              hintText: 'Email',
                              border: InputBorder.none),
                          onSaved: (value) {
                            _userEmail = value!;
                          },
                        ),
                      ),

                      InputContainer(
                        child: TextFormField(
                          key: const ValueKey('password'),
                          controller: lPassword,
                          validator: _isLogin
                              ? (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return 'Password must be at least 7 characters long.';
                                  }
                                  return null;
                                }
                              : null,
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock,
                                  color: Theme.of(context).primaryColor),
                              hintText: 'Password',
                              border: InputBorder.none),
                          obscureText: true,
                          onSaved: (value) {
                            _userPassword = value!;
                          },
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: size.width * 0.03),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(MyRoutes.forgotPassRoute);
                                },
                                child: Text(
                                  'Forgot Password?',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold),
                                )),
                          )
                        ],
                      ),
                      // SizedBox(height: size.height * 0.01),

                      widget.isLoading
                          ? CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary)
                          : RoundedButton(
                              title: 'LOGIN', trySubmit: _trySubmit),

                      SizedBox(height: size.height * 0.01),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Register Container
        AnimatedBuilder(
          animation: animationController!,
          builder: (context, child) {
            if (viewInset == 0 && _isLogin) {
              return buildRegisterContainer();
            } else if (!_isLogin) {
              return buildRegisterContainer();
            }

            // Returning empty container to hide the widget
            return Container();
          },
        ),

        // Register Form
        AnimatedOpacity(
          opacity: _isLogin ? 0.0 : 1.0,
          duration: animationDuration * 5,
          child: Visibility(
            visible: !_isLogin,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: size.width,
                height: defaultLoginSize,
                child: SingleChildScrollView(
                  child: Form(
                    key: _rFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: size.height * 0.01),
                        Text(
                          'Welcome',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.07,
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(size.width * 1))),
                          height: size.height * 0.25,
                          child: Image.asset(
                            'assets/images/register.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        InputContainer(
                          child: TextFormField(
                            key: const ValueKey('rUsername'),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a valid user name.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                icon: Icon(Icons.person,
                                    color: Theme.of(context).primaryColor),
                                hintText: 'Username',
                                border: InputBorder.none),
                            onSaved: (value) {
                              _userName = value!;
                            },
                          ),
                        ),
                        InputContainer(
                          child: TextFormField(
                            key: const ValueKey('rEmail'),
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            enableSuggestions: false,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                icon: Icon(Icons.mail,
                                    color: Theme.of(context).primaryColor),
                                hintText: 'Email',
                                border: InputBorder.none),
                            onSaved: (value) {
                              _userEmail = value!;
                            },
                          ),
                        ),
                        InputContainer(
                          child: TextFormField(
                            key: const ValueKey('rPassword'),
                            controller: password,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Password must be at least 7 characters long.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor),
                                hintText: 'Password',
                                border: InputBorder.none),
                            obscureText: true,
                            onSaved: (value) {
                              _userPassword = value!;
                            },
                          ),
                        ),
                        InputContainer(
                          child: TextFormField(
                            key: const ValueKey('Cpassword'),
                            validator: (value) {
                              if (value != password.text || value!.isEmpty) {
                                return 'Password not match.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                icon: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor),
                                hintText: 'Confirm Password',
                                border: InputBorder.none),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: size.height * 0.015),
                        widget.isLoading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.secondary,
                              )
                            : RoundedButton(
                                title: 'SIGN UP', trySubmit: _trySubmit),
                        SizedBox(height: size.height * 0.015),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
          color: Color.fromARGB(255, 187, 231, 176),
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !_isLogin
              ? null
              : () {
                  animationController!.forward();

                  setState(() {
                    password.text = '';
                    lEmail.text = '';
                    lPassword.text = '';
                    _isLogin = !_isLogin;
                  });
                },
          child: _isLogin
              ? Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 17),
                )
              : null,
        ),
      ),
    );
  }
}
