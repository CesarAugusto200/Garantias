import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'Cliente';

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('⚠️ Introduce un correo y contraseña válidos')));
      return;
    }

    try {
      print("🔎 Intentando registrar usuario con email: $email y rol: $_role");

      User? user = await AuthService().registerUser(email, password, _role);

      if (user != null) {
        print("✅ Usuario creado con éxito - ID: ${user.uid}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Registro exitoso!')));
        Navigator.pop(context);
      } else {
        print("❌ Error inesperado al registrar usuario.");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error al registrar usuario')));
      }
    } catch (e) {
      print("❌ Error Firebase Auth: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error al registrar usuario: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add, color: Colors.deepPurple, size: 50),
                    SizedBox(height: 10),
                    Text("Crear Cuenta", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                    SizedBox(height: 10),
                    _buildTextField(_emailController, "Correo electrónico", Icons.email),
                    SizedBox(height: 15),
                    _buildTextField(_passwordController, "Contraseña", Icons.lock, isPassword: true),
                    SizedBox(height: 20),
                    _buildRoleSelector(),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 4,
                      ),
                      onPressed: _registerUser,
                      child: Text("Registrar", style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    SizedBox(height: 15),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "¿Ya tienes cuenta? Inicia sesión aquí",
                        style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        value: _role,
        items: ['Cliente', 'Vendedor'].map((role) => DropdownMenuItem(value: role, child: Text(role))).toList(),
        onChanged: (value) => setState(() => _role = value!),
        underline: Container(),
      ),
    );
  }
}
