import 'package:flutter/material.dart';
import '../components/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profilo'),
          backgroundColor: Colors.blue, // Personalizza il colore dell'app bar
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/unknown.jpg'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_sharp),
                      onPressed: () async {
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          File image = File(pickedFile.path);
                          image.path;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Nome Utente',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Email: user@example.com', // Visualizza l'email dell'utente
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Aggiungi azione per il pulsante Modifica Profilo
                },
                child: const Text('Modifica Profilo'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Aggiungi azione per il pulsante Logout
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavigationBar(context),
      ),
    );
  }
}
