import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/sceens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TreatmentCentersScreen extends StatefulWidget {
  @override
  _TreatmentCentersScreenState createState() => _TreatmentCentersScreenState();
}

class _TreatmentCentersScreenState extends State<TreatmentCentersScreen> {
  CollectionReference collectionReference;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collectionReference = FirebaseFirestore.instance.collection('hospitals');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Лечебные центры'),
        ),
        body: collectionReference != null
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: StreamBuilder(
                    stream: collectionReference.snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Column(
                          children: [
                            SizedBox(height: size.height * 0.25),
                            SpinKitWave(
                              color: Colors.brown,
                              size: 80,
                            ),
                          ],
                        );
                      } else {
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              var doc = snapshot.data.docs[index].data();
                              return ListTile(
                                leading: Icon(
                                  Icons.local_hospital,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                title: Text(doc['name']),
                                trailing: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LocationScreen(
                                          hospital: doc['name'],
                                          latitude: doc['latitude'],
                                          longitude: doc['longitude'],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.arrow_forward_ios),
                                ),
                              );
                            });
                      }
                    }))
            : Center(
                child: SpinKitWave(
                  color: Colors.amber,
                  size: 80.0,
                ),
              ));
  }
}
