import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CaptureWarrantyPhoto extends StatefulWidget {
  const CaptureWarrantyPhoto({super.key, required String warrantyId});

  @override
  _CaptureWarrantyPhotoState createState() => _CaptureWarrantyPhotoState();
}

class _CaptureWarrantyPhotoState extends State<CaptureWarrantyPhoto> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));

        _saveImageLocally();
      } else {
        print("⚠️ No se seleccionó ninguna imagen.");
      }
    } catch (e) {
      print("❌ Error al tomar la foto: $e");
    }
  }

  Future<void> _saveImageLocally() async {
    if (_image == null || !_image!.existsSync()) {
      print("❌ No hay imagen disponible para guardar.");
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = "${directory.path}/warranty_${DateTime.now().millisecondsSinceEpoch}.jpg";
      await _image!.copy(imagePath);

      print("🔎 Imagen guardada en almacenamiento local: $imagePath"); // ✅ Verifica la ruta

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Foto guardada correctamente!")));

      Navigator.pop(context, imagePath); // 🔹 Retorna la ruta de la imagen al cerrar la pantalla
    } catch (e) {
      print("❌ Error al guardar la imagen localmente: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Capturar Garantía"), backgroundColor: Colors.blueAccent),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.file(_image!, fit: BoxFit.contain),
              )
                  : Text("No hay imagen seleccionada", textAlign: TextAlign.center),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.camera_alt),
                label: Text("Tomar Foto"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
