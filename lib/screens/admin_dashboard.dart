import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';
import 'package:health_care/provider/new_services.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final newService = Provider.of<NewServices>(context, listen: false);
      TextEditingController _serviceNameController = TextEditingController();
      TextEditingController _servicePriceController = TextEditingController();
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
                width: size.width * 1/3,
                decoration: BoxDecoration(
                  color: activeBack,
                  border:  Border.all(color: activeBack),
                  
                  borderRadius: BorderRadius.circular(size.width * 0.04)
                  ),
                child: Padding(
                  padding:  EdgeInsets.all(size.width * 0.01),
                  child: Row(children: [const Icon(Icons.check,color: green,), SizedBox(width: size.width * 0.01,),  Text('Tasks Done',style: TextStyle(color: Theme.of(context).hintColor),)],),
                ),
                ),
            ),
            GestureDetector(
              onTap: (){
              },
              child: Container(
                height: size.height * 0.07,
                width: size.width * 1/3,
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
          ],
        ),
          SizedBox(height: size.height * 0.025,),
          
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
            ),
        
          ],
        ),
      )
    );
  }
} 