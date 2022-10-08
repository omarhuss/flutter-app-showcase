import 'package:flutter_demo/core/domain/model/user.dart';
import 'package:flutter_demo/features/auth/domain/model/log_in_failure.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_utils/test_utils.dart';
import '../mocks/auth_mock_definitions.dart';
import '../mocks/auth_mocks.dart';

void main() {
  late LoginPresentationModel model;
  late LoginPresenter presenter;
  late MockLoginNavigator navigator;
  test(
    'Show a successful dialog when LoginUseCase is successful.',
    () async {
      // GIVEN
      when(
        () => AuthMocks.logInUseCase.execute(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => successFuture(const User.anonymous()));
      when(
        () => navigator.showAlert(
          title: any(named: 'title'),
          message: any(named: 'message'),
        ),
      ).thenAnswer((_) => Future.value());

      // WHEN
      await presenter.login();

      // THEN
      verify(
        () => navigator.showAlert(
          title: any(named: 'title'),
          message: any(named: 'message'),
        ),
      ).called(1);
    },
  );

  test(
    'Show an error dialog when LoginUseCase is unsuccessful.',
    () async {
      // GIVEN
      when(
        () => AuthMocks.logInUseCase.execute(
          username: any(named: 'username'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) => failFuture(const LoginFailure.unknown()));
      when(() => navigator.showError(any())).thenAnswer((_) => Future.value());

      // WHEN
      await presenter.login();

      // THEN
      verify(() => navigator.showError(any())).called(1);
    },
  );

  test(
    'Test the initial state of the LoginPresentationModel.',
    () {
      // GIVEN
      const params = LoginInitialParams();
      final model = LoginPresentationModel.initial(params);

      // THEN
      expect(model.username, '');
      expect(model.password, '');
      expect(model.isLoading, false);
    },
  );

  setUp(() {
    model = LoginPresentationModel.initial(const LoginInitialParams());
    navigator = MockLoginNavigator();
    presenter = LoginPresenter(
      model,
      navigator,
      AuthMocks.logInUseCase,
    );
  });
}
