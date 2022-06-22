import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class OrderAdminDetails extends StatefulWidget {
  final name;
  final userId;
  final phone;
  const OrderAdminDetails({this.name, this.userId, this.phone, Key? key})
      : super(key: key);

  @override
  State<OrderAdminDetails> createState() => _OrderAdminDetailsState();
}

class _OrderAdminDetailsState extends State<OrderAdminDetails> {
  var userAddress;
  var userId;
  bool isDone = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = widget.userId;
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) {
        return;
      } else {
        setState(() {});
      }
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
              future: downloadUrl(imgName),
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

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future<firebase_storage.ListResult> listFiles() async {
    firebase_storage.ListResult result =
        await storage.ref('prescriptions/$userId').listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      print('Found file: $ref');
    });
    return result;
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl =
        await storage.ref('prescriptions/$userId/$imageName').getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: black,
              ),
            )),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.07),
                  child: const Text(
                    'Patient Details:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(size.width * 0.045),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width * 0.04),
                    side: BorderSide(
                      color: Theme.of(context).cardColor,
                      width: 2.0,
                    ),
                  ),
                  color: cardBack,
                  child: Padding(
                    padding: EdgeInsets.all(size.height * 0.01),
                    child: Column(
                      children: [
                        Text(
                          '${widget.name}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.07,
                              color: Theme.of(context).cardColor),
                        ),
                        SizedBox(
                          height: size.height * 0.0065,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.mail,
                              color: black,
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Text("$userAddress"),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.phone,
                              color: black,
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Text("${widget.phone}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.07),
                  child: const Text(
                    'Required Services:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // SizedBox(height: size.height * 0.015,),
                Center(
                  child: Container(
                    width: size.width * 1,
                    height: size.height * 0.3,
                    margin: EdgeInsets.all(size.width * 0.045),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 3.0, color: Theme.of(context).cardColor),
                      borderRadius: BorderRadius.all(
                          Radius.circular(size.width *
                              0.04) //                 <--- border radius here
                          ),
                    ),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('required_service')
                            .doc(widget.userId)
                            .collection('services')
                            .snapshots(),
                        builder:
                            ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: activeBack,
                                color: green,
                              ),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('Nothing to show yet!'),
                            );
                          }
                          final totalDocs = snapshot.data!.docs;
                          userAddress = totalDocs[0]['address'];

                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2.3,
                                      mainAxisSpacing: size.width * 0.01,
                                      crossAxisSpacing: size.width * 0.01),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: totalDocs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding:
                                        EdgeInsets.all(size.height * 0.025),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                width: size.width * 1 / 3,
                                                height: size.height * 0.05,
                                                child: Card(
                                                  color: greenBack,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            size.width * 0.02),
                                                    side: const BorderSide(
                                                      color: greenBack,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  elevation: 2,
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: size.height *
                                                              0.005),
                                                      child: Text(
                                                        '${totalDocs[index]['service']}',
                                                        textAlign:
                                                            TextAlign.center,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Text(
                                            '${totalDocs[index]['price']}',
                                            style:
                                                const TextStyle(color: black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ));
                              });
                        })),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.07),
                  child: const Text(
                    'Prescription:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder(
                  future: listFiles(),
                  builder: (context,
                      AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return ListView.builder(
                          // gridDelegate:
                          //     SliverGridDelegateWithFixedCrossAxisCount(
                          //         crossAxisCount: 1,
                          //         childAspectRatio: 10,
                          //         mainAxisSpacing: size.width * 0.01,
                          //         crossAxisSpacing: size.width * 0.01),
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
                                child: ElevatedButton.icon(
                                    onPressed: () async {
                                      await _displayImg(context,
                                          snapshot.data!.items[index].name);
                                    },
                                    icon: Icon(
                                      Icons.image,
                                      size: size.height * 0.02,
                                      color: Theme.of(context).hintColor,
                                    ),
                                    label: Text(
                                      'Prescription ${index + 1}',
                                      style: TextStyle(
                                          fontSize: size.height * 0.018),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).cardColor,
                                    )));
                          });
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
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.07),
                  child: const Text(
                    'Live Location:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const Text('Location'),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .update({'isDone': true});
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.check,
                        color: green,
                      ),
                      label: const Text(
                        'Mark as done',
                        style: TextStyle(color: black),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: greenBack,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.06))),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.userId)
                            .update({'isDone': false});
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.pending,
                        color: green,
                      ),
                      label: const Text(
                        'Pending',
                        style: TextStyle(color: black),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: greenBack,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.06))),
                    ),
                  ],
                )
              ]),
        ));
  }
}
