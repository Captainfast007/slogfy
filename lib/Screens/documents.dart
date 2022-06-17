import 'package:Vikalp/Screens/uploadfiles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/firebase_api.dart';
import '../models/firebase_file.dart';


class DocumentSection extends StatefulWidget {
  const DocumentSection({Key key}) : super(key: key);

  @override
  State<DocumentSection> createState() => _DocumentSectionState();
}

class _DocumentSectionState extends State<DocumentSection> {
  Future<List<FirebaseFile>> futureFiles;
  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('files/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Some error occurred'),
                );
              } else {
                final files = snapshot.data;

                return Column(
                  children: [
                    buildHeader(files.length, context),
                    Expanded(
                        child: ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];

                        return buildFile(context, file);
                      },
                      shrinkWrap: true,
                    ))
                  ],
                );
              }
          }
        },
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => Card(
        shadowColor: Color(0xffff2d55),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: ListTile(
          title: Text(
            file.name,
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blue),
          ),
          trailing: IconButton(
              onPressed: () async {
                await FirebaseApi.downloadFile(file.ref);

                final snackBar =
                    SnackBar(content: Text('Downloaded ${file.name}'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: Icon(Icons.file_download, color: Color(0xffff2d55))),
        ),
      );

  Widget buildHeader(int length, context) => ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        tileColor: Color(0xffff2d55),
        leading: Container(
          width: 52,
          height: 20,
          child: Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 12.0, top: 4),
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: Colors.white,
            onPressed: () {
              Get.to(Uploadfiles());
            },
            child: Icon(
              Icons.add,
              size: 32,
              color: Color(0xffff2d55),
            ),
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
}
