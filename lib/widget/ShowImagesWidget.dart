import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShowImagesWidget extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  ShowImagesWidget({@required this.images,this.currentIndex = 0}):
        pageController = PageController(initialPage: currentIndex);

  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black87.withOpacity(0.5),),
      body: Container(
          child: PhotoViewGallery.builder(
            enableRotation: true,
            pageController: pageController,
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(images[index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
              );
            },
            itemCount: images.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                color: Colors.grey.shade400,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
          )
      ),
    );
  }
}
