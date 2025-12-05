import 'package:flutter/material.dart';
import 'registrasi_page.dart';
import 'produk_page.dart';

class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;
        final _emailTextboxController = TextEditingController();
        final _passwordTextboxController = TextEditingController();

        @override
        void dispose() {
            _emailTextboxController.dispose();
            _passwordTextboxController.dispose();
            super.dispose();
        }

        @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Login'),
            ),
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            children: [
                                _emailTextField(),
                                _passwordTextField(),
                                _buttonLogin(),
                                const SizedBox(
                                    height: 30,
                                ),
                                _menuRegistrasi()
                            ]
                        )
                    )
                )
            ),
        );
    }

    Widget _emailTextField() {
        return TextFormField(
            decoration: const InputDecoration(
                labelText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
            controller: _emailTextboxController,
            validator: (value) {
                if  (value!.isEmpty) {
                    return 'Email harus diisi';
                }
                return null;
            }
        );
    }

    Widget _passwordTextField() {
        return TextFormField(
            decoration: const InputDecoration(
                labelText: 'Password',
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: _passwordTextboxController,
            validator: (value) {
                if (value!.isEmpty) {
                    return 'Password harus diisi';
                }
                return null;
            }
        );
    }

    Widget _buttonLogin() {
        return ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    var validate = _formKey.currentState!.validate();
                    if (!validate) return;
                    setState(() { _isLoading = true; });
                    // Simulasi login sukses (ganti dengan API call jika ada)
                    await Future.delayed(const Duration(seconds: 1));
                    if (!mounted) return;
                    setState(() { _isLoading = false; });
                    // Navigasi ke ProdukPage
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ProdukPage()),
                    );
                },
            child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Login'),
        );
    }

    Widget _menuRegistrasi() {
        return Center(
            child: InkWell(
                child: const Text("Registrasi",
                style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RegistrasiPage())
                    );
                }
            ),
        );
    }
}