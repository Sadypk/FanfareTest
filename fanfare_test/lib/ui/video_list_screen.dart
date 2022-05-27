import 'dart:io';
import 'dart:math';

import 'package:fanfare_test/controllers/video_controller.dart';
import 'package:fanfare_test/data/post_model.dart';
import 'package:fanfare_test/repository/post_repository.dart';
import 'package:fanfare_test/theme/app_colors.dart';
import 'package:fanfare_test/theme/app_text_styles.dart';
import 'package:fanfare_test/ui/video_playback_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class VideoListScreen extends StatefulWidget {
  VideoListScreen({Key? key}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  final rnd = Random();
  int crossAxisCount = 4;

  @override
  void initState() {
    Get.put(VideoController());
    super.initState();
  }

  List<String> thumbnails = <String>[
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-sLgf6bCvUFxwQ_5TnXxSDeK-5dug_kP5Nw&usqp=CAU',
    'https://media.istockphoto.com/photos/bigeyed-naughty-obese-cat-behind-the-desk-with-red-hat-grey-color-picture-id1199279669?b=1&k=20&m=1199279669&s=170667a&w=0&h=munUsqGIlDAmKK0ouS12nHCuzDdoDfvNalw_hHvh6Ls=',
    'https://media.istockphoto.com/photos/bigeyed-naughty-obese-cat-looking-at-the-target-british-sort-hair-cat-picture-id1154980204?b=1&k=20&m=1154980204&s=170667a&w=0&h=x_IZJIhLaMchQUl1Pqd1eIcVY4d_vNopWWWmMcpAUN8=',
    'https://images.pexels.com/photos/1170986/pexels-photo-1170986.jpeg?cs=srgb&dl=pexels-evg-kowalievska-1170986.jpg&fm=jpg',
    'https://i.pinimg.com/originals/7e/0a/50/7e0a507de8cf8b46e0f2665f1058ef37.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkGrey,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            PostModel postModel = PostModel(
              author: 'author',
              description: 'description',
              imageUrl: 'imageUrl',
              views: 0,
              hearts: 0,
            );
            PostRepository postRepository = PostRepository();
            postRepository.post(postModel.toJson()).then((value) async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              File file = File((result?.files.single.path)!);
              var response = await postRepository.patchImage(file.path);
              Logger().i(response.statusCode);
              return;
            });
            // postRepository.get();
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Trending',
                style: AppTextStyles.sectionHeader,
              ).paddingSymmetric(vertical: 15),
              Expanded(
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        PostRepository postRepository = PostRepository();
                        PostModel postModel = await postRepository.get();
                        Get.to(VideoPlaybackScreen(
                          postModel: postModel,
                        ));
                      },
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                            child: Image(
                              image: NetworkImage(thumbnails[index]),
                            ),
                          ),
                          Align(
                            child: Container(
                              height: 35,
                              decoration: BoxDecoration(
                                  color: AppColors.grey,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(3),
                                      bottomRight: Radius.circular(3))),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://static7.depositphotos.com/1298242/789/i/600/depositphotos_7894119-stock-photo-smiling-hispanic-man-headshot.jpg'),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Some Name',
                                    style: AppTextStyles.subtitleOne,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    FeatherIcons.heart,
                                    color: AppColors.white,
                                    size: 13,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    '5',
                                    style: AppTextStyles.subtitleOne,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: thumbnails.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
