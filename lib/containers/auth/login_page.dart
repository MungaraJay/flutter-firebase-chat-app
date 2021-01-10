import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/login/login_bloc.dart';
import 'package:flutter_fire_chat/bloc/login/login_event.dart';
import 'package:flutter_fire_chat/bloc/login/login_state.dart';
import 'package:flutter_fire_chat/utils/util_colors.dart';
import 'package:flutter_fire_chat/utils/util_images.dart';
import 'package:flutter_fire_chat/utils/util_methods.dart';
import 'package:flutter_fire_chat/utils/util_routes.dart';
import 'package:flutter_fire_chat/utils/util_strings.dart';
import 'package:flutter_fire_chat/utils/util_styles.dart';
import 'package:flutter_fire_chat/widgets/custom_button.dart';
import 'package:flutter_fire_chat/widgets/custom_flat_button.dart';
import 'package:flutter_fire_chat/widgets/custom_input.dart';
import 'package:flutter_fire_chat/widgets/custom_progress_indicator.dart';
import 'package:flutter_fire_chat/widgets/header_text.dart';

class LoginPage extends StatefulWidget {
  final Function animateToPage;

  LoginPage(this.animateToPage);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFBLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        try {
          if (state is LoginInitState) {
            isLoading = false;
          } else if (state is LoginInProgressState) {
            isLoading = true;
          } else if (state is LoginSuccessState) {
            isLoading = false;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacementNamed(context, Route_Home_Screen);
            });
            BlocProvider.of<LoginBloc>(context).add(LoginChangesAction());
          } else if (state is LoginFailureState) {
            isLoading = false;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              displayToast(state.message, context);
            });
            BlocProvider.of<LoginBloc>(context).add(LoginChangesAction());
          } else if (state is LoginFBInProgressState) {
            isFBLoading = true;
          } else if (state is LoginFBSuccessState) {
            isFBLoading = false;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushReplacementNamed(context, Route_Home_Screen);
            });
            BlocProvider.of<LoginBloc>(context).add(LoginChangesAction());
          } else if (state is LoginFBFailureState) {
            isFBLoading = false;

            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              displayToast(state.message, context);
            });
            BlocProvider.of<LoginBloc>(context).add(LoginChangesAction());
          }
        } catch (e) {
          print(e);
        }
        return SafeArea(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 24, bottom: 24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    HeaderText(headerText: strLogin),
                    const SizedBox(height: 24),
                    Text(strLoginAccount, style: DescriptionStyle()),
                    const SizedBox(height: 24),
                    CustomInput(
                        textController: emailController,
                        labelText: strEmail,
                        prefixIcon: Icons.email,
                        textInputType: TextInputType.emailAddress,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please enter email.';
                          } else if (!isValidEmail(input)) {
                            return 'Please enter valid email.';
                          }

                          return null;
                        }),
                    CustomInput(
                        textController: passwordController,
                        labelText: strPassword,
                        obscureText: true,
                        prefixIcon: Icons.lock,
                        textInputType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Please enter password.';
                          } else if (input.length < 6) {
                            return 'Please enter password greater than 5 characters.';
                          }

                          return null;
                        }),
                    const SizedBox(height: 24),
                    isLoading
                        ? CustomProgressIndicator()
                        : CustomButton(
                            buttonText: strCapsLogin, onPressed: isFBLoading || isLoading ? null : onLoginPress),
                    const SizedBox(height: 24),
                    Center(
                        child: Text("OR",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
                            ))),
                    const SizedBox(height: 24),
                    buildLoginFacebookButton(),
                    const SizedBox(height: 24),
                    Center(
                        child:
                            Text(strDontHaveAccount, style: SubTitleStyle())),
                    CustomFlatButton(
                        buttonText: strCapsRegister,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          widget.animateToPage(1);
                        }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  onLoginPress() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState.validate()) {
      BlocProvider.of<LoginBloc>(context).add(LoginPressAction(
          emailController.text.trim(), passwordController.text.trim()));
    }
  }

  onFBPress() async {
    FocusScope.of(context).unfocus();
    BlocProvider.of<LoginBloc>(context).add(FBLoginPressAction());
  }

  Widget buildLoginFacebookButton() {
    return Center(
      child: UnconstrainedBox(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                authFBButtonGradientStartColor,
                authFBButtonGradientEndColor
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(50),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: authFBButtonGradientStartColor,
                offset: Offset(1.0, 5.0),
                blurRadius: 5.0,
              ),
              BoxShadow(
                color: authFBButtonGradientEndColor,
                offset: Offset(1.0, 5.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              if(!isFBLoading && !isLoading){
                onFBPress();
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Image.asset(fbImage,
                        height: 24, width: 24, fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(strLoginFB, style: ButtonTextStyle()),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // return GestureDetector(
    //   onTap: () async {},
    //   child: Align(
    //     alignment: Alignment.centerRight,
    //     child: isFBLoading
    //         ? Container(
    //         margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
    //         height: 50,
    //         // width: 200,
    //         child: Center(child: CircularProgressIndicator()))
    //         : Container(
    //       height: 50,
    //       width: double.maxFinite,
    //       // width: 200,
    //       decoration: BoxDecoration(
    //         color: authFBButtonGradientEndColor,
    //         shape: BoxShape.rectangle,
    //         borderRadius: BorderRadius.circular(50),
    //         boxShadow: <BoxShadow>[
    //           BoxShadow(
    //             color: authFBButtonGradientStartColor,
    //             offset: Offset(1.0, 5.0),
    //             blurRadius: 5.0,
    //           ),
    //           BoxShadow(
    //             color: authFBButtonGradientEndColor,
    //             offset: Offset(1.0, 5.0),
    //             blurRadius: 5.0,
    //           ),
    //         ],
    //         gradient: LinearGradient(
    //             colors: [
    //               authFBButtonGradientEndColor,
    //               authFBButtonGradientStartColor,
    //             ],
    //             begin: Alignment.topLeft,
    //             end: Alignment.bottomRight,
    //             stops: [0.0, 0.4],
    //             tileMode: TileMode.clamp),
    //       ),
    //       alignment: Alignment.center,
    //       margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Image.asset(fbImage,
    //               height: 24, width: 24, fit: BoxFit.contain),
    //           Expanded(
    //             child: Text(strLoginFB,
    //                 style: TextStyle(
    //                     color: lightColor,
    //                     fontSize: 18,
    //                     fontWeight: FontWeight.w500)),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
