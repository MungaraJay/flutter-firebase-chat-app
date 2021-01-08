import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire_chat/bloc/register/register_bloc.dart';
import 'package:flutter_fire_chat/bloc/register/register_event.dart';
import 'package:flutter_fire_chat/bloc/register/register_state.dart';
import 'package:flutter_fire_chat/utils/util_methods.dart';
import 'package:flutter_fire_chat/utils/util_routes.dart';
import 'package:flutter_fire_chat/utils/util_strings.dart';
import 'package:flutter_fire_chat/utils/util_styles.dart';
import 'package:flutter_fire_chat/widgets/custom_button.dart';
import 'package:flutter_fire_chat/widgets/custom_flat_button.dart';
import 'package:flutter_fire_chat/widgets/custom_input.dart';
import 'package:flutter_fire_chat/widgets/custom_progress_indicator.dart';
import 'package:flutter_fire_chat/widgets/header_text.dart';

class SignupPage extends StatefulWidget {
  final Function animateToPage;

  SignupPage(this.animateToPage);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
      try {
        if (state is RegisterInitState) {
          isLoading = false;
        } else if (state is RegisterInProgressState) {
          isLoading = true;
        } else if (state is RegisterSuccessState) {
          isLoading = false;

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.pushReplacementNamed(context, Route_Home_Screen);
          });
          BlocProvider.of<RegisterBloc>(context).add(RegisterChangesAction());
        } else if (state is RegisterFailureState) {
          isLoading = false;

          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            displayToast(state.message, context);
          });
          BlocProvider.of<RegisterBloc>(context).add(RegisterChangesAction());
        }
      } catch (e) {
        print(e);
      }

      return SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 24),
                  HeaderText(headerText: strRegister),
                  const SizedBox(height: 24),
                  Text(strRegisterAccount, style: DescriptionStyle()),
                  const SizedBox(height: 24),
                  CustomInput(
                      textController: nameController,
                      labelText: strName,
                      prefixIcon: Icons.person,
                      textInputType: TextInputType.text,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter name.';
                        }

                        return null;
                      }),
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
                          buttonText: strRegister, onPressed: onRegisterPress),
                  const SizedBox(height: 24),
                  Center(child: Text(strHaveAccount, style: SubTitleStyle())),
                  CustomFlatButton(
                      buttonText: strCapsLogin,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        widget.animateToPage(0);
                      }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  onRegisterPress() async {
    FocusScope.of(context).unfocus();
    if (formKey.currentState.validate()) {
      BlocProvider.of<RegisterBloc>(context).add(RegisterPressAction(emailController.text.trim(), passwordController.text.trim(), nameController.text.trim()));
    }
  }
}
