import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/provider/post_story_provider.dart';
import 'package:story_app_flutter_intermediate/provider/upload_provider.dart';

class PostStory extends StatefulWidget {
  final BottomNavigationBar bottomNavigationBar;

  const PostStory({super.key, required this.bottomNavigationBar});

  @override
  State<PostStory> createState() => _PostStoryState();
}

class _PostStoryState extends State<PostStory> {
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (_) => PostStoryProvider(),
          child: SingleChildScrollView(
            child: Consumer<PostStoryProvider>(
              builder: (context, provider, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Styles.primaryColor,
                      padding: const EdgeInsets.all(16),
                      child: const Row(
                        children: [
                          Text(
                            'Post Story',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      height: 300,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(
                          style: BorderStyle.solid,
                          color: Colors.black26,
                        ),
                      ),
                      child: provider.imagePath == null
                          ? const Align(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image,
                                size: 100,
                              ),
                            )
                          : _showImage(provider),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Styles.primaryColor,
                              ),
                            ),
                            onPressed: () => _onCameraView(provider),
                            child: const Text(
                              'Camera',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 28),
                        SizedBox(
                          width: 100,
                          child: TextButton(
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Styles.primaryColor,
                              ),
                            ),
                            onPressed: () => _onGalleryView(provider),
                            child: const Text(
                              'Gallery',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        textAlign: TextAlign.justify,
                        textAlignVertical: TextAlignVertical.top,
                        controller: descriptionController,
                        cursorColor: Styles.primaryColor,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          focusColor: Styles.primaryColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              width: 2.0,
                              color: Styles.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ChangeNotifierProvider<UploadProvider>(
                      create: (_) => UploadProvider(
                        apiService: ApiServices(),
                      ),
                      child: Consumer<UploadProvider>(
                        builder: (context, uploadProvider, _) {
                          return SizedBox(
                            width: 200,
                            child: TextButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Styles.primaryColor,
                                ),
                              ),
                              onPressed: () => _onUpload(
                                provider,
                                uploadProvider,
                                descriptionController.text,
                              ),
                              child: const Text(
                                'Upload',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  _onUpload(PostStoryProvider psProvider, UploadProvider uploadProvider,
      String description) async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);

    final imagePath = psProvider.imagePath;
    final imageFile = psProvider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.upload(
      newBytes,
      fileName,
      description,
    );

    if (uploadProvider.uploadResponse != null) {
      psProvider.setImageFile(null);
      psProvider.setImagePath(null);
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );
  }

  _onGalleryView(PostStoryProvider provider) async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView(PostStoryProvider provider) async {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage(PostStoryProvider provider) {
    final imagePath = provider.imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.cover,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.cover,
          );
  }
}
