import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import '../tools/audio_player_manager.dart';
import '../tools/music_manager.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late MusicData musicData;

  @override
  initState() {
    super.initState();
  }

  String imageUrl =
      "https://pic.netbian.com/uploads/allimg/241017/233047-1729179047b593.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: BlurredImage(
                    blur: 80,
                    image: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ))),
            const Positioned(
              top: 40,
              left: 40,
              right: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "萌生",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "噗噗子",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.share,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            Center(
              child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                            image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover)),
                      ),
                    ],
                  )),
            ),
            const Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: SizedBox(
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "HQ",
                              style: TextStyle(color: Colors.white54),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text("MP3",
                                style: TextStyle(color: Colors.white54)),
                            SizedBox(
                              width: 15,
                            ),
                            Text("44.1KHz",
                                style: TextStyle(color: Colors.white54)),
                          ]),
                      Player()
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late AudioPlayerManager audioPlayerManager;

  @override
  void initState() {
    super.initState();
    audioPlayerManager = AudioPlayerManager();
    audioPlayerManager.init();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<PlayerState>(
        stream: audioPlayerManager.player.playerStateStream,
        builder: (context, snapshot) {
          return PlayerButtons(
            audioPlayerManager: audioPlayerManager,
          );
        },
      ),
    );
  }
}

class PlayerButtons extends StatefulWidget {
  final AudioPlayerManager audioPlayerManager;

  const PlayerButtons({super.key, required this.audioPlayerManager});

  @override
  State<PlayerButtons> createState() => _PlayerButtonsState();
}

class _PlayerButtonsState extends State<PlayerButtons> {
  late final AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = widget.audioPlayerManager.player;
  }

  Stream<DurationState>? durationState;

  Widget _playPauseButton(PlayerState? playerState) {
    if (playerState == null) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 60.0,
        height: 60.0,
        child: const Icon(Icons.warning_amber_rounded),
      );
    }

    final processingState = playerState.processingState;
    if (processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering) {
      return Container(
        margin: const EdgeInsets.all(8.0),
        width: 60.0,
        height: 60.0,
        padding: const EdgeInsets.all(7.0),
        child: const CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          strokeWidth: 6,
          color: Colors.white,
        ),
      );
    } else if (_audioPlayer.playing != true ||
        processingState == ProcessingState.idle) {
      return IconButton(
        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
        iconSize: 60,
        onPressed: _audioPlayer.play,
      );
    } else if (processingState != ProcessingState.completed) {
      return IconButton(
        icon: const Icon(Icons.pause_rounded, color: Colors.white),
        iconSize: 60,
        onPressed: _audioPlayer.pause,
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.replay, color: Colors.white),
        iconSize: 50.0,
        onPressed: () => _audioPlayer.seek(Duration.zero,
            index: _audioPlayer.effectiveIndices?.first),
      );
    }
  }

  Widget _shuffleButton(BuildContext context, bool isEnabled) {
    return IconButton(
      icon: isEnabled
          ? const Icon(Icons.shuffle, color: Colors.white)
          : const Icon(Icons.shuffle, color: Colors.white38),
      onPressed: () async {
        final enable = !isEnabled;
        if (enable) {
          await _audioPlayer.shuffle();
        }
        await _audioPlayer.setShuffleModeEnabled(enable);
      },
    );
  }

  Widget _previousButton() {
    return IconButton(
      icon: const Icon(
        Icons.skip_previous_rounded,
        size: 60,
        color: Colors.white,
      ),
      onPressed: _audioPlayer.hasPrevious ? _audioPlayer.seekToPrevious : null,
    );
  }

  Widget _nextButton() {
    return IconButton(
      icon: const Icon(
        Icons.skip_next_rounded,
        size: 60,
        color: Colors.white,
      ),
      onPressed: _audioPlayer.hasNext ? _audioPlayer.seekToNext : null,
    );
  }

  Widget _repeatButton(BuildContext context, LoopMode loopMode) {
    final icons = [
      const Icon(
        Icons.repeat,
        color: Colors.white38,
      ),
      const Icon(Icons.repeat, color: Colors.white),
      const Icon(Icons.repeat_one, color: Colors.white),
    ];
    const cycleModes = [
      LoopMode.off,
      LoopMode.all,
      LoopMode.one,
    ];
    final index = cycleModes.indexOf(loopMode);
    return IconButton(
      icon: icons[index],
      onPressed: () {
        _audioPlayer.setLoopMode(
            cycleModes[(cycleModes.indexOf(loopMode) + 1) % cycleModes.length]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20,
          margin:
              const EdgeInsets.only(right: 20, left: 20, bottom: 10, top: 10),
          child: StreamBuilder<DurationState>(
            stream: widget.audioPlayerManager.durationState,
            builder: (context, snapshot) {
              final durationState = snapshot.data;
              final progress = durationState?.progress ?? Duration.zero;
              final buffered = durationState?.buffered ?? Duration.zero;
              final total = durationState?.total ?? Duration.zero;
              return ProgressBar(
                timeLabelTextStyle: const TextStyle(color: Colors.white54),
                baseBarColor: Colors.white24,
                progressBarColor: Colors.white,
                bufferedBarColor: Colors.white30,
                thumbColor: Colors.transparent,
                thumbGlowColor: Colors.transparent,
                progress: progress,
                buffered: buffered,
                total: total,
                onSeek: (duration) {
                  _audioPlayer.seek(duration);
                },
              );
            },
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return _previousButton();
              },
            ),
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (_, snapshot) {
                final playerState = snapshot.data;
                return _playPauseButton(playerState);
              },
            ),
            StreamBuilder<SequenceState?>(
              stream: _audioPlayer.sequenceStateStream,
              builder: (_, __) {
                return _nextButton();
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<bool>(
              stream: _audioPlayer.shuffleModeEnabledStream,
              builder: (context, snapshot) {
                return _shuffleButton(context, snapshot.data ?? false);
              },
            ),
            StreamBuilder<LoopMode>(
              stream: _audioPlayer.loopModeStream,
              builder: (context, snapshot) {
                return _repeatButton(context, snapshot.data ?? LoopMode.off);
              },
            ),
            IconButton(
                icon: const Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(40))),
                      builder: (context) {
                        return const TimerDrawer();
                      });
                }),
            IconButton(
              icon: const Icon(
                Icons.queue_music_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                showGeneralDialog(
                    context: context,
                    transitionDuration: const Duration(milliseconds: 300),
                    // 动画时长
                    transitionBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 1.0), // 从底部开始
                          end: Offset.zero, // 移动到中间
                        ).animate(animation),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return const MusicListDialog();
                    });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.more_horiz_rounded,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        )
      ],
    );
  }
}

