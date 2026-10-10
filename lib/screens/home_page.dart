import 'package:ai_saas_app/widgets/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker imagePicker;
  String? pickedImagePath;
  bool isImagePicked = false;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  Future<void> _pickImage({required ImageSource source}) async {
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      pickedImagePath = pickedImage.path;
      isImagePicked = true;
    });
  }

  // Show bottom sheet

  void _showBottomSheetWidget() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Take a Image from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(source: ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Take a Image from Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(source: ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ML Text Recognition",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ImagePreview(imagePath: pickedImagePath),
              ),
              if (!isImagePicked)
                ElevatedButton(
                  onPressed: _showBottomSheetWidget,
                  child: const Text(
                    "Pick an Image",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
