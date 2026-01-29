import 'package:get/get.dart';
import 'package:jagoentertainment/src/core/base/base_controller.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/core/constants/app_colors.dart';
import 'package:jagoentertainment/src/features/video_player/controllers/mini_player_controller.dart';
import 'package:jagoentertainment/src/models/music/music_model.dart';
import 'package:jagoentertainment/src/models/music/music_response.dart';
import 'package:jagoentertainment/src/remote_datasource/music_remote_datasource.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class MusicController extends BaseController {
  static MusicController get to => Get.find<MusicController>();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final miniPlayer = MiniPlayerController.to;

  // ────── Observables ──────
  final RxList<MusicModel> musicList = <MusicModel>[].obs;
  final Rx<MusicModel?> currentMusic = Rx<MusicModel?>(null);
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isLive = false.obs;

  // ────── Live Stream  ──────
  final String liveUrl = 'http://178.128.215.46:12496/stream';
  final String liveTitle = 'Live Stream';
  final String liveArtist = 'Jago FM';
  final String liveArtPath = 'assets/images/live_radio.jpg';

  // ────── Loading state ──────
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupAudioPlayer();
    fetchAllMusic();
    miniPlayer.hide();
  }

  // ──────────────────────
  // 1. FETCH MUSIC LIST
  // ──────────────────────
  Future<void> fetchAllMusic() async {
    try {
      isLoading.value = true;
      final response = await MusicRemoteDatasource.to.getAllMusic();

      final List<MusicModel> models = response.data
          .where((item) => item.status == 'active')
          .map((item) => item.toMusicModel())
          .toList();

      musicList.assignAll(models);
    } catch (e, s) {
      logger.e('Music fetch error: $e\n$s');
      Get.snackbar('Error', 'Failed to load music', backgroundColor: AppColors.red500);
    } finally {
      isLoading.value = false;
    }
  }

  // ──────────────────────
  // 2. AUDIO PLAYER SETUP
  // ──────────────────────
  void _setupAudioPlayer() {
    _audioPlayer.positionStream.listen((p) => position.value = p);
    _audioPlayer.durationStream.listen((d) => duration.value = d ?? Duration.zero);
    _audioPlayer.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed && !isLive.value) {
        next();
      }
    });
  }

  // ──────────────────────
  // 3. PLAY REMOTE MUSIC
  // ──────────────────────
  Future<void> playMusic(MusicModel music) async {
    isLive.value = false;
    currentMusic.value = music;

    final mediaItem = MediaItem(
      id: music.id.toString(),
      title: music.title,
      artist: music.artist,
      artUri: Uri.parse(music.artUrl),
    );

    await _audioPlayer.setAudioSource(
      AudioSource.uri(Uri.parse(music.musicUrl), tag: mediaItem),
    );
    await _audioPlayer.play();
  }

  // ──────────────────────
  // 4. LIVE STREAM
  // ──────────────────────
  Future<void> playLive() async {
    isLive.value = true;
    currentMusic.value = null;

    final mediaItem = MediaItem(
      id: liveUrl,
      title: liveTitle,
      artist: liveArtist,
      artUri: Uri.parse('file:///android_asset/flutter_assets/$liveArtPath'),
    );

    try {
      await _audioPlayer.stop();
      await _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(liveUrl), tag: mediaItem),
        preload: false,
      );
      await _audioPlayer.play();
    } catch (e, s) {
      logger.e('Live stream error: $e\n$s');
      Get.snackbar('Error', 'Stream failed', backgroundColor: AppColors.red500);
      isLive.value = false;
    }
  }

  // ──────────────────────
  // 5. CONTROLS
  // ──────────────────────
  void togglePlayPause() => isPlaying.value ? _audioPlayer.pause() : _audioPlayer.play();

  void stop() {
    _audioPlayer.stop();
    isLive.value = false;
    currentMusic.value = null;
  }

  void next() {
    if (isLive.value) return;
    final i = musicList.indexOf(currentMusic.value!);
    playMusic(musicList[(i + 1) % musicList.length]);
  }

  void previous() {
    if (isLive.value) return;
    final i = musicList.indexOf(currentMusic.value!);
    playMusic(musicList[i > 0 ? i - 1 : musicList.length - 1]);
  }

  void seekTo(double seconds) {
    _audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}