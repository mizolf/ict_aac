import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:ict_aac/models/pictogram.dart";
import "package:ict_aac/widgets/image_input.dart";

class AddPictogramScreen extends StatefulWidget {
  const AddPictogramScreen({super.key});

  @override
  State<AddPictogramScreen> createState() => _AddPictogramScreenState();
}

class _AddPictogramScreenState extends State<AddPictogramScreen> {
  var _titleController = TextEditingController();
  String? _imageUrl;

  void _savePictogram() async {
    final enteredText = _titleController.text;

    if (enteredText.isEmpty || _imageUrl == null) {
      return;
    }

    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userId = currentUser.uid;

      Pictogram pictogram = Pictogram(
        label: enteredText,
        image: _imageUrl!,
        custom: true,
        category: 'personalizirano',
        description: '',
      );

      Map<String, dynamic> pictogramMap = pictogram.toMap();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('customPictograms')
          .add(pictogramMap);
    }
  }

  void _setImageUrl(String imageUrl) {
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      appBar: AppBar(
        title: const Text('Dodaj svoj simbol'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: 'Naziv simbola',
              ),
              keyboardType: TextInputType.text,
              controller: _titleController,
            ),
            const SizedBox(
              height: 16,
            ),
            ImageInput(onImagePicked: _setImageUrl),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {
                _savePictogram();
                Navigator.of(context).pop();
              },
              label: const Text('Dodaj simbol'),
            ),
          ],
        ),
      ),
    );
  }
}
