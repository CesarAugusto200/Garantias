import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔹 Registro de usuario con correo, contraseña y rol
  Future<User?> registerUser(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,
      );

      await _db.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
      });

      print("✅ Usuario registrado: ${email} - Rol: ${role}");
      return userCredential.user;
    } catch (e) {
      print('❌ Error al registrar usuario: $e');
      return null;
    }
  }

  ///  Inicio de sesión y recuperación del rol
  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password,
      );

      DocumentSnapshot userDoc =
      await _db.collection('users').doc(userCredential.user!.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        String role = userDoc['role'];
        print("✅ Usuario autenticado - Rol: $role"); // 🔹 Verificación en consola
        return role;
      } else {
        print("❌ Usuario sin rol asignado en Firestore");
        return null;
      }
    } catch (e) {
      print('❌ Error al iniciar sesión: $e');
      return null;
    }
  }

  /// Método para obtener el rol del usuario autenticado
  Future<String?> getUserRole() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return null;

      DocumentSnapshot userDoc = await _db.collection('users').doc(user.uid).get();
      return userDoc.exists ? userDoc['role'] : null;
    } catch (e) {
      print('❌ Error al obtener el rol del usuario: $e');
      return null;
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
    print("✅ Usuario cerrado sesión correctamente");
  }
}
