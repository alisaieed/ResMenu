import 'dart:io';
// import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Services/helper.dart';
import 'package:ecommerce_app/Views/ui/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import '../../Models/restaurantID.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditRestaurantPage extends StatefulWidget {
  @override
  _EditRestaurantPageState createState() => _EditRestaurantPageState();
}

class _EditRestaurantPageState extends State<EditRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  String restaurantNameEN = '';
  String restaurantNameAR = '';
  String sloganEN = '';
  String sloganAR = '';
  String logo = '';
  Helper helper = Helper();
  String _logoPath = "";
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {

        await uploadImage(_logoPath);
        final restaurant = Restaurant(
          restaurantNameEN: restaurantNameEN,
          restaurantNameAR: restaurantNameAR,
          logo: logo,
        );
        await helper.saveRestaurantData(restaurant);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } catch (e) {
        print("Error during submission: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> uploadImage(String imagePath) async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('restaurant_logos/logo');

      final uploadTask = storageRef.putFile(File(imagePath));

      final snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        logo = downloadUrl;
      });

      print('Image uploaded successfully: $downloadUrl');
    } catch (e) {
      print("Image picking error: $e");
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _logoPath = image.path;
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print("Image picking error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
          backgroundColor: const Color(0xFFE2E2E2),
          title: Text(
            AppLocalizations.of(context)!.editRestaurant,
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.width * 0.045),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      '${AppLocalizations.of(context)!.restaurantName} (EN)',
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) => restaurantNameEN = value,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterNameEN
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText:
                      '${AppLocalizations.of(context)!.restaurantName} (AR)',
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onChanged: (value) => restaurantNameAR = value,
                validator: (value) => value!.isEmpty
                    ? AppLocalizations.of(context)!.enterNameAR
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.logo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.add,
                            size: 32,
                            color: Colors.black54,
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  _logoPath != ""
                      ? Center(
                          child: Image.file(
                            File(_logoPath),
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(AppLocalizations.of(context)!.noImageSelected),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: _isLoading
                    ? const CircularProgressIndicator() // Show the loader when loading
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              backgroundColor: Colors.grey.shade500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 2,
                            ),
                            onPressed: _submit,
                            child: Text(
                              AppLocalizations.of(context)!.submit,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                helper.clearRestaurantData();
                                Navigator.pop(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.reset,
                                style: const TextStyle(
                                    color: Colors.black45, fontSize: 10),
                              ))
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
