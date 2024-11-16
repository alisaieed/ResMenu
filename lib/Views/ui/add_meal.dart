import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

import '../../Controllers/meals_provider.dart';
import '../../Services/helper.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();

  List<XFile>? _images;
  final ImagePicker _picker = ImagePicker();
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> pickImages() async {
    final pickedImages = await _picker.pickMultiImage();
    setState(() {
      _images = pickedImages;
    });
  }

  bool _isLoading = false;
  Helper helper = Helper();

  Future<void> uploadImages() async {
    for (var image in _images!) {
      final File file = File(image.path);
      try {
        await _storage.ref('uploads/${Uri.file(image.path).pathSegments.last}').putFile(file);
        String downloadURL = await _storage.ref('uploads/${Uri.file(image.path).pathSegments.last}').getDownloadURL();
        print(downloadURL);
        imageUrl.add(downloadURL);
      } on firebase_storage.FirebaseException catch (e) {
        print(e);
      }
    }
  }

  String id = '';
  String name = '';
  String title = '';
  String category = '';
  String price = '';
  List<String> imageUrl = [];
  List<String> components = [];
  String description = '';
  List<String> options = [];
  final List<TextEditingController> _optionsControllers = [];
  final List<TextEditingController> _componentsControllers = [];

  @override
  void initState() {
    super.initState();
    FireStoreHelper fireStoreHelper = FireStoreHelper();
    fireStoreHelper.getAllCategories(context);

    var mealsNotifier = Provider.of<MealNotifier>(context, listen: false);
    category =  mealsNotifier.categoriesList[0];
  }

  @override
  Widget build(BuildContext context) {

    var mealsNotifier = Provider.of<MealNotifier>(context);
    Locale locale = Localizations.localeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E2E2),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add Meal'),
            InkWell(
              child: const Icon(
                Icons.refresh
              ),
              onTap: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                    builder: (BuildContext context) => const AddMealPage()));
              }
            )
          ],
        ),
      ),
      body: _isLoading? const Center(
        child: CircularProgressIndicator(),
      )

    : SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextFormField(
                  initialValue: title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: mealsNotifier.categoriesList[0],
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: mealsNotifier.categoriesList.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      category = value!;
                      print(category);
                    });
                  },
                ),
                TextFormField(
                  initialValue: price,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number, // Set keyboard type to number
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                  onChanged: (value) {
                    setState(() {
                      price = value;
                    });
                  },
                ),
                TextFormField(
                  maxLines: 3,
                  initialValue: description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 5.0,
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text("Options:",
                      style: TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w400
                      ),),
                      const SizedBox(
                        height: 5.0,
                      ),
                      ..._optionsControllers.map((controller) {
                        return Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                decoration: const InputDecoration(labelText: 'Option',
                                    hintText: "Enter an option then click on check icon."),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  _optionsControllers.remove(controller);
                                });
                              },
                            ),
                          ],
                        );
                      }),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _optionsControllers.add(TextEditingController());
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  height: 0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.black
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      const Text("Components:",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400
                        ),),
                      const SizedBox(
                        height: 5.0,
                      ),
                      ..._componentsControllers.map((controller) {
                        return Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                decoration: const InputDecoration(labelText: 'Component',
                                    hintText: "Enter a component."),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  _componentsControllers.remove(controller);
                                });
                              },
                            ),
                          ],
                        );
                      }),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _componentsControllers.add(TextEditingController());
                          });
                        },
                        icon: const Icon(
                          Icons.add, size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  height: 0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.black
                  ),
                ),

                const SizedBox(
                  height: 15.0,
                ),

                const Text("Images:",
                  style: TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.w400
                  ),),
                const SizedBox(
                  height: 5.0,
                ),

                TextButton(

                  onPressed: pickImages,
                  child: Text('Pick Images'),
                ),

                _images != null
                    ? Container(
                  height: 75,
                      child: GridView.builder(
                        itemCount: _images!.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                        ),
                        itemBuilder: (context, index) {
                          return Image.file(
                            File(_images![index].path),

                            scale: 1,
                          );
                        },
                      ),
                    )
                    : Container(),


                ElevatedButton(
                  style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.white70),
                      backgroundColor: WidgetStateProperty.all(Colors.white60)
                  ),
                  onPressed: () async {
                    print(category);
                    setState(() {
                      _isLoading = true;
                    });
                   if (_images != null) {
                   await  uploadImages();
                   }

                      for (TextEditingController controller in _componentsControllers) {
                        components.add(controller.text);
                      }

                      for (TextEditingController controller in _optionsControllers) {
                        options.add(controller.text);
                      }
                    print(imageUrl);
                    if (name.isEmpty || price.isEmpty || components.isEmpty ||
                          options.isEmpty || description.isEmpty || imageUrl.isEmpty) {
                      print("$locale , $id, $name,$title, $category, $price\n$options\n$components\n$imageUrl");
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Missing Information'),
                              content: const Text('Please fill in all the required fields.'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      setState(() {
                        _isLoading = false;
                      });
                    }
                      else {
                       int _id = await helper.mealIdGenerate(category, locale);
                       id = _id.toString();
                          print("$locale , $id, $name,$title, $category, $price\n$options\n$components\n$imageUrl");


                          FireStoreHelper fireStoreHelper = FireStoreHelper();
                          fireStoreHelper.addMeal(
                              context,locale.toString(),category, id,name,title,description,imageUrl, options, components, price
                          );

                          setState(() {
                            _isLoading = false;
                          });

                        }
                      }
                  // },
                  ,child: const Text('Submit',
                      style: TextStyle(color: Colors.black87)),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
