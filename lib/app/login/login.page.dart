import 'package:crud_productos/global_pods/providers.dart';
import 'package:crud_productos/helpers/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

enum FormState {
  initial,
  readyToSent,
  incompleted,
  loginInProgess,
  failure,
  success,
}

// simple state handler for login or register form
class UserActionState extends ChangeNotifier {
  FormState _state = FormState.initial;

  set changeFormState(FormState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// FormState
  FormState get state => this._state;
}

// we honor flutter name guidelines been so explicit
final userActionFormStateProvider =
    ChangeNotifierProvider.autoDispose<UserActionState>((_) {
  return UserActionState();
});

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> handleGoogleSignIn() async {
    try {
      final User? user = await context.read(authProvider).signInWithGoogle();
      if (user == null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("No pudimos iniciar sesion"),
            ),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: media.size.height * 0.10,),
                    SizedBox(
                      // width: media.size.width * 0.5,
                      height: media.size.height * 0.2,
                      child: Image.asset(
                        "assets/LOGO.png",
                      ),
                    ),

                    HookBuilder(
                      builder: (context) {
                        final emailState = useState<String>("");
                        final passwordState = useState<String>("");

                        final emailIsValid = useState<bool>(false);
                        final passwordIsValid = useState<bool>(false);

                        final ValueNotifier<String?> emailError =
                            useState<String?>(null);
                        final ValueNotifier<String?> passwordError =
                            useState<String?>(null);

                        final ValueNotifier<bool> logInOrRegister =
                            ValueNotifier<bool>(true);

                        useValueChanged(emailState.value, (_, oldResult) {
                          final isEmailValid =
                              emailRegExp.hasMatch(emailState.value);
                          if (oldResult != isEmailValid) {
                            // print(oldResult != isEmailValid);
                            emailIsValid.value = isEmailValid;
                            if (!isEmailValid) {
                              emailError.value = "email incompleto";
                              // setIncompletedFormState();
                            } else {
                              emailError.value = null;
                              // setReadyToSentFormState();
                            }
                          }
                          return isEmailValid; // *oldResult
                        });

                        useValueChanged(passwordState.value, (_, oldResult) {
                          final passIsEmpty = passwordState.value.isEmpty;
                          if (passIsEmpty != oldResult) {
                            passwordIsValid.value = !passIsEmpty;
                            if (passIsEmpty) {
                              passwordError.value = "contraseña vacía";
                              // setIncompletedFormState();
                            } else if (passwordState.value.length < 6) {
                              passwordError.value =
                                  "la contraseña debe tener almenos 6 caracteres";
                              // setIncompletedFormState();
                            } else {
                              passwordError.value = null;
                              // setReadyToSentFormState();
                            }
                          }

                          return oldResult;
                        });

                        Future<void>
                            handleRegisterWithEmailAndPassword() async {
                          try {
                            final user = await context
                                .read(authProvider)
                                .createUserWithEmailAndPassword(
                                  email: emailState.value,
                                  password: passwordState.value,
                                );
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                          }
                        }

                        Future<void> handleLoginWithEmailAndPassword() async {
                          try {
                            final user = await context
                                .read(authProvider)
                                .signInWithEmailAndPassword(
                                  email: emailState.value,
                                  password: passwordState.value,
                                );
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                ),
                              );
                          }
                        }

                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: media.size.width * 0.8,
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "email@domain.com",
                                  labelText: "Email",
                                  // hintStyle: textFieldHintStyle,
                                  // labelStyle: textFieldLabelStyle,
                                  errorText: emailError.value,
                                ),
                                onChanged: (value) {
                                  emailState.value = value;
                                },
                              ),
                              decoration: BoxDecoration(
                                // color: color3,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: media.size.width * 0.8,
                              margin: EdgeInsets.only(top: 14, bottom: 10),
                              child: TextFormField(
                                obscureText: true,
                                // style: textFieldHintStyle,
                                decoration: InputDecoration(
                                  // hintText: "",
                                  labelText: "Contraseña",
                                  // hintStyle: textFieldHintStyle,
                                  // labelStyle: textFieldLabelStyle,
                                  errorText: passwordError.value,
                                ),
                                onChanged: (value) {
                                  passwordState.value = value;
                                },
                              ),
                              decoration: BoxDecoration(
                                // color: color3,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            Consumer(
                              builder: (context, watch, __) {
                                final FormState state =
                                    watch(userActionFormStateProvider).state;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                      width: 250,
                                      child: IgnorePointer(
                                        ignoring: state ==
                                                FormState.incompleted ||
                                            state == FormState.loginInProgess,
                                        child: TextButton(
                                          child: (state ==
                                                  FormState.loginInProgess)
                                              ? Container(
                                                  width: 25,
                                                  height: 25,
                                                  // padding: const EdgeInsets.all(8.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : ValueListenableBuilder(
                                                  valueListenable:
                                                      logInOrRegister,
                                                  builder: (context, bool state,
                                                      __) {
                                                    return Text(
                                                      state
                                                          ? "Login"
                                                          : "Registrarme",
                                                    );
                                                  }),
                                          onPressed: () {
                                            if (!passwordIsValid.value ||
                                                !emailIsValid.value) {
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    content: Text(
                                                        "Rellena los campos"),
                                                  ),
                                                );
                                              return;
                                            }
                                            if (logInOrRegister.value) {
                                              // user wants to log in
                                              handleLoginWithEmailAndPassword();
                                              return;
                                            }
                                            handleRegisterWithEmailAndPassword();
                                          },
                                          style: TextButton.styleFrom(
                                            // backgroundColor: color1,
                                            primary: Colors.white,
                                            backgroundColor:theme.primaryColor,
                                            textStyle: textTheme.headline6,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 30,
                                              vertical: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: logInOrRegister,
                                      builder: (_, value, __) {
                                        return Switch(
                                          value: logInOrRegister.value,
                                          onChanged: (value) {
                                            logInOrRegister.value = value;
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            )
                            // Counter(),
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("O ingresa con tus redes"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: handleGoogleSignIn,
                      style: TextButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.red,
                        primary: Colors.white,
                      ),
                      child: const Text(
                        "G",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        await context.read(authProvider).signInAnonymously();
                      },
                      child: Text("Ingresa de manera anonima"),
                      style: TextButton.styleFrom(
                        primary: theme.colorScheme.primaryVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
