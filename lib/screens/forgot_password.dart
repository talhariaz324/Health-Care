import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/input_container.dart';
class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({ Key? key }) : super(key: key);

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
    final _formKeys = GlobalKey<FormState>();
     TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
 String email = '';
   getEmail() async {
    _formKeys.currentState!.validate();

      _formKeys.currentState!.save();
      int counter = 0;
    //  final user = FirebaseAuth.instance.currentUser;
     final userData = await FirebaseFirestore.instance
        .collection('users')
        .get();
        for (var i = 0; i < userData.docs.length; i++) {
          counter++;
          if (userData.docs[i].data()['email'] == email) {
            FirebaseAuth.instance.sendPasswordResetEmail(email: email);
            Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: const Text('Check your mail'),backgroundColor: Theme.of(context).colorScheme.secondary,));
          }

          }
          if(counter == userData.docs.length ){

          return true;
          }else {
            return false;
          }
   }
   
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      backgroundColor: Theme.of(context).backgroundColor,
      body: 
           
           SingleChildScrollView(
               child: Column(
                //  mainAxisAlignment: MainAxisAlignment.center,
                    
                 children: [  
                    Image.asset('assets/images/logo.png',height: size.height * 0.4,width:  size.width * 1,
                     ),
                
                  Text('Forgot Password',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary),),
                                SizedBox(height: size.height  * 0.045,),
                   Center(
                 child:     
                   
                       Form(
                        key:_formKeys ,
                  child:  
                  InputContainer(
                    child: 
                    TextFormField(
                              key: const ValueKey('emails'),
                              autocorrect: false,
                              controller: emailController,
                              textCapitalization: TextCapitalization.none,
                              
                              enableSuggestions: false,
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              } , 
                              keyboardType: TextInputType.emailAddress,
                              decoration:  InputDecoration(
                                icon: Icon(Icons.mail, color: Theme.of(context).cardColor),
                                // hintText: 'Email',
                                hintText:  'Enter registerd email',
                           border: InputBorder.none
                              ),
                              
                            ),
                  ) ,
                   
                   ),
                      
                       ),
                       SizedBox(height: size.height * 0.04,),
                                            ElevatedButton(onPressed: ()async{
                    email = emailController.text;
                     bool result =  await getEmail();
                     result == true ? ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: const Text('Sorry! Not Email Found'),backgroundColor: Theme.of(context).errorColor,))  : null;
                       }, child: const Text('Send Mail'),style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.secondary,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.1)), minimumSize: Size(size.width * 1/3, size.height * 0.05)),),
           
                     SizedBox(
                       height: size.height  * 0.3,
                       width: double.infinity,
                       child: Stack(
                   children: [
                     
                     // Lets add some decorations
                     Positioned(
              top: 0,
              right: 280,
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
              top: 40,   
              left: 250,
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
           
                   ]
                   ),
                     ),
                   ]  )),
           );
  }
}

