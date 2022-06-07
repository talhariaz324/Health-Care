import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/provider/new_services.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final newService = Provider.of<NewServices>(context);
      TextEditingController _serviceNameController = TextEditingController();
      TextEditingController _servicePriceController = TextEditingController();
      bool isPending = false;
      bool isTaskDone = false;
      bool isServices = true;
      Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog( 
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.1)),
        title: const Text('Enter Your New Service!'), 
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField( 
        
            controller: _serviceNameController,
            decoration: const InputDecoration(hintText: "Name of service",hintStyle: TextStyle(color: black)), 
          ),
          SizedBox(height: size.height * 0.05,),
              TextField( 
            controller: _servicePriceController,
            decoration: const InputDecoration(hintText: "Price of service",hintStyle: TextStyle(color: black)), 
          ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Theme.of(context).cardColor),
              child:  Text('ADD',style: TextStyle(color: Theme.of(context).hintColor),),
              onPressed: () {
                if (_serviceNameController.text.isEmpty || _servicePriceController.text.isEmpty) {
                  Navigator.of(context).pop();
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not Added, Because you write nothing!',style: TextStyle(color: Theme.of(context).hintColor),),backgroundColor: Theme.of(context).errorColor,),);
                }
                newService.addNewService(
                 _serviceNameController.text,
                _servicePriceController.text,
                );
                  Navigator.of(context).pop();
                
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added Successfully!',style: TextStyle(color: Theme.of(context).hintColor),),backgroundColor: Theme.of(context).primaryColor,),);
                _serviceNameController.clear();
                _servicePriceController.clear();
              },
            ),
          ),
        ],
        );
        
      });
}
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
      onPressed: () {
       _displayTextInputDialog(context);
      }, icon: const Icon(Icons.add,color: black,)),
      title: 
        ListTile(leading: Image.asset('assets/images/logo.png'), title: const Text('Health Care'),),
      
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
          color: greenBack,
          height: size.height * 0.06,
          width: size.width * 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
               Text('Dashboard',style: TextStyle(color: green, fontWeight: FontWeight.bold,fontSize: size.height * 0.045),),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.01,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: (){},
              child: Container(
                height: size.height * 0.07,
                // width: size.width * 0.34,
                decoration: BoxDecoration(
                  color: activeBack,
                  border:  Border.all(color: activeBack),
                  
                  borderRadius: BorderRadius.circular(size.width * 0.04)
                  ),
                child: Padding(
                  padding:  EdgeInsets.all(size.width * 0.01),
                  child: Row(children: [const Icon(Icons.medical_services_outlined,color: green,), SizedBox(width: size.width * 0.01,),  Text('Services',style: TextStyle(color: Theme.of(context).hintColor),)],),
                ),
                ),
            ),
            GestureDetector(
              onTap: (){
              },
              child: Container(
                height: size.height * 0.07,
                // width: size.width * 0.34,
                decoration: BoxDecoration(
                  color: greenBack,
                  border:  Border.all(color: greenBack),
                  
                  borderRadius: BorderRadius.circular(size.width * 0.04)
                  ),
                child: Padding(
                  padding:  EdgeInsets.all(size.width * 0.01),
                  child: Row(children: [const Icon(Icons.list,color: green,), SizedBox(width: size.width * 0.01,), const Text('Pending')],),
                ),
                ),
            ),
            GestureDetector(
              onTap: (){
              },
              child: Container(
                height: size.height * 0.07,
                // width: size.width * 0.34,
                decoration: BoxDecoration(
                  color: greenBack,
                  border:  Border.all(color: greenBack),
                  
                  borderRadius: BorderRadius.circular(size.width * 0.04)
                  ),
                child: Padding(
                  padding:  EdgeInsets.all(size.width * 0.01),
                  child: Row(children: [const Icon(Icons.check,color: green,), SizedBox(width: size.width * 0.01,), const Text('Tasks Done')],),
                ),
                ),
            ),
          ],
        ),
          SizedBox(height: size.height * 0.025,),
    
          const Text('Services which you are offering are: ',style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
          SizedBox(height: size.height * 0.02,),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('new_services').snapshots(),
            builder: ( (context, AsyncSnapshot<QuerySnapshot> snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
             else  if (snapshot.data!.docs.isEmpty ) {
          return const Center(
            child: Text('You are not offering any service yet!'),
          );
        }
        final totalDocs = snapshot.data!.docs;
              return ListView.builder(
                scrollDirection: Axis.vertical,
    shrinkWrap: true,
            itemCount: totalDocs.length,
            itemBuilder: (context, index) {
            return  isServices == true ? Dismissible(
                                key: Key(totalDocs[index].id),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                 newService.deleteService(totalDocs[index].id);
                                },
                                confirmDismiss: (direction) {
                                  return showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).errorColor,
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
                                                color: Theme.of(context)
                                                    .hintColor),
                                          ),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(true);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .hintColor),
                                          ),
                                          onPressed: () {
                                            Navigator.of(ctx).pop(false);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                },
              child: GestureDetector(
                              
                                    onTap: (){
                                    
                                    },
                                    child: Padding(
                                      padding:  EdgeInsets.all(size.height * 0.02),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                        height: size.height * 0.04,
                                        width: size.width * 1/3,
                                        decoration: BoxDecoration(
                                          color:  greenBack,
                                          
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
                                          child:  Text('${totalDocs[index]['name']}',textAlign: TextAlign.center,style: const TextStyle(  color:   black),)),
                                        ),
                                        SizedBox(height: size.height * 0.01,),
                                         Text('${totalDocs[index]['price']}', style: const TextStyle(color: black),)
                                        
                                        ],
                                      ),
                                    )
                                      ),
            ) : 
              GestureDetector(
              onTap: (){},
              child: Card(
              margin: EdgeInsets.all(size.width * 0.07),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.04),
              side:  BorderSide(
                color: Theme.of(context).cardColor,
                width: 2.0,
              ),),
              color: cardBack,
              
                child: Padding(
                  padding:  EdgeInsets.all(size.height * 0.01),
                  child: Column(
                    children: [
                        Text('Umer',style: TextStyle(fontWeight: FontWeight.bold,fontSize: size.width * 0.07,color: Theme.of(context).cardColor),),
                      Row(children:  [const Icon(Icons.phone,color: black,), SizedBox(width: size.width * 0.03,),const Text('03001234567')],),
                      SizedBox(height: size.height * 0.0065,),
                      Row(children:  [const Icon(Icons.location_on,color: black,), SizedBox(width: size.width * 0.03,),const Text('03001234567')],),
                      
                    ],
                  ),
                ),
              ),
            );
          });
          }))
        
          ],
        ),
      )
    );
  }
} 