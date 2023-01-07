import 'package:duetstahall/util/image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';

Widget customNetworkImage(BuildContext context, String imageUrl, {double? height, BoxFit boxFit = BoxFit.fill}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    fit: boxFit,
    width: MediaQuery.of(context).size.width,
    height: height == 0 ? MediaQuery.of(context).size.height : height,
    errorWidget: (context, url, error) => const Icon(Icons.error),
    placeholder: ((context, url) => Center(
          child: Stack(
            children: [
              Shimmer.fromColors(
                  baseColor: Colors.black.withOpacity(.1),
                  highlightColor: Colors.grey.withOpacity(.1),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  )),
              Opacity(opacity: 0.2, child: Image.asset(ImagesModel.logo, height: 100, width: 100))
            ],
          ),
        )),
  );
}

Widget circularImage(String imageUrl, double height, double width) {
  return CachedNetworkImage(
      placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()),
      errorWidget: (context, url, error) => Image.asset("assets/background/profile.png", fit: BoxFit.cover, width: height, height: width),
      imageBuilder: (context, imageProvider) => Container(
          width: height,
          height: width,
          decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: imageProvider, fit: BoxFit.contain))),
      fit: BoxFit.contain,
      imageUrl: imageUrl);
}
