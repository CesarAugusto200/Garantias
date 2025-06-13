import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../data/models/Warranty.dart';
import 'WarrantyDetailsScreen.dart';

class HomeClienteScreen extends StatefulWidget {
  @override
  _HomeClienteScreenState createState() => _HomeClienteScreenState();
}

class _HomeClienteScreenState extends State<HomeClienteScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> warranties = [];
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadWarranties();
  }

  void _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email ?? "Usuario";
      });
    }
  }

  void _loadWarranties() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _db.collection('users').doc(user.uid).collection('warranties').get();
      setState(() {
        warranties = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            ...data,
            'customerEmail': data['customerEmail'] ?? 'Correo no disponible',
          };
        }).toList();
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Mis Garantías', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.deepPurple),
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 10),
            Text("Aquí puedes ver las garantías que te han asignado.", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            SizedBox(height: 20),
            Expanded(
              child: warranties.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.grey[600], size: 60),
                    SizedBox(height: 10),
                    Text("No tienes garantías registradas", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: warranties.length,
                itemBuilder: (context, index) {
                  var warranty = warranties[index];

                  String formattedPurchaseDate = DateFormat('d \'de\' MMMM \'de\' yyyy')
                      .format((warranty['purchaseDate'] as Timestamp).toDate());
                  String formattedExpirationDate = DateFormat('d \'de\' MMMM \'de\' yyyy \'a las\' HH:mm')
                      .format((warranty['expirationDate'] as Timestamp).toDate());

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WarrantyDetailsScreen(warranty: warranty),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]), // 🔹 Fondo degradado
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)], // 🔹 Sombra elegante
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            warranty['product'],
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text("📍 Tienda: ${warranty['store']}", style: TextStyle(color: Colors.white)),
                          Text("📅 Fecha de compra: $formattedPurchaseDate", style: TextStyle(color: Colors.white)),
                          Text("⌛ Expira el: $formattedExpirationDate", style: TextStyle(color: Colors.white)),
                          SizedBox(height: 10),
                          Text("🛒 ${warranty['message']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
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