class TimerDrawer extends StatefulWidget {
  const TimerDrawer({super.key});

  @override
  State<TimerDrawer> createState() => _TimerDialogState();
}

class _TimerDialogState extends State<TimerDrawer> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        height: 350,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "定时关闭",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "计时结束后，将停止播放当前歌曲",
                        style: TextStyle(color: Colors.black54),
                      )
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 30,
                      ))
                ],
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      int duration = index * 15;
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                              height: 50,
                              child: Card(
                                color: Colors.white,
                                elevation: 0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(duration == 0 ? "不开启" : "$duration分钟",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: selectedIndex == index
                                                ? Colors.redAccent
                                                : Colors.black54)),
                                    const Spacer(),
                                    if (selectedIndex == index)
                                      const Icon(
                                        Icons.check_rounded,
                                        color: Colors.redAccent,
                                        size: 30,
                                      ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              )));
                    }),
              )
            ]));
  }
}

class MusicListDialog extends StatefulWidget {
  const MusicListDialog({super.key});

  @override
  State<MusicListDialog> createState() => _MusicListDialogState();
}

class _MusicListDialogState extends State<MusicListDialog> {
  int currentIndex = 0;
  List<Map<String, dynamic>> musicList = [
    {"name": "萌生", "artist": "hanser"},
    {"name": "天使重构", "artist": "hanser"},
  ];

  Widget buildListItem() {
    return ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: musicList.length,
        itemBuilder: (context, index) {
          Map data = musicList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                currentIndex = index;
              });
            },
            child: Container(
                alignment: Alignment.centerLeft,
                height: 40,
                child: Row(
                  children: [
                    Text("${data["name"]}-${data["artist"]}",
                        style: TextStyle(
                            color: currentIndex == index
                                ? Colors.red
                                : Colors.black,
                            fontFamily: "Sweet",
                            fontSize: 20)),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.black45,
                        )),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            musicList.removeAt(index);
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black45,
                        ))
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white,
        alignment: Alignment.bottomCenter,
        child: Container(
            width: double.infinity,
            height: 400,
            margin: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.library_music_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "歌曲列表",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Sweet",
                                  fontSize: 20),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                musicList.clear();
                              });
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              size: 27,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 310,
                    child: buildListItem(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "关闭",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )),
                  )
                ])));
  }
}
