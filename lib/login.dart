import 'package:example_flutter/view_models/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'errors/invalid_credentials_exception.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final _formKey = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  String? _error;

  _LoginViewState();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final auth = context.read<AuthProvider>();
      await auth.login(_email.text, _password.text);
    } on InvalidCredentialsException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  String? validateEmail(String? value) {
    const pattern =
        r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isEmpty || !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            children: [
              Center(
                child: Text(
                  "Ingrese sus datos",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
                decoration: const InputDecoration(
                  hintText: "Enter your email here",
                ),
                onFieldSubmitted: (_) => _submit(),
              ),
              TextFormField(
                controller: _password,
                decoration: const InputDecoration(
                  hintText: "Enter your password here",
                ),
                validator:
                    (value) =>
                        value == null || value.length < 8
                            ? "Enter a valid password"
                            : null,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
              ),

              SizedBox(
                height: 40,
                child:
                    _error != null
                        ? Text(_error!, style: TextStyle(color: Colors.red))
                        : null,
              ),

              ElevatedButton(
                onPressed: _submit,
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                  padding: WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.all(16),
                  ),

                  overlayColor: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.pressed)) {
                      return Colors.blue.shade900.withValues(alpha: 0.3);
                    }

                    return null;
                  }),
                ),
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
