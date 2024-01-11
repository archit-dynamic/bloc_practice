import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_bloc.dart';
import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_event.dart';
import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_state.dart';
import 'package:bloc_practice/bloc_app_with_firebase/views/main_popup_menu_button.dart';
import 'package:bloc_practice/bloc_app_with_firebase/views/storage_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<FirebaseAppBloc>().state.images ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Photo Gallery",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) {
                return;
              }
              context.read<FirebaseAppBloc>().add(
                    AppEventUploadImage(filePathToUpload: image.path),
                  );
            },
            icon: const Icon(
              Icons.upload,
            ),
          ),
          const MainPopUpMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: images
            .map(
              (img) => StorageImageView(
                image: img,
              ),
            )
            .toList(),
      ),
    );
  }
}
