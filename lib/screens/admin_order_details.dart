import 'package:flutter/material.dart';
import 'package:health_care/constants.dart';

class OrderAdminDetails extends StatelessWidget {
  const OrderAdminDetails({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        leading: const Icon(Icons.arrow_back_ios,color: black,),
      ),
      body: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding:  EdgeInsets.only(left:size.width * 0.07),
          child: const Text('Patient Details:',style: TextStyle(fontWeight: FontWeight.bold),),
        ),
         Card(
              margin: EdgeInsets.all(size.width * 0.045),
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
              SizedBox(height: size.height * 0.025,),
              Padding(
          padding:  EdgeInsets.only(left:size.width * 0.07),
          child: const Text('Required Services:',style: TextStyle(fontWeight: FontWeight.bold),),
        ),
              // SizedBox(height: size.height * 0.015,),
        Center(
          child: Container(
            width: size.width * 1,
            height: size.height * 0.3,
           margin: EdgeInsets.all(size.width * 0.045),
            decoration: BoxDecoration(
            border: Border.all(
             width: 3.0,
             color: Theme.of(context).cardColor
    ),
           borderRadius: BorderRadius.all(
          Radius.circular(size.width * 0.04) //                 <--- border radius here
    ),
            ),
            child: Padding(
              padding:  EdgeInsets.all(size.height * 0.025),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  SizedBox(
                    width: size.width * 1/3,
                    height: size.height * 0.05,
                    child: Card(color: greenBack,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.02),
                    
                    side:  const BorderSide(
                      color: greenBack,
                      width: 2.0,
                    ),
                    ),
                    elevation: 2,
                    child: Padding(padding: EdgeInsets.only(top: size.height * 0.005),child: const Text('NG',textAlign: TextAlign.center,)),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 1/3,
                    height: size.height * 0.05,
                    child: Card(color: greenBack,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.02),
                    
                    side:  const BorderSide(
                      color: greenBack,
                      width: 2.0,
                    ),
                    ),
                    elevation: 2,
                    child: Padding(padding: EdgeInsets.only(top: size.height * 0.005),child: const Text('NG',textAlign: TextAlign.center,)),
                    ),
                  ),
                  ],
                  ),
                  SizedBox(height: size.height * 0.04,),
                    Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  SizedBox(
                    width: size.width * 1/3,
                    height: size.height * 0.05,
                    child: Card(color: greenBack,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.02),
                    
                    side:  const BorderSide(
                      color: greenBack,
                      width: 2.0,
                    ),
                    ),
                    elevation: 2,
                    child: Padding(padding: EdgeInsets.only(top: size.height * 0.005),child: const Text('NG',textAlign: TextAlign.center,)),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 1/3,
                    height: size.height * 0.05,
                    child: Card(color: greenBack,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.02),
                    
                    side:  const BorderSide(
                      color: greenBack,
                      width: 2.0,
                    ),
                    ),
                    elevation: 2,
                    child: Padding(padding: EdgeInsets.only(top: size.height * 0.005),child: const Text('NG',textAlign: TextAlign.center,)),
                    ),
                  ),
                  ],
                  ),
                  ],
                ),
              )
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(left:size.width * 0.07),
          child: const Text('Prescription:',style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        const Text('Image'),
        Padding(
          padding:  EdgeInsets.only(left:size.width * 0.07),
          child: const Text('Live Location:',style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        const Text('Location'),
        SizedBox(height: size.height * 0.01,),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
          ElevatedButton.icon(onPressed: (){}, icon: Icon(Icons.check,color: green,), label: const Text('Mark as done',style: TextStyle(color: black),),style: ElevatedButton.styleFrom(primary: greenBack,elevation: 4,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.06))),),
          ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.pending,color: green,), label: const Text('Pending',style: TextStyle(color: black),),style: ElevatedButton.styleFrom(primary: greenBack,elevation: 4,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.width * 0.06))),),
        ],)
        ],
      )),
    );
  }
}