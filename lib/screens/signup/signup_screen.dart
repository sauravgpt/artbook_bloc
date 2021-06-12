import 'package:artbook/repositories/auth/auth_repository.dart';
import 'package:artbook/screens/signup/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
          create: (_) =>
              SignupCubit(authRepository: context.read<AuthRepository>()),
          child: SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error)
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    state.failure.message,
                  ),
                ),
              );
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'ArtBook',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Username'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .usernameChanges(value),
                              validator: (value) => value.length < 6
                                  ? 'Must be 6 characters long'
                                  : null,
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Email'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .emailChanges(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Please valid email'
                                  : null,
                            ),
                            SizedBox(height: 12),
                            TextFormField(
                              decoration: InputDecoration(hintText: 'Password'),
                              onChanged: (value) => context
                                  .read<SignupCubit>()
                                  .passwordChanges(value),
                              validator: (value) => (value.length < 6)
                                  ? 'Must be atleast 6 characters'
                                  : null,
                            ),
                            const SizedBox(height: 28),
                            ElevatedButton(
                              onPressed: () => _submitForm(context,
                                  state.status == SignupStatus.submitting),
                              child: Text('Signup'),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text("Go back to login screen"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<SignupCubit>().signupWithCredentials();
    }
  }
}
