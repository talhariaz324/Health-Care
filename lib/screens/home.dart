import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/routes/routes.dart';

import '../components/input_container.dart';
class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKeys = GlobalKey<FormState>();
  bool isChecked = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String userId = FirebaseAuth.instance.currentUser!.uid;
  void _submit() async {
    if (_formKeys.currentState!.validate()) {
      _formKeys.currentState!.save();
    await  FirebaseFirestore.instance.collection('required_service').doc(userId).set({
        'name': nameController.text,
        'address': addressController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request Posted Successfully!',style: TextStyle(color: Theme.of(context).hintColor),),backgroundColor: Theme.of(context).primaryColor,),);
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(backgroundColor: Theme.of(context).backgroundColor,actions: [IconButton(color: green,onPressed: (){
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed(MyRoutes.authScreenRoute);
    
      }, icon: const Icon(Icons.logout))],
      title: 
        ListTile(leading: Image.asset('assets/images/logo.png'), title: const Text('Health Care'),),
      ),
      body: 
           Stack(
                   children: [
                     
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
                  Color.fromRGBO(175, 203, 219,1),
                  Color.fromRGBO(149, 171, 229,1),
                ],
              ),
                ),
              )
                     ),
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
                  Color.fromRGBO(140, 204, 132,1),
                  Color.fromRGBO(171, 210, 200,1),
                ],
              ),
                ),
              )
                     ),
            Form(
              key: _formKeys,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.04,),
                       InputContainer(
                     child:  TextFormField(
                          key: const ValueKey('Name'),
                          autocorrect: false,
                          controller: nameController,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          validator:  (value) {
                            if (value!.isEmpty || value.length < 3) {
                              return 'Please enter a valid name.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          decoration:  InputDecoration(
                            icon: Icon(Icons.person, color: Theme.of(context).primaryColor),
                            hintText: 'Name',
                       border: InputBorder.none
                          ),
                          // onSaved: (value) {
                          //   _username = value!;
                          // },
                          
                        ) ,
                      
                      ),
                      SizedBox(height: size.height * 0.01,),
                       InputContainer(
                     child:  TextFormField(
                          key: const ValueKey('Address'),
                          autocorrect: false,
                          controller: addressController,
                          textCapitalization: TextCapitalization.none,
                          enableSuggestions: false,
                          validator:  (value) {
                            if (value!.isEmpty || value.length < 3) {
                              return 'Please enter a valid address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.streetAddress,
                          decoration:  InputDecoration(
                            icon: Icon(Icons.house, color: Theme.of(context).primaryColor),
                            hintText: 'Address',
                       border: InputBorder.none
                          ),
                          // onSaved: (value) {
                          //   _username = value!;
                          // },
                          
                        ) ,
                      
                      ),
                      SizedBox(height: size.height * 0.02,),
                      SizedBox(width: size.width * 0.8,child: const Text('Which of the following services do you want to avail ?',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                    
                          Padding(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                          child: StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection('new_services').snapshots(),
                                    builder: ( (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                       if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                     else  if (snapshot.data!.docs.isEmpty ) {
                                  return const Center(
                                    child: Text('0 Offer Available now!'),
                                  );
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
                                
                                      onTap: (){
                                         
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                        height: size.height * 0.04,
                                        width: size.width * 1/3,
                                        decoration: BoxDecoration(
                                          color: isChecked ? activeBack : greenBack,
                                          
                                          border:  Border.all(color: greenBack),
                                          boxShadow:  const  [
                          BoxShadow(
                            color: greenBack,
                            offset: Offset(0, 3),
                            blurRadius: 10,
                            spreadRadius: -5,
                          ),
                                          ],
                                          borderRadius: BorderRadius.circular(size.width * 0.04)
                                          ),
                                        child: Padding(
                                          padding:  EdgeInsets.all(size.width * 0.01),
                                          child:  Text('${totalDocs[index]['name']}',textAlign: TextAlign.center,style: const TextStyle(  color: black),)),
                                        ),
                                        SizedBox(height: size.height * 0.01,),
                                         Text('${totalDocs[index]['price']}', style: const TextStyle(color: black),)
                                        
                                        ],
                                      )
                                        );

                        
                            }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 2.3,mainAxisSpacing: size.width * 0.01,crossAxisSpacing: size.width * 0.01),
                            );
                          
                          })),
                            
                        ),
                                            SizedBox(height: size.height * 0.02,),
                                           SizedBox(width: size.width * 0.8,child: const Text('Do you have any old prescription ?',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                                            SizedBox(height: size.height * 0.02,),
                                            Padding(
                          padding:  EdgeInsets.only(left:size.width * 0.15),
                          child: Align(alignment: Alignment.topLeft,child: SizedBox(height: size.height * 0.04, width:  size.width * 0.4,child: ElevatedButton.icon(onPressed: (){}, icon:  Icon(Icons.attach_file,size: size.height * 0.02,), label:  Text('upload Image',style: TextStyle(fontSize: size.height  * 0.018),),style: ElevatedButton.styleFrom(primary: activeBack,)))),
                                            ),
                                            SizedBox(height: size.height * 0.02,),
                                           Padding(
                                             padding:  EdgeInsets.only(right:size.width * 0.28 ),
                                             child: SizedBox(width: size.width * 0.8,child: const Text('Share live location ?',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                                           ),
                                            SizedBox(height: size.height * 0.02,),
                                            Padding(
                          padding:  EdgeInsets.only(left:size.width * 0.15),
                          child: Align(alignment: Alignment.topLeft,child: SizedBox(height: size.height * 0.04, width:  size.width * 0.45,child: ElevatedButton.icon(onPressed: (){}, icon:  Icon(Icons.location_on,size: size.height * 0.02,), label:  Text('Share Location',style: TextStyle(fontSize: size.height  * 0.018),),style: ElevatedButton.styleFrom(primary: activeBack,)))),
                                            ),
                                            SizedBox(height: size.height * 0.05,),
                                            ElevatedButton.icon(onPressed: (){
                                              _submit();
                                            }, icon:  Icon(Icons.mail,size: size.height * 0.028,), label:  Text('Submit',style: TextStyle(fontSize: size.height  * 0.018),),style: ElevatedButton.styleFrom(primary: activeBack,),),
                        ]
                  ),
                ),
              ),
            )
                   ]
                   ),
    
    );
  }
}

// Start working on home screen backend like selecting (In selecting first store from admin and then fetch here)etc and submit button 