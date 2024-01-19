import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/provider/list_story_provider.dart';
import 'package:story_app_flutter_intermediate/provider/post_story_provider.dart';
import 'package:story_app_flutter_intermediate/provider/upload_provider.dart';
import 'package:story_app_flutter_intermediate/ui/story_page/post_story/post_location.dart';

class PostStory extends StatefulWidget {
  final BottomNavigationBar bottomNavigationBar;

  const PostStory({
    super.key,
    required this.bottomNavigationBar,
  });

  @override
  State<PostStory> createState() => _PostStoryState();
}

class _PostStoryState extends State<PostStory> {
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final psWatch = context.watch<PostStoryProvider>();
    final psRead = context.read<PostStoryProvider>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Post Story',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: null,
        backgroundColor: Styles.primaryColor,
      ),
      body: SafeArea(
        child: (!psWatch.openMap)
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                      child:
                          context.watch<PostStoryProvider>().imagePath == null
                              ? const Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image,
                                    size: 100,
                                  ),
                                )
                              : _showImage(),
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
                            onPressed: () => _onCameraView(),
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
                            onPressed: () => _onGalleryView(),
                            child: const Text(
                              'Gallery',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    if (psWatch.myLocation == null)
                      SizedBox(
                        width: 150,
                        child: TextButton(
                          style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Styles.primaryColor,
                            ),
                          ),
                          onPressed: () => psRead.activateLocation(),
                          child: const Text(
                            'Tambahkan Lokasi',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: [
                          const Text(
                            'Location',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${psWatch.placemark!.street}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${psWatch.placemark!.subLocality}, ${psWatch.placemark!.locality}, ${psWatch.placemark!.postalCode}, ${psWatch.placemark!.country}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                  Styles.primaryColor,
                                ),
                              ),
                              onPressed: () => psRead.removeLocation(),
                              child: const Text(
                                'Hapus Lokasi',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
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
                    SizedBox(
                      width: 200,
                      child: TextButton(
                        style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Styles.primaryColor,
                          ),
                        ),
                        onPressed: () => _onUpload(
                          descriptionController.text,
                        ),
                        child: const Text(
                          'Upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const PostLocation(),
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }

  _onUpload(String description) async {
    final listProvider = context.read<ListStoryProvider>();

    final psProvider = context.read<PostStoryProvider>();
    final uploadProvider = context.read<UploadProvider>();

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
      psProvider.myLocation,
    );

    if (uploadProvider.uploadResponse != null) {
      psProvider.setImageFile(null);
      psProvider.setImagePath(null);
      psProvider.removeLocation();
    }

    await listProvider.updateList();

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );
  }

  _onGalleryView() async {
    final provider = context.read<PostStoryProvider>();

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

  _onCameraView() async {
    final provider = context.read<PostStoryProvider>();

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

  Widget _showImage() {
    final provider = context.read<PostStoryProvider>();

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
