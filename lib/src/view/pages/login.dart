import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/basic_models/employee.dart';
import '../../model/common_models/name.dart';
import '../../services/auth/login_manager.dart';
import '../../services/auth/user.dart';
import '../../services/middleware/middleware_application.dart';
import '../../services/middleware/request/authentication_middleware.dart';
import '../../services/middleware/response/response_display_middleware.dart';
import '../widgets/middleware_context/request_middleware_context.dart';
import '../widgets/permissions/user_manager.dart';
import '../widgets/middleware_context/response_middleware_context.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(scaffoldBackgroundColor: const Color(0xffebe6e1)),
      child: Scaffold(
        body: ResponseMiddlewareContext(
          middlewareBuilders: const [
            ResponseDisplayMiddleware.new,
          ],
          child: RequestMiddlewareContext(
            middlewareBuilders: const [RequestAuthMiddleware.new],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: buildZlagodaLabel(),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(.5), width: .5),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: buildForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildZlagodaLabel() =>
      const Text('Злагода', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600));

  Widget buildForm() {
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

  void login() async {
    // final userManager = UserManager.of(context);
    final loginManager = LoginManager.of(context);

    final user = await loginManager.login(loginController.text, passwordController.text);
    if (user == null || !mounted) return;

    Navigator.of(context).pushReplacementNamed('/app');
  }
}

const testUser = User(
  userId: '1',
  login: 'mitrypk',
  position: Position.manager,
  name: Name(firstName: 'Дмитро', middleName: 'Григорович', lastName: 'Попов'),
);
