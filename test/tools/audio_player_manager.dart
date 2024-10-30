import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'timer_manager.dart';

class AudioPlayerManager {
  final _player = AudioPlayer();
  List<AudioSource> playList = [];
  Stream<DurationState>? durationState;

  final TimerManager timerManager = TimerManager();

  AudioPlayer get player => _player;

  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        _player.positionStream,
        _player.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration,
            ));
  }

  void addToPlaylist(String url) async {
    playList.add(AudioSource.uri(Uri.parse(url)));
    await _player.setAudioSource(
        ConcatenatingAudioSource(
          children: playList,
        ),
        preload: false);
  }

  void deleteFromPlaylist(int id) async {
    playList.removeAt(id);
    await _player.setAudioSource(
        ConcatenatingAudioSource(
          children: playList,
        ),
        preload: false);
  }

  void play() async {
    await _player.play();
  }

  void pause() async {
    await _player.pause();
  }

  //   设置定时器，一段时间后自动暂停
  void startTimer(Duration duration) {
    timerManager.createNewTimer(duration, () {
      pause();
    });
  }

  void dispose() {
    _player.dispose();
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}
