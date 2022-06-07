import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:health_care/models/new_service.dart';



class NewServices with ChangeNotifier {
 
  
  final List<NewService> _newServices = [];

  List<NewService> get newServices {
    return [..._newServices];
  }
void addNewService(
    String name,
    String price,

  ) async {

    try {
      
  
        await FirebaseFirestore.instance
            .collection('new_services')
            .add({
          'name': name,
          'price': price,
            });
    
    
    } on PlatformException catch (err) {
      print(err);
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

     
     
    } catch (err) {
      print(err);
         }
  }


void deleteService (String id) async{
  try {
    await FirebaseFirestore.instance
            .collection('new_services')
            .doc(id).delete();

    
  } on PlatformException catch (err) {
      print(err);
      var message = 'An error occurred, pelase check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

     
     
    } catch (err) {
      print(err);
         }

}
  
}