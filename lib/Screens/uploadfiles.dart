import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../api/firebase_api.dart';
import 'buttonwidget.dart';


class Uploadfiles extends StatefulWidget {
  const Uploadfiles({Key key}) : super(key: key);

  @override
  State<Uploadfiles> createState() => _UploadfilesState();
}

class _UploadfilesState extends State<Uploadfiles> {
  UploadTask task;
  File file;
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file.path) : "No file selected";
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffff2d55),
          title: Text("Upload files"),
        ),
        body: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Buttonwidget(
                  text: 'Select file',
                  icon: Icons.attach_file,
                  onClicked: selectFile,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  fileName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
                ),
                Buttonwidget(
                  text: 'Upload file',
                  icon: Icons.cloud_upload_outlined,
                  onClicked: uploadFile,
                ),
                SizedBox(height: 20),
                task != null ? buildUploadStatus(task) : Container()
              ],
            ),
          ),
        ));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;
    final fileName = basename(file.path);
    final destination = 'files/$fileName';
    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;
    final snapshot = await task.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);
            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
