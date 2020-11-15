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
    title: 'Home Data Mahasiswa',
    initialRoute: '/',
    routes: {
      '/': (context) => MyHomePage(),
      '/second': (context) => InputData(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Mahasiswa UBD';

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



Widget viewData(var data,int index)
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
                      Navigator.pushNamed(context, '/second');
                  },
                ),
                FlatButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {},
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
        return viewData(MhsData,index);
      },
    );
  }
}

class InputData extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<InputData> {
  TextEditingController nameController = TextEditingController();
  TextEditingController kelasController = TextEditingController();
  TextEditingController kdmatkulController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String fullName = '';
  String kelas = '';
  String kdmatkul = '';
  String email = '';

  Widget _inputFullName() {
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: nameController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Nama Mahasiswa",
          ),
          onChanged: (text) {
            setState(() {
              fullName = text;
              //you can access nameController in its scope to get
              // the value of text entered as shown below
              //fullName = nameController.text;
            });
          },
        ));
  }

  Widget _inputkelas() {
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: kelasController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Kelas",
          ),
          onChanged: (text) {
            setState(() {
              kelas = text;
              //you can access nameController in its scope to get
              // the value of text entered as shown below
              //nimMHS = nameController.text;
            });
          },
        ));
  }

  Widget _inputkdmatkul() {
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: kdmatkulController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Kode Mata Kuliah",
          ),
          onChanged: (text) {
            setState(() {
              kdmatkul = text;
              //you can access nameController in its scope to get
              // the value of text entered as shown below
              //fullName = nameController.text;
            });
          },
        ));
  }

  Widget _inputemail() {
    return Container(
        margin: EdgeInsets.all(20),
        child: TextField(
          controller: emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Email",
          ),
          onChanged: (text) {
            setState(() {
              email = text;
              //you can access nameController in its scope to get
              // the value of text entered as shown below
              //fullName = nameController.text;
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
          appBar: AppBar(
            title: Text('Input Data Mahasiswa'),
          ),
          body: Center(
              child: Column(children: <Widget>[
                _inputFullName(),
                _inputkelas(),
                _inputkdmatkul(),
                _inputemail,            
            Container(
              margin: EdgeInsets.all(20),
              child: Text(fullName),
            ),
          ])),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Close', // used by assistive technologies
            child: Icon(Icons.close),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          )),
    );
  }
}