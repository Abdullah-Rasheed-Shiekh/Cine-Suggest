import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Trailerwatch extends StatefulWidget {
  final String trailerid;
  const Trailerwatch({Key? key, required this.trailerid}) : super(key: key);

  @override
  State<Trailerwatch> createState() => _TrailerWatchState();
}

class _TrailerWatchState extends State<Trailerwatch> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoid = YoutubePlayer.convertUrlToId(widget.trailerid);
    _controller = YoutubePlayerController(
      initialVideoId: videoid.toString(),
      flags: const YoutubePlayerFlags(
        enableCaption: true,
        autoPlay: false,
        mute: false,
        forceHD: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: YoutubePlayer(
        thumbnail: Image.network(
          "https://img.youtube.com/vi/" + widget.trailerid + "/hqdefault.jpg",
          fit: BoxFit.cover,
        ),
        controlsTimeOut: const Duration(milliseconds: 1500),
        aspectRatio: 16 / 9,
        controller: _controller,
        showVideoProgressIndicator: true,
        bufferIndicator: const Center(
          child: Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
          )),
        ),
        progressIndicatorColor: Colors.amber,
        bottomActions: const [
          CurrentPosition(),
          ProgressBar(
              isExpanded: true,
              colors: ProgressBarColors(
                playedColor: Colors.white,
                handleColor: Colors.deepPurple,
              )),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
    );
  }
}
