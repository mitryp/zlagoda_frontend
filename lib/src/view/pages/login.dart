import 'package:flutter/material.dart';

import '../../model/basic_models/employee.dart';
import '../../model/common_models/name.dart';
import '../../services/auth/login_manager.dart';
import '../../services/auth/user.dart';
import '../../services/middleware/middleware_application.dart';
import '../../services/middleware/response/response_display_middleware.dart';
import '../widgets/middleware_context/response_middleware_context.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  bool? sessionRestored;

  LoginManager get loginManager => LoginManager.of(context);

  @override
  void initState() {
    super.initState();
    restoreSession();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: const Color(0xffebe6e1)),
      child: Scaffold(
        body: ResponseMiddlewareContext(
          middlewareBuilders: const [
            ResponseDisplayMiddleware.errors,
          ],
          child: Center(
            child: buildContent(),
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    final sessionRestored = this.sessionRestored;
    if (sessionRestored == null) {
      return const CircularProgressIndicator();
    }

    if (sessionRestored) {
      redirectToApp();
      return const Text('Вас переадресовано на головну сторінку');
    }

    return buildFormContainer(context);
  }

  Widget buildFormContainer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: buildZlagodaLabel(context),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(.5), width: .5),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: buildForm(context),
        ),
      ],
    );
  }

  Widget buildZlagodaLabel(BuildContext context) =>
      const Text('Злагода', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600));

  Widget buildForm(BuildContext context) {
    const divider = Padding(padding: EdgeInsets.only(top: 15));

    return Form(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 300,
        child: Flex(
          direction: Axis.vertical,
          children: [
            TextFormField(
              controller: loginController,
              decoration: const InputDecoration(
                label: Text('Логін'),
              ),
            ),
            divider,
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                label: Text('Пароль'),
              ),
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              onEditingComplete: login,
            ),
            divider,
            divider,
            ElevatedButton(
              onPressed: login,
              child: const Text('Увійти'),
            ),
          ],
        ),
      ),
    );
  }

  void restoreSession() {
    loginManager.authorizeCachedUser().then((status) {
      if (mounted) {
        setState(() => sessionRestored = status);
      }
    });
  }

  void login() async {
    final success = await loginManager.login(loginController.text, passwordController.text);

    if (success) {
      redirectToApp();
    }
  }

  void redirectToApp() {
    clearResponseMiddlewares();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/app');
      }
    });
  }
}

const testUser = User(
  userId: '1',
  login: 'local',
  role: Position.manager,
  name: Name(firstName: 'Локальний користувач', middleName: '', lastName: ''),
);
