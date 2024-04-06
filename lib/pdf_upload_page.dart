import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfUploadPage extends StatefulWidget {
  const PdfUploadPage({Key? key}) : super(key: key);

  @override
  _PdfUploadPageState createState() => _PdfUploadPageState();
}

class _PdfUploadPageState extends State<PdfUploadPage> {
  String? _pdfFilePath;
  late PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Upload Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickPDF,
              child: const Text('Pick a PDF'),
            ),
            const SizedBox(height: 20),
            if (_pdfFilePath != null)
              Expanded(
                child: PDFView(
                  filePath: _pdfFilePath!,
                  onViewCreated: (PDFViewController controller) {
                    _pdfViewController = controller;
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      if (kIsWeb) {
        final Uint8List bytes = result.files.single.bytes!;
        await uploadToFirebaseStorage(bytes);
      } else {
        final File file = File(result.files.single.path!);
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        _pdfFilePath = '${appDocDir.path}/picked_file.pdf';
        await file.copy(_pdfFilePath!);
        setState(() {});
      }
    }
  }

  Future<void> uploadToFirebaseStorage(Uint8List pdfBytes) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref('pdfs')
          .child('picked_file.pdf'); // Path to store your PDF in Firebase Storage
      await storageReference.putData(pdfBytes);
      final String downloadUrl = await storageReference.getDownloadURL();
      print('PDF uploaded to Firebase Storage. Download URL: $downloadUrl');
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('PDF uploaded successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error uploading PDF to Firebase Storage: $e');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to upload PDF. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
