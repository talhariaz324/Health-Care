import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';

import 'package:health_care/routes/routes.dart';
import 'package:health_care/screens/components/storage_service_file.dart';

import '../components/input_container.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKeys = GlobalKey<FormState>();
  int counter = 0;
  bool checkerUploader = false;
  final Storage storage = Storage();

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {});
    });
  }

  Future<void> _displayImg(BuildContext context, String imgName) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Prescription:'),
            content: FutureBuilder(
              future: storage.downloadUrl(imgName),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return SizedBox(
                    width: 300,
                    height: 250,
                    child: Image.network(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator(
                    backgroundColor: green,
                  ));
                }
                return Container();
              },
            ),
          );
        });
  }

  void _submit() async {
    if (_formKeys.currentState!.validate()) {
      _formKeys.currentState!.save();
      counter = 0;
      await FirebaseFirestore.instance
          .collection('new_services')
          .where('isSelected', isEqualTo: true)
          .get()
          .then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance
              .collection('required_service')
              .doc(userId)
              .collection('services')
              .doc()
              .set({
            'phone': phoneController.text,
            'address': addressController.text,
            'service': element.data()['name'],
            'price': element.data()['price'],
            'isSelected': element.data()['isSelected'],
          });
        }
      });
      phoneController.text = '';
      addressController.text = '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            'Request Posted Successfully!',
            style: TextStyle(color: Theme.of(context).hintColor),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
    }
    await FirebaseFirestore.instance
        .collection('new_services')
        .where('isSelected', isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance
            .collection('new_services')
            .doc(element.id)
            .update({'isSelected': false});
      }
    });
    await FirebaseAuth.instance.currentUser!.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          'Thanks for using our app. Our agent will contact you soon!',
          style: TextStyle(color: Theme.of(context).hintColor),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
    Navigator.of(context).pushReplacementNamed(MyRoutes.authScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // final imgProvider = Provider.of<ImgProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          IconButton(
              color: green,
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('new_services')
                    .where('isSelected', isEqualTo: true)
                    .get()
                    .then((value) {
                  for (var element in value.docs) {
                    FirebaseFirestore.instance
                        .collection('new_services')
                        .doc(element.id)
                        .update({'isSelected': false});
                  }
                });
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushReplacementNamed(MyRoutes.authScreenRoute);
              },
              icon: const Icon(Icons.logout))
        ],
        title: ListTile(
          leading: Image.asset('assets/images/logo.png'),
          title: const Text('Health Care'),
        ),
      ),
      body: Stack(children: [
        // Lets add some decorations
        Positioned(
            top: size.height * 0.5,
            right: size.width * 0.8,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(175, 203, 219, 1),
                    Color.fromRGBO(149, 171, 229, 1),
                  ],
                ),
              ),
            )),
        Positioned(
            top: size.height * 0.65,
            left: size.width * 0.65,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(140, 204, 132, 1),
                    Color.fromRGBO(171, 210, 200, 1),
                  ],
                ),
              ),
            )),
        Form(
          key: _formKeys,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    InputContainer(
                      child: TextFormField(
                        key: const ValueKey('Phone'),
                        autocorrect: false,
                        controller: phoneController,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 11) {
                            return 'Please enter a valid Number.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(Icons.person,
                                color: Theme.of(context).primaryColor),
                            hintText: 'Phone',
                            border: InputBorder.none),
                        // onSaved: (value) {
                        //   _username = value!;
                        // },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    InputContainer(
                      child: TextFormField(
                        key: const ValueKey('Address'),
                        autocorrect: false,
                        controller: addressController,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 3) {
                            return 'Please enter a valid address.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.streetAddress,
                        decoration: InputDecoration(
                            icon: Icon(Icons.house,
                                color: Theme.of(context).primaryColor),
                            hintText: 'Address',
                            border: InputBorder.none),
                        // onSaved: (value) {
                        //   _username = value!;
                        // },
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                        width: size.width * 0.8,
                        child: const Text(
                          'Which of the following services do you want to avail ?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.02),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('new_services')
                              .snapshots(),
                          builder: ((context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.data!.docs.isEmpty) {
                              return SizedBox(
                                  height: size.height * 0.2,
                                  width: size.width * 1,
                                  child: const Center(
                                      child: Text('0 Offer Available now!')));
                            }
                            final totalDocs = snapshot.data!.docs;
                            return GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: totalDocs.length,
                              itemBuilder: (context, index) {
                                return
                                    // Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    //   children: [
                                    //     SizedBox(height: size.height * 0.08,),

                                    GestureDetector(
                                        onDoubleTap: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('new_services')
                                                .doc(totalDocs[index].id)
                                                .update({'isSelected': false});
                                          });
                                          counter--;
                                        },
                                        onTap: () {
                                          setState(() {
                                            FirebaseFirestore.instance
                                                .collection('new_services')
                                                .doc(totalDocs[index].id)
                                                .update({'isSelected': true});
                                          });
                                          counter++;
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              height: size.height * 0.04,
                                              width: size.width * 1 / 3,
                                              decoration: BoxDecoration(
                                                  color: totalDocs[index]
                                                              ['isSelected'] ==
                                                          true
                                                      ? activeBack
                                                      : greenBack,
                                                  border: Border.all(
                                                      color: greenBack),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: greenBack,
                                                      offset: Offset(0, 3),
                                                      blurRadius: 10,
                                                      spreadRadius: -5,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.width * 0.04)),
                                              child: Padding(
                                                  padding: EdgeInsets.all(
                                                      size.width * 0.01),
                                                  child: Text(
                                                    '${totalDocs[index]['name']}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: totalDocs[index][
                                                                    'isSelected'] ==
                                                                true
                                                            ? Theme.of(context)
                                                                .hintColor
                                                            : black),
                                                  )),
                                            ),
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                                            Text(
                                              'RS: ${totalDocs[index]['price']}',
                                              style:
                                                  const TextStyle(color: black),
                                            )
                                          ],
                                        ));
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2.3,
                                      mainAxisSpacing: size.width * 0.01,
                                      crossAxisSpacing: size.width * 0.01),
                            );
                          })),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                        width: size.width * 0.69,
                        child: const Text(
                          'Do you have any prescription ?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: size.width * 0.15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                  height: size.height * 0.04,
                                  width: size.width * 0.4,
                                  child: ElevatedButton.icon(
                                      onPressed: () async {
                                        checkerUploader = true;
                                        // Future.delayed(Duration(seconds: 120),
                                        //     () async {
                                        //   await FirebaseFirestore.instance
                                        //       .collection('new_services')
                                        //       .where('isSelected',
                                        //           isEqualTo: true)
                                        //       .get()
                                        //       .then((value) {
                                        //     for (var element in value.docs) {
                                        //       FirebaseFirestore.instance
                                        //           .collection('new_services')
                                        //           .doc(element.id)
                                        //           .update(
                                        //               {'isSelected': false});
                                        //     }
                                        //     ScaffoldMessenger.of(context)
                                        //         .showSnackBar(SnackBar(
                                        //       duration:
                                        //           const Duration(seconds: 3),
                                        //       content: const Text(
                                        //           'Please Select Service again'),
                                        //       backgroundColor:
                                        //           Theme.of(context).cardColor,
                                        //     ));
                                        //   });
                                        // });
                                        final results =
                                            await FilePicker.platform.pickFiles(
                                          allowMultiple: true,
                                          type: FileType.custom,
                                          allowedExtensions: [
                                            'png',
                                            'jpg',
                                            'jpeg'
                                          ],
                                        );

                                        if (results == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content:
                                                const Text('No file Selected'),
                                            backgroundColor:
                                                Theme.of(context).cardColor,
                                          ));
                                          return;
                                        } else if (results.count > 2) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                'Maximum 2 Files are allowed. Please select again!'),
                                            backgroundColor:
                                                Theme.of(context).errorColor,
                                          ));
                                          return;
                                        } else if (results.count >= 1) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration:
                                                const Duration(seconds: 5),
                                            content: const Text(
                                                'Loading! Please Wait...'),
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                          ));
                                        }
                                        // Manage 2 files here
                                        final pathFirst =
                                            results.files.first.path;
                                        final pathSecond =
                                            results.files.last.path;
                                        final fileName1 =
                                            results.files.first.name;
                                        final fileName2 =
                                            results.files.last.name;

                                        await storage
                                            .uploadFile(pathFirst, pathSecond,
                                                fileName1, fileName2)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      },
                                      icon: Icon(
                                        Icons.attach_file,
                                        size: size.height * 0.02,
                                      ),
                                      label: Text(
                                        'upload Image',
                                        style: TextStyle(
                                            fontSize: size.height * 0.018),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: activeBack,
                                      )))),
                        ),
                      ],
                    ),
                    checkerUploader == true
                        ? FutureBuilder(
                            future: storage.listFiles(),
                            builder: (context,
                                AsyncSnapshot<firebase_storage.ListResult>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return ListView.builder(
                                    // gridDelegate:
                                    //     SliverGridDelegateWithFixedCrossAxisCount(
                                    //         crossAxisCount: 1,
                                    //         childAspectRatio: 2,
                                    //         mainAxisSpacing: size.width * 0.01,
                                    //         crossAxisSpacing:
                                    //             size.width * 0.01),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.items.length,
                                    itemBuilder: (context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.2,
                                          right: size.width * 0.2,
                                          top: size.width * 0.02,
                                          bottom: size.width * 0.01,
                                        ),
                                        child: Dismissible(
                                            key: Key(snapshot
                                                .data!.items[index].name),
                                            direction:
                                                DismissDirection.endToStart,
                                            onDismissed: (direction) async {
                                              final url = await snapshot
                                                  .data!.items[index]
                                                  .getDownloadURL();
                                              await firebase_storage
                                                  .FirebaseStorage.instance
                                                  .refFromURL(url)
                                                  .delete();
                                            },
                                            confirmDismiss: (direction) {
                                              return showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .errorColor,
                                                  title: Text(
                                                    'Are You Sure?',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .hintColor),
                                                  ),
                                                  content: Text(
                                                    'Do you want to remove this student from the list?',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .hintColor),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(ctx)
                                                            .pop(true);
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'No',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(ctx)
                                                            .pop(false);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            child: ElevatedButton.icon(
                                                onPressed: () async {
                                                  await _displayImg(
                                                      context,
                                                      snapshot.data!
                                                          .items[index].name);
                                                },
                                                icon: Icon(
                                                  Icons.image,
                                                  size: size.height * 0.02,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                                label: Text(
                                                  'Prescription ${index + 1}',
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.018),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context)
                                                      .cardColor,
                                                ))),
                                      );
                                    });
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting &&
                                  !snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor: green,
                                ));
                              }

                              return Container();
                            },
                          )
                        : const SizedBox(
                            height: 10,
                            width: 0,
                          ),
                    Padding(
                      padding: EdgeInsets.only(right: size.width * 0.28),
                      child: SizedBox(
                          width: size.width * 0.8,
                          child: const Text(
                            'Share live location ?',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.15),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                              height: size.height * 0.04,
                              width: size.width * 0.45,
                              child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.location_on,
                                    size: size.height * 0.02,
                                  ),
                                  label: Text(
                                    'Share Location',
                                    style: TextStyle(
                                        fontSize: size.height * 0.018),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: activeBack,
                                  )))),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (counter == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please Select atleast 1 service!',
                                style: TextStyle(
                                    color: Theme.of(context).hintColor),
                              ),
                              backgroundColor: Theme.of(context).errorColor,
                            ),
                          );
                          return;
                        }
                        _submit();
                      },
                      icon: Icon(
                        Icons.mail,
                        size: size.height * 0.028,
                      ),
                      label: Text(
                        'Submit',
                        style: TextStyle(fontSize: size.height * 0.018),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: activeBack,
                      ),
                    ),
                  ]),
            ),
          ),
        )
      ]),
    );
  }
}

// We can make space as before by using variable bool which get true onpress of upload btn and if true then allow space else defualt