import 'package:artbook/models/failure_model.dart';
import 'package:artbook/repositories/auth/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;
  SignupCubit({@required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  void usernameChanges(String value) {
    emit(state.copyWith(
      username: value,
      status: SignupStatus.initial,
    ));
  }

  void emailChanges(String value) {
    emit(state.copyWith(
      email: value,
      status: SignupStatus.initial,
    ));
  }

  void passwordChanges(String value) {
    emit(state.copyWith(
      password: value,
      status: SignupStatus.initial,
    ));
  }

  void signupWithCredentials() async {
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;

    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      await _authRepository.signUpWithUsernameAndPassword(
        username: state.username,
        email: state.email,
        password: state.password,
      );

      emit(state.copyWith(status: SignupStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(
        status: SignupStatus.error,
        failure: err,
      ));
    }
  }
}
