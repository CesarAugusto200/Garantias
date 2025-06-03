import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // ✅ Biblioteca para formatear fechas

class HomeClienteScreen extends StatefulWidget {
  @override
  _HomeClienteScreenState createState() => _HomeClienteScreenState();
}

class _HomeClienteScreenState extends State<HomeClienteScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> warranties = [];
  String userEmail = ""; //  Variable para almacenar el correo del usuario

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadWarranties();
  }

  /// Obtiene el correo del usuario autenticado
  void _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "Usuario";
      });
    }
  }

  /// Carga las garantías del usuario desde Firestore
  void _loadWarranties() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _db.collection('users').doc(user.uid).collection('warranties').get();
      setState(() {
        warranties = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      });
    }
  }


  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mis Garantías'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blueAccent),
            ),
            onSelected: (value) {
              if (value == "logout") _logout();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "logout", child: Text("Cerrar sesión")),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "👋 ¡Bienvenido, $userEmail!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 10),
            Text("Aquí puedes ver las garantías que te han asignado.", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            SizedBox(height: 20),
            Expanded(
              child: warranties.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Colors.grey[600], size: 50),
                    SizedBox(height: 10),
                    Text("No tienes garantías registradas", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: warranties.length,
                itemBuilder: (context, index) {
                  var warranty = warranties[index];

                  // ✅ Formatear fechas de compra y expiración
                  String formattedPurchaseDate = DateFormat('d \'de\' MMMM \'de\' yyyy')
                      .format((warranty['purchaseDate'] as Timestamp).toDate());
                  String formattedExpirationDate = DateFormat('d \'de\' MMMM \'de\' yyyy \'a las\' HH:mm')
                      .format((warranty['expirationDate'] as Timestamp).toDate());

                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            warranty['product'],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 5),
                          Text("📍 Tienda: ${warranty['store']}"),
                          Text("📅 Fecha de compra: $formattedPurchaseDate"), // ✅ Fecha clara
                          Text("⌛ Expira el: $formattedExpirationDate"), // ✅ Fecha y hora bien formateadas
                          SizedBox(height: 10),
                          Text("🛒 ${warranty['message']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
