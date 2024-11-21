import 'dart:io';
import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:ecommerce_app/Views/ui/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Controllers/meals_provider.dart';
import '../../Services/helper.dart';

class AddMealPage extends StatefulWidget {
  const AddMealPage({super.key});

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();

  List<XFile>? _images = [];
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
        await _storage
            .ref('uploads/${Uri.file(image.path).pathSegments.last}')
            .putFile(file);
        String downloadURL = await _storage
            .ref('uploads/${Uri.file(image.path).pathSegments.last}')
            .getDownloadURL();
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
    category = mealsNotifier.categoriesList[0];
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
            Text(
              AppLocalizations.of(context)!.addMeal,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            InkWell(
                child: const Icon(Icons.refresh),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const AddMealPage()));
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.013,
                      ),
                      TextFormField(
                        initialValue: name,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.name,
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.024,
                      ),
                      TextFormField(
                        initialValue: title,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.title,
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.024,
                      ),
                      DropdownButtonFormField<String>(
                        value: mealsNotifier.categoriesList[0],
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.category,
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        iconSize: 25,
                        dropdownColor: Colors.grey.shade300,
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.024,
                      ),
                      TextFormField(
                        initialValue: price,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.price,
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.024,
                      ),
                      TextFormField(
                        maxLines: 3,
                        initialValue: description,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.description,
                          labelStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            description = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.024,
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
                            Text(
                              AppLocalizations.of(context)!.options,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            ..._optionsControllers.map((controller) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: TextFormField(
                                        controller: controller,
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .enterOption,
                                          labelStyle:
                                              const TextStyle(fontSize: 16),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 16),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                      ),
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
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 40),
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
                            Text(
                              AppLocalizations.of(context)!.components,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            ..._componentsControllers.map((controller) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: TextFormField(
                                        controller: controller,
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .enterComponent,
                                          labelStyle:
                                              const TextStyle(fontSize: 16),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 16),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                      ),
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
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        height: 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0,
                            bottom:
                                8.0), // Add top and bottom padding for the title
                        child: Text(
                          AppLocalizations.of(context)!.images,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height:
                            5.0, // Maintain a small gap between title and button
                      ),
                      IconButton(
                        onPressed: () {
                          pickImages();
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 20,
                        ),
                      ),
                      _images!.isNotEmpty
                          ? Container(
                              height: MediaQuery.of(context).size.height*0.147,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal:
                                      16), // Add padding around the grid
                              child: GridView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _images!.length,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 120,
                                  mainAxisSpacing: 12.0,
                                  crossAxisSpacing: 12.0,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10), // Rounded corners
                                          border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 2), // Subtle border
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 3,
                                              blurRadius:
                                                  5, // Soft shadow for depth
                                              offset: const Offset(0,
                                                  3), // Positioning the shadow
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10), // Make the image fit within rounded corners
                                          child: Image.file(
                                            File(_images![index].path),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: Container(
                                          width: MediaQuery.of(context).size.height*0.08,
                                          height: MediaQuery.of(context).size.height*0.036,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            icon:
                                                const Icon(Icons.remove_circle),
                                            color: Colors.red,
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              setState(() {
                                                _images?.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.024,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            backgroundColor: Colors.grey.shade500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            if (_images != null) {
                              await uploadImages();
                            }

                            for (TextEditingController controller
                                in _componentsControllers) {
                              components.add(controller.text);
                            }

                            for (TextEditingController controller
                                in _optionsControllers) {
                              options.add(controller.text);
                            }
                            if (name.isEmpty ||
                                price.isEmpty ||
                                components.isEmpty ||
                                options.isEmpty ||
                                description.isEmpty ||
                                imageUrl.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(AppLocalizations.of(context)!
                                        .missingInformation),
                                    content: Text(AppLocalizations.of(context)!
                                        .informationFill),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                            AppLocalizations.of(context)!.ok),
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
                              int _id =
                                  await helper.mealIdGenerate(category, locale);
                              id = _id.toString();
                              print(
                                  "$locale , $id, $name,$title, $category, $price\n$options\n$components\n$imageUrl");

                              FireStoreHelper fireStoreHelper =
                                  FireStoreHelper();
                              try {
                                fireStoreHelper.addMeal(
                                    context,
                                    locale.toString(),
                                    category,
                                    id,
                                    name,
                                    title,
                                    description,
                                    imageUrl,
                                    options,
                                    components,
                                    price);

                                setState(() {
                                  _isLoading = false;
                                });

                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!.success),
                                      content: Text(AppLocalizations.of(context)!.mealAdded),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(AppLocalizations.of(context)!.ok),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();

                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        const SettingsPage()));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } catch (e) {
                                // Show error dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!.error),
                                      content: Text('${AppLocalizations.of(context)!.mealNotAdded}: $e'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(AppLocalizations.of(context)!.ok),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();

                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          }
                          // },
                          ,
                          child: Text(AppLocalizations.of(context)!.submit,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.036,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
