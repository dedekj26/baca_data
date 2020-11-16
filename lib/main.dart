import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Mhs>> fetchMhss(http.Client client) async {
  final response =
      await client.get('https://startmyflutter.000webhostapp.com/readDatajson.php');

  // Use the compute function to run parseMhss in a separate isolate.
  return compute(parseMhss, response.body);
}

// Delete
Future<void> deleteEmployee(String nim) async {
final url = 'https://startmyflutter.000webhostapp.com/deleteDatajson.php';
await http.get(url + '?nim=$nim');
}

// A function that converts a response body into a List<Mhs>.
List<Mhs> parseMhss(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Mhs>((json) => Mhs.fromJson(json)).toList();
}

class Mhs {
  final String nim;
  final String nama;
  final String kelas;
  final String kdmatkul;
  final String email;

  Mhs({this.nim, this.nama, this.kelas, this.kdmatkul, this.email});

  factory Mhs.fromJson(Map<String, dynamic> json) {
    return Mhs(
      nim: json['nim'] as String,
      nama: json['nama'] as String,
      kelas: json['kelas'] as String,
      kdmatkul: json['kdmatkul'] as String,
      email: json['email'] as String,
    );
  }
}

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => MyApp(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Mahasiswa';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Mhs>>(
        future: fetchMhss(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MhssList(MhsData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MhssList extends StatelessWidget {
  final List<Mhs> MhsData;

  MhssList({Key key, this.MhsData}) : super(key: key);

Widget viewData(var data,int index,BuildContext context)
{
return Container(
    width: 200,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.green,
      elevation: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            //ClipRRect(
              //      borderRadius: BorderRadius.only(
                //      topLeft: Radius.circular(8.0),
                  //    topRight: Radius.circular(8.0),
                   // ),
                   // child: Image.network(
                    //    "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png"
                    //    width: 100,
                     //   height: 50,
                        //fit:BoxFit.fill

                   // ),
                 // ),
            
          ListTile(
           //leading: Image.network(
             //   "https://elearning.binadarma.ac.id/pluginfile.php/1/theme_lambda/logo/1602057627/ubd_logo.png",
             // ),
            title: Text(data[index].nim, style: TextStyle(color: Colors.white)),
            subtitle: Text(data[index].nama, style: TextStyle(color: Colors.white)),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InputData(
                          data[index].nim,
                          data[index].nama,
                          data[index].kelas,
                          data[index].kdmatkul,
                          data[index].email
                      )));
                  },
                ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    deleteEmployee(data[index].nim);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: MhsData.length,
      itemBuilder: (context, index) {
        return viewData(MhsData,index,context);
      },
    );
  }
}

class InputData extends StatefulWidget {
    final String nim;
    final String nama;
    final String kelas;
    final String kdmatkul;
    final String email;

    InputData(this.nim, this.nama, this.kelas, this.kdmatkul, this.email);

    @override
    _MyAppState createState() => _MyAppState(nim, nama, kelas, kdmatkul, email);
}

class _MyAppState extends State<InputData> {
  final String nim;
  final String nama;
  final String kelas;
  final String kdmatkul;
  final String email;

  TextEditingController namaController = TextEditingController();
  TextEditingController kelasController = TextEditingController();
  TextEditingController kdmatkulController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  
  _MyAppState(this.nim, this.nama, this.kelas, this.kdmatkul, this.email);

  Widget _inputFullName() {
    namaController.text = nama;
    return Container(
        margin: EdgeInsets.all(20),
        child: 
        TextField(
          controller: namaController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Nama Mahasiswa",
          ),
        ));
  }

  Widget _inputkelas() {
    kelasController.text = kelas;
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: kelasController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Kelas",
          ),
        ));
  }

  Widget _inputkdmatkul() {
    kdmatkulController.text = kdmatkul;
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: kdmatkulController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Kode Mata Kuliah",
          ),
        ));
  }

  Widget _inputemail() {
    emailController.text = email;
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('Edit Data Mahasiswa'),
          ),
          body: Center(
              child: Column(children: <Widget>[
                _inputFullName(),
                _inputkelas(),
                _inputkdmatkul(),
                _inputemail(),
            Container(
              margin: EdgeInsets.all(20),
              child: RaisedButton(
                child: Text(
                    "Submit".toUpperCase(),
                    style: TextStyle(
                    color: Colors.white,
                    ),
                ),
                color: Colors.yellow[700],
                onPressed: () {
                    
                },
            )),
          ])),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Close', // used by assistive technologies
            child: Icon(Icons.close),
            onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
            },
          )),
    );
  }
}
