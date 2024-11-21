import 'dart:io';
import 'package:ecommerce_app/Models/meal_model.dart';
import 'package:ecommerce_app/Services/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../Controllers/meals_provider.dart';
import '../../Services/helper.dart';

class EditMealPage extends StatefulWidget {
  const EditMealPage({super.key});

  @override
  _EditMealPageState createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
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

  final TextEditingController _name = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();

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
            Text(
              AppLocalizations.of(context)!.editMeal,
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
                      Text(
                        AppLocalizations.of(context)!.fillID_Category,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 20,
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
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _mealIdController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.mealID,
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
                            ),
                          ),
                          const SizedBox(width: 8.0), // Add spacing
                          IconButton(
                            onPressed: () {
                              found = false;
                              String mealId = _mealIdController.text;
                              for (Meals meal in mealsNotifier.allMealsList) {
                                if (meal.id == mealId &&
                                    meal.category == category) {
                                  setState(() {
                                    mealToEdit = Meals(
                                      id: meal.id,
                                      name: meal.name,
                                      category: meal.category,
                                      imageUrl:
                                          List<dynamic>.from(meal.imageUrl),
                                      price: meal.price,
                                      description: meal.description,
                                      title: meal.title,
                                      components:
                                          List<dynamic>.from(meal.components),
                                      options: meal.options != null
                                          ? List<dynamic>.from(meal.options!)
                                          : null,
                                      qty: meal.qty,
                                    );
                                    _name.text = mealToEdit.name;
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
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!
                                          .mealNotFound,
                                      textAlign: TextAlign.center,),
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .mealNotFoundDesc,
                                      textAlign: TextAlign.center,),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                              AppLocalizations.of(context)!.ok),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                          indent: 16,
                          endIndent: 16,
                        ),
                      ),
                      TextFormField(
                        controller: _name,
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _title,
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
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField<String>(
                        value: found
                            ? mealToEdit.category
                            : mealsNotifier.categoriesList[0],
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _price,
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        maxLines: 3,
                        controller: _description,
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
                      const SizedBox(
                        height: 5.0,
                      ),
                      Column(
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
                          found
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: mealToEdit.options?.length,
                                  itemBuilder: (context, index) {
                                    options.add(mealToEdit.options?[index]);
                                    return ListTile(
                                      title: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
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
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 5.0,
                          ),
                          ..._optionsControllers.map((controller) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                          labelStyle:
                                              const TextStyle(fontSize: 16),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 16),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .enterOption),
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
                              ),
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
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 40),
                        height: 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.black),
                      ),
                      Column(
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
                          found
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: mealToEdit.components.length,
                                  itemBuilder: (context, index) {
                                    components
                                        .add(mealToEdit.components[index]);
                                    return ListTile(
                                      title: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
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
                                      ),
                                    );
                                  },
                                )
                              : const SizedBox(),
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
                                        hintText: AppLocalizations.of(context)!
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
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        height: 0.5,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.images,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
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
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 80,
                                    mainAxisSpacing: 12.0,
                                    crossAxisSpacing: 12.0,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (context, index) {
                                    imageUrl.add(mealToEdit.imageUrl[index]);
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
                                                color: Colors.grey
                                                    .withOpacity(0.3),
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
                                              child: Image.network(
                                                mealToEdit.imageUrl[index],
                                                scale: 1,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator(
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
                                              )),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.remove_circle),
                                              color: Colors.red,
                                              iconSize: 15,
                                              padding: EdgeInsets.zero,
                                              onPressed: () {
                                                setState(() {
                                                  imageUrl.removeAt(index);
                                                  mealToEdit.imageUrl
                                                      .removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            )
                          : Container(),
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
                              height: 120,
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
                                          width: 30,
                                          height: 30,
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
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: Text(
                                      AppLocalizations.of(context)!
                                          .missingInformation,
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Text(
                                        textAlign: TextAlign.center,
                                        AppLocalizations.of(context)!
                                            .informationFill),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                            AppLocalizations.of(context)!.ok),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
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
                              FireStoreHelper fireStoreHelper =
                                  FireStoreHelper();
                              try {
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
                                // Show success dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text(
                                        AppLocalizations.of(context)!.success,
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                        AppLocalizations.of(context)!
                                            .mealEdited,
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                              AppLocalizations.of(context)!.ok),
                                          onPressed: () {
                                            Navigator.of(dialogContext).pop();

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
                              } catch (e) {
                                // Show error dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext dialogContext) {
                                    return AlertDialog(
                                      title: Text(
                                        AppLocalizations.of(context)!.error,
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                        '${AppLocalizations.of(context)!.mealNotEdited}: $e',
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                            AppLocalizations.of(context)!.ok,
                                            textAlign: TextAlign.center,
                                          ),
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
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
