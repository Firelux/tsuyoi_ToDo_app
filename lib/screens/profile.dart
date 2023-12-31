import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../components/bottom_navigation_bar.dart';
import '../modules/goal.dart';
import '../modules/user.dart';
import '../utils/user_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final userBox = Hive.box("user_box");
  final goalsBox = Hive.box("goals_box");

  User user = User(id: 0, name: "", profileImage: UserUtils.unknownImage());

  late TextEditingController _nameController;
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    if (userBox.isEmpty) {
      User user = User(id: 0, name: "", profileImage: UserUtils.unknownImage());
      userBox.add(user);
    }
    user = userBox.get(0);

    _nameController = TextEditingController(text: user.name);

    refreshUser();
  }

  String profileImage = UserUtils.unknownImage();

  List<Goal> goals = [];

  void refreshUser() {
    final data = userBox.get(0);

    setState(() {
      user = data;
    });
  }

  double value() {
    final goals = goalsBox.values
        .map((goal) => goal as Goal)
        .where((goal) => !goal.daily)
        .toList();

    return goals.isNotEmpty
        ? goals.where((goal) => goal.completed && !goal.daily).length /
            goals.length
        : 0.0;
  }

  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Stack(
                children: <Widget>[
                  ClipOval(
                    child: Image.memory(
                      UserUtils.imageToUint8List(
                          UserUtils.base64ToImage(user.profileImage)),
                      width: 220, // Imposta la larghezza desiderata
                      height: 220, // Imposta l'altezza desiderata
                      fit: BoxFit.cover, // Imposta la modalità di riempimento
                    ),
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
                          Future<String> future =
                              UserUtils.imageToBase64(pickedFile.path);
                          profileImage = await future;
                          user.profileImage = profileImage;
                          userBox.put(0, user);
                          refreshUser();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 50),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextField(
                          maxLength: 25,
                          textAlign: TextAlign.center,
                          controller: _nameController,
                          focusNode: _nameFocus,
                          onSubmitted: (value) {
                            setState(() {
                              user.name = value;
                              UserUtils.updateUser(0, user);
                              isEditing = false;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          setState(() {
                            isEditing = true;

                            FocusScope.of(context).requestFocus(_nameFocus);
                          });
                        },
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Row(children: [
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 10.0,
                      percent: value(),
                      center: Text("${(value() * 100).toStringAsFixed(0)}%"),
                      progressColor: Colors.green,
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {},
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Goals streak",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              goalsBox.values
                                  .map((goal) => goal as Goal)
                                  .where(
                                      (goal) => goal.completed && !goal.daily)
                                  .length
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
              ])
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }
}
