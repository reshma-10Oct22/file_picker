import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import 'package:image_picker/image_picker.dart';
import 'dart:io' show File, Platform;

class FilePickerComponent extends StatefulWidget {
  const FilePickerComponent({super.key});

  @override
  State<FilePickerComponent> createState() => _FilePickerComponentState();
}

class _FilePickerComponentState extends State<FilePickerComponent> {
  String filePath = "No file Selected";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(filePath)),
          Center(
            child: ElevatedButton(
              onPressed: _onPressed,
              child: const Text("Pick the file you want"),
            ),
          ),
        ],
      ),
    );
  }

  void _onPressed() async {
    if (Platform.isAndroid) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        print(file.bytes);
        print(file.name);
        print(file.extension);
        print(file.path);
        setState(() {
          filePath = file.name;
        });
      } else {
        setState(() {
          filePath = "No file selected";
        });
      }
    } else {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        useSafeArea: true,
        context: context,
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ListTile(
                  title: const Center(
                    child: Text(
                      "Choose Photo",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () {
                    final ImagePicker imagePicker = ImagePicker();
                    imagePicker
                        .pickImage(source: ImageSource.gallery)
                        .then((result) {
                      if (result == null) {
                        setState(() {
                          filePath = "No file selected";
                        });
                      } else {
                        setState(() {
                          filePath = result.path.split("-").last;
                        });
                        File file = File(result.path);
                      }
                    });
                    Navigator.pop(context);
                  }),
              const Divider(),
              ListTile(
                  title: const Center(
                    child: Text(
                      "Browse",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () {
                    FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
                    ).then((result) {
                      if (result == null) {
                        setState(() {
                          filePath = "No file selected";
                        });
                      } else {
                        PlatformFile file = result.files.first;
                        setState(() {
                          filePath = file.name;
                        });
                      }
                    });
                    Navigator.pop(context);
                  }),
              const Divider(),
              ListTile(
                  title: const Center(
                    child: Text(
                      "Scan Document",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () {
                    final ImagePicker imagePicker = ImagePicker();
                    imagePicker
                        .pickImage(source: ImageSource.camera)
                        .then((result) {
                      if (result != null) {
                        final XFile photo = result;
                        File file = File(photo.path);
                        print(file.path);
                        setState(() {
                          filePath = file.path.split("-").last;
                        });
                      } else {
                        setState(() {
                          filePath = "No file selected";
                        });
                      }
                    });
                    Navigator.pop(context);
                  }),
            ],
          );
        },
      );
    }
  }
}
