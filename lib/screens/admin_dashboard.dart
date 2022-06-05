import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios,color: black,)),
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