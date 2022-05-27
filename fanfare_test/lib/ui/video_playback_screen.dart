import 'package:chewie/chewie.dart';
import 'package:fanfare_test/controllers/video_controller.dart';
import 'package:fanfare_test/data/post_model.dart';
import 'package:fanfare_test/theme/app_colors.dart';
import 'package:fanfare_test/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlaybackScreen extends StatefulWidget {
  final PostModel postModel;
  const VideoPlaybackScreen({Key? key, required this.postModel})
      : super(key: key);

  @override
  _VideoPlaybackScreenState createState() => _VideoPlaybackScreenState();
}

class _VideoPlaybackScreenState extends State<VideoPlaybackScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late VideoController videoController;

  late Animation<double> overlayAnimation;
  late AnimationController overlayController;

  bool showNotification = false;

  final double iconSize = 20;
  final double iconGap = 40;

  @override
  void initState() {
    videoController = Get.find();
    videoPlayerController = VideoPlayerController.network(
        'http://10.0.2.2:5000/' + widget.postModel.imageUrl);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    overlayController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    overlayAnimation = Tween<double>(begin: -50, end: 15).animate(
        CurvedAnimation(parent: overlayController, curve: Curves.easeOutExpo));
    overlayController.forward();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerWidget = Chewie(
      controller: chewieController,
    );
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: <Widget>[
            playerWidget,
            AnimatedBuilder(
                animation: overlayAnimation,
                builder: (BuildContext context, _) => Positioned(
                      right: overlayAnimation.value,
                      bottom: 100,
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            onTap: videoController.onTapHeart,
                            child: Icon(
                              FeatherIcons.heart,
                              color: AppColors.white,
                              size: iconSize,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.postModel.hearts.toString(),
                            style: AppTextStyles.subtitleOne,
                          ),
                          SizedBox(
                            height: iconGap,
                          ),
                          InkWell(
                            onTap: videoController.onTapComment,
                            child: Icon(
                              FeatherIcons.messageSquare,
                              color: AppColors.white,
                              size: iconSize,
                            ),
                          ),
                          SizedBox(
                            height: iconGap,
                          ),
                          Icon(
                            FeatherIcons.eye,
                            color: AppColors.white,
                            size: iconSize,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.postModel.views.toString(),
                            style: AppTextStyles.subtitleOne,
                          ),
                          SizedBox(
                            height: iconGap,
                          ),
                          Icon(
                            FeatherIcons.share2,
                            color: AppColors.white,
                            size: iconSize,
                          ),
                          SizedBox(
                            height: iconGap,
                          ),
                          Icon(
                            FeatherIcons.music,
                            color: AppColors.white,
                            size: iconSize,
                          ),
                        ],
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
