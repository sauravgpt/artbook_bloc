import 'package:artbook/models/failure_model.dart';
import 'package:artbook/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  void emailChanges(String value) {
    emit(state.copyWith(
      email: value,
      status: LoginStatus.initial,
    ));
  }

  void passwordChanges(String value) {
    emit(state.copyWith(
      password: value,
      status: LoginStatus.initial,
    ));
  }

  void loginWithCredentials() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;

    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.signInWithUserNameAndPassword(
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(status: LoginStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(
        status: LoginStatus.error,
        failure: err,
      ));
    }
  }
}
