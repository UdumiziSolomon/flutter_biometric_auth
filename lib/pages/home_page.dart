import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthenticated) {
          final bool canAuthenticateWithBiometrics =
              await _auth.canCheckBiometrics;

          try {
            if (canAuthenticateWithBiometrics) {
              final bool didAuthenticate = await _auth.authenticate(
                  localizedReason:
                      "Please authenticate so we can show you your balance",
                  options: const AuthenticationOptions(biometricOnly: false));
              setState(() {
                _isAuthenticated = didAuthenticate;
              });
            }
          } catch (e) {
            print(e);
          }
        } else {
          setState(() {
            _isAuthenticated = false;
          });
        }
      },
      child: Icon(_isAuthenticated ? Icons.lock : Icons.lock_open),
    );
  }

  Widget _buildUI() {
    return (SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Account Balance',
            style: TextStyle(fontSize: 23, fontFamily: 'Jose'),
          ),
          const SizedBox(
            height: 5,
          ),
          if (_isAuthenticated)
            const Text(
              '\$ 1090.69',
              style: TextStyle(fontSize: 26, fontFamily: 'Jose'),
            ),
          if (!_isAuthenticated)
            const Text(
              '*******',
              style: TextStyle(fontSize: 26, fontFamily: 'Jose'),
            )
        ],
      ),
    ));
  }
}
