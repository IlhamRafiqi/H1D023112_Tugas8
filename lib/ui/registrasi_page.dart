import 'package:flutter/material.dart';
import 'package:tokokita/bloc/registrasi_bloc.dart';
import 'package:tokokita/widget/warning_dialog.dart';
import 'package:tokokita/widget/success_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  void dispose() {
    _namaTextboxController.dispose();
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _namaTextField(),
                const SizedBox(height: 16),
                _emailTextField(),
                const SizedBox(height: 16),
                _passwordTextField(),
                const SizedBox(height: 16),
                _passwordKonfirmasiTextField(),
                const SizedBox(height: 24),
                _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Nama",
      ),
      controller: _namaTextboxController,
      validator: (value) {
        if (value == null || value.length < 3) {
          return 'Nama harus diisi minimal 3 karakter';
        }
        return null;
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Email",
      ),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email harus diisi';
        }
        // Validator email stabil & sederhana
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Email tidak valid';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Password",
      ),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value == null || value.length < 6) {
          return 'Password minimal 6 karakter';
        }
        return null;
      },
    );
  }

  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Konfirmasi Password",
      ),
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return 'Konfirmasi password tidak sama';
        }
        return null;
      },
    );
  }

  Widget _buttonRegistrasi() {
    return ElevatedButton(
      child: const Text("Registrasi"),
      onPressed: () {
        print("== TOMBOL DIREMTEKAN ==");
        var validate = _formKey.currentState!.validate();
        print("VALIDASI: $validate");

        if (validate) {
          print("MASUK _submit()");
          if (!_isLoading) _submit();
        }
      },
    );
  }

  void _submit() {
    print("== _submit() DIJALANKAN ==");

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    print("MENGIRIM REQUEST KE API...");
    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    )
        .timeout(const Duration(seconds: 15))
        .then((value) {
      print("== RESPONS DITERIMA: BERHASIL ==");

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SuccessDialog(
          description: "Registrasi berhasil, silahkan login",
          okClick: () {
            Navigator.pop(context);
          },
        ),
      );
    }, onError: (error) {
      print("== TERJADI ERROR ==");
      print(error);

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            const WarningDialog(description: "Registrasi gagal, silahkan coba lagi"),
      );
    }).whenComplete(() {
      print("== REQUEST SELESAI ==");

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }
}
