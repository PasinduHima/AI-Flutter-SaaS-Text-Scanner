import 'package:ai_saas_app/constants/colors.dart';
import 'package:ai_saas_app/widgets/image_preview.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker imagePicker;
  late TextRecognizer textRecognizer;

  String? pickedImagePath;
  String recognizedText = "";

  bool isImagePicked = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  }

  // Function to pick an image
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

  //Function to process the picked image

  Future<void> _processImage() async {
    if (pickedImagePath == null) {
      return;
    }

    setState(() {
      isProcessing = true;
      recognizedText = "";
    });

    try {
      // Convert the selected image into an InputImage
      final inputImage = InputImage.fromFilePath(pickedImagePath!);

      // Process the image using ML Kit
      final RecognizedText textReturnedFromModel = await textRecognizer
          .processImage(inputImage);

      // Save the recognized text
      setState(() {
        recognizedText = textReturnedFromModel.text;
      });
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
        });
      }
    }
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
                leading: const Icon(Icons.camera_alt),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: _showBottomSheetWidget,
                      child: const Text(
                        'Pick an image',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),

              if (isImagePicked)
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _processImage,
                      child: const Text(
                        "Process Image",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
