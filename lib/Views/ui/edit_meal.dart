import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Models/meal_model.dart';
import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

import '../../Controllers/meals_provider.dart';
import '../../Services/helper.dart';

class EditMealPage extends StatefulWidget {
  const EditMealPage({super.key});

  @override
  _EditMealPageState createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
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

  Future<void> uploadImages(List<String> imageUrl) async {
    for (var image in _images!) {
      final File file = File(image.path);
      try {
        await _storage
            .ref('uploads/${Uri.file(image.path).pathSegments.last}')
            .putFile(file);
        String downloadURL = await _storage
            .ref('uploads/${Uri.file(image.path).pathSegments.last}')
            .getDownloadURL();
        imageUrl.add(downloadURL);
      } on firebase_storage.FirebaseException catch (e) {
        print(e);
      }
    }
  }

  bool found = false;
  String id = '';
  String name = '';
  String title = '';
  String category = '';
  String price = '';
  String description = '';

  TextEditingController _name = TextEditingController();
  TextEditingController _title = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _description = TextEditingController();

  final List<TextEditingController> _optionsControllers = [];
  final List<TextEditingController> _componentsControllers = [];
  final TextEditingController _mealIdController = TextEditingController();
  late Meals mealToEdit;
  FireStoreHelper fireStoreHelper = FireStoreHelper();

  @override
  void initState() {
    super.initState();
    FireStoreHelper fireStoreHelper = FireStoreHelper();
    fireStoreHelper.getAllCategories(context);
    var mealsNotifier = Provider.of<MealNotifier>(context, listen: false);
    category = mealsNotifier.categoriesList[0];
  }

  @override
  Widget build(BuildContext context) {
    var mealsNotifier = Provider.of<MealNotifier>(context);
    Locale locale = Localizations.localeOf(context);

    List<String> options = [];
    List<String> components = [];
    List<String> imageUrl = [];


    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE2E2E2),
        
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Edit Meal'),
            InkWell(
                child: const Icon(Icons.refresh),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const EditMealPage()));
                })
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
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
                      const Text('Please Enter the Meal\'s category and ID:'),
                      DropdownButtonFormField<String>(
                        value: mealsNotifier.categoriesList[0],
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        items:
                            mealsNotifier.categoriesList.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            category = value!;
                          });
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _mealIdController,
                              decoration: const InputDecoration(
                                hintText: 'Meal ID',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0), // Add spacing
                          ElevatedButton(
                            onPressed: () {
                              String mealId = _mealIdController.text;
                              for (Meals meal in mealsNotifier.allMealsList) {
                                if (meal.id == mealId &&
                                    meal.category == category) {
                                  setState(() {
                                    mealToEdit = Meals(
                                      id: meal.id,
                                      name: meal.name,
                                      category: meal.category,
                                      imageUrl: List<dynamic>.from(meal.imageUrl), // Create new List to avoid reference sharing
                                      price: meal.price,
                                      description: meal.description,
                                      title: meal.title,
                                      components: List<dynamic>.from(meal.components), // Create new List to avoid reference sharing
                                      options: meal.options != null ? List<dynamic>.from(meal.options!) : null, // New list if not null
                                      qty: meal.qty,
                                    );                                    _name.text = mealToEdit.name;
                                    _title.text = mealToEdit.title;
                                    _price.text = mealToEdit.price;
                                    _description.text = mealToEdit.description;
                                  });
                                  found = true;
                                }
                              }
                              if (!found) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Meal Not Found'),
                                      content: const Text(
                                          'No meals found with the entered ID and category.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const EditMealPage()));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(labelText: 'Name'),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      TextFormField(
                        controller: _title,
                        decoration: const InputDecoration(labelText: 'Title'),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: found
                            ? mealToEdit.category
                            : mealsNotifier.categoriesList[0],
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        items:
                            mealsNotifier.categoriesList.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            category = value!;
                          });
                        },
                      ),
                      TextFormField(
                        controller: _price,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType:
                            TextInputType.number, // Set keyboard type to number
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly, // Allow only digits
                        ],
                        onChanged: (value) {
                          setState(() {
                            price = value;
                          });
                        },
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: _description,
                        decoration:
                            const InputDecoration(labelText: 'Description'),
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
                            const Text(
                              "Options:",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400),
                            ),
                            found
                                ? ListView.builder(
                                    shrinkWrap:
                                        true,
                                    itemCount: mealToEdit.options?.length,
                                    itemBuilder: (context, index) {
                                      options.add(mealToEdit.options?[index]);
                                      return ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(mealToEdit.options?[index]),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  mealToEdit.options
                                                      ?.removeAt(index);
                                                  options.removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: const Icon(Icons.remove),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 5.0,
                            ),
                            ..._optionsControllers.map((controller) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                          labelText: 'Option',
                                          hintText: "Enter an option."),
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
                                  _optionsControllers
                                      .add(TextEditingController());
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
                        decoration: const BoxDecoration(color: Colors.black),
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
                            const Text(
                              "Components:",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            found
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: mealToEdit.components.length,
                                    itemBuilder: (context, index) {
                                      components
                                          .add(mealToEdit.components[index]);
                                       return ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(mealToEdit.components[index]),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  mealToEdit.components
                                                      .removeAt(index);
                                                  components.removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: const Icon(Icons.remove),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : SizedBox(),
                            ..._componentsControllers.map((controller) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                          labelText: 'Component',
                                          hintText: "Enter a component."),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        _componentsControllers
                                            .remove(controller);
                                      });
                                    },
                                  ),
                                ],
                              );
                            }),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _componentsControllers
                                      .add(TextEditingController());
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
                        decoration: const BoxDecoration(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Text(
                        "Images:",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      found
                          ? Container(
                              height: 75,
                              child: GridView.builder(
                                  itemCount: mealToEdit.imageUrl.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 6,
                                  ),
                                  itemBuilder: (context, index) {
                                    imageUrl.add(mealToEdit.imageUrl[index]);
                                    return Image.network(
                                      mealToEdit.imageUrl[index],
                                      scale: 1,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                            child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                        ));
                                      },
                                    );
                                  }),
                            )
                          : Container(),
                      TextButton(
                        onPressed: pickImages,
                        child: Text('Pick Images'),
                      ),
                      _images != null
                          ? Container(
                              height: 75,
                              child: GridView.builder(
                                itemCount: _images!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                            overlayColor:
                                WidgetStateProperty.all(Colors.white70),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.white60)),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          if (_images != null) {
                            await uploadImages(imageUrl);
                          }

                          for (TextEditingController controller
                              in _componentsControllers) {
                            components.add(controller.text);
                          }

                          for (TextEditingController controller
                              in _optionsControllers) {
                            options.add(controller.text);
                          }
                          if (_name.text.isEmpty ||
                              _price.text.isEmpty ||
                              components.isEmpty ||
                              _description.text.isEmpty ||
                              imageUrl.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Missing Information'),
                                  content: const Text(
                                      'Please fill in all the required fields.'),
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
                          } else {
                            FireStoreHelper fireStoreHelper = FireStoreHelper();
                            fireStoreHelper.editMeal(
                                context,
                                locale.toString(),
                                category,
                                mealToEdit.id,
                                _name.text,
                                _title.text,
                                _description.text,
                                imageUrl,
                                options,
                                components,
                                _price.text);
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                        // },
                        ,
                        child: const Text('Submit',
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
