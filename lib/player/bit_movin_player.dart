import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:bitmovin_player/bitmovin_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';

import '../provider/playerprovider.dart';
import 'bit_movin_controls.dart';
import 'bit_movin_events.dart';

class BitMovInPlayerVideo extends StatefulWidget {
  final int? videoId, videoType, typeId, otherId, stopTime;
  final String? playType, videoUrl, vUploadType, videoThumb;
  final bool? isLive;

  const BitMovInPlayerVideo(
    this.playType,
    this.videoId,
    this.videoType,
    this.typeId,
    this.otherId,
    this.videoUrl,
    this.stopTime,
    this.vUploadType,
    this.videoThumb, {
    super.key, this.isLive = false,
  });

  @override
  _BitMovInPlayerVideoState createState() => _BitMovInPlayerVideoState();
}

class _BitMovInPlayerVideoState extends State<BitMovInPlayerVideo> {
  late Player _player;
  final _playerViewKey = GlobalKey<PlayerViewState>();
  late PlayerProvider playerProvider;

  final _fullscreenHandler = ExampleFullscreenHandler();
  final _logger = Logger();

// Function to adjust the volume
  Future<void> _adjustVolume(double delta) async {
    // Get the current volume level
    double currentVolume = await VolumeController().getVolume();

    // Calculate the new volume level
    double newVolume = (currentVolume + (delta * 10)).clamp(0, 100);

    // Set the new volume level
    VolumeController().setVolume(newVolume);
  }

  Future<void> _handleKeyEvent(KeyEvent event) async {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.select: // D-pad Center (Enter)
          _player.play();
          break;
        case LogicalKeyboardKey.mediaPlayPause: // Media Play/Pause key
          _togglePlayPause();
          break;
        case LogicalKeyboardKey.mediaPause: // Media Play/Pause key
          _togglePlayPause();
          break;
        case LogicalKeyboardKey.mediaStop: // Media Play/Pause key
          _togglePlayPause();
          break;
        case LogicalKeyboardKey.mediaPlay: // Media Play/Pause key
          _togglePlayPause();
          break;
        case LogicalKeyboardKey.pause: // Media Play/Pause key
          _togglePlayPause();
          break;
        case LogicalKeyboardKey.arrowRight: // D-pad Right
          _player.seek(await _player.currentTime + 10);
          break;
        case LogicalKeyboardKey.mediaFastForward: // D-pad Right
          _player.seek(await _player.currentTime + 10);
          break;
        case LogicalKeyboardKey.arrowLeft: // D-pad Left
          _player.seek(await _player.currentTime - 10);
          break;
        case LogicalKeyboardKey.arrowUp: // D-pad Up
          _adjustVolume(0.1); // Increase volume by 10%;
          break;
        case LogicalKeyboardKey.arrowDown: // D-pad Down
          _adjustVolume(-0.1); // Decrease volume by 10%
          break;
        default:
          debugPrint('Unhandled key pressed: ${event.logicalKey.keyLabel}');
      }
    }
  }


  Future<void> _togglePlayPause() async {
    if (await _player.isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void _onEvent(Event event) {
    final eventName = '${event.runtimeType}';
    final eventData = '$eventName ${event.toJson()}';
    _logger.d(eventData);
    _eventsKey.currentState?.add(eventName);

    debugPrint(">>>>>>>>>>event Data:>>>>>>> $eventData");
  }

  void _listen() {
    _player
      ..onError = _onEvent
      ..onInfo = _onEvent
      ..onSourceLoad = _onEvent
      ..onSourceLoaded = _onEvent
      // ..onMuted = _onEvent
      // ..onPaused = _onEvent
      ..onPlay = _onEvent
      ..onPlaybackFinished = _onEvent
      // ..onPlaying = _onEvent
      ..onReady = _onEvent
      // ..onSeek = _onEvent
      // ..onSeeked = _onEvent
      // ..onSourceAdded = _onEvent
      // ..onSourceRemoved = _onEvent
      // ..onSourceError = _onEvent
      // ..onSourceInfo = _onEvent
      // ..onSourceUnloaded = _onEvent
      // ..onSourceWarning = _onEvent
      // ..onTimeChanged = _onEvent
      // ..onUnmuted = _onEvent
      // ..onWarning = _onEvent
      // ..onSubtitleAdded = _onEvent
      // ..onSubtitleRemoved = _onEvent
      // ..onSubtitleChanged = _onEvent
      // ..onCueEnter = _onEvent
      // ..onCueExit = _onEvent
      // ..onAirPlayAvailable = _onEvent
      ..onAirPlayChanged = _onEvent;
  }

  @override
  void initState() {
    // Set landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    // widget.videoUrl= "https://www.nandighoshatvlive.com/hls/stream/index.m3u8";
    debugPrint("videoUrl ========> ${widget.videoUrl}");
    debugPrint("vUploadType ========> ${widget.vUploadType}");
    debugPrint("stopTime ========> ${widget.stopTime}");
    super.initState();
    _initializePlayer();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  double currentVideoPlayPosition = 0;

  void _initializePlayer() {
    // Create a Player instance with PlayerConfig
    const playerConfig = PlayerConfig(
        key: "ca403726-ea89-4f00-9db9-743b10fa05e2",
        remoteControlConfig: RemoteControlConfig(isCastEnabled: false),
        playbackConfig: PlaybackConfig(
          isAutoplayEnabled: true,
        ),
        styleConfig: StyleConfig(
          playerUiCss:
              'https://cdn.statically.io/gh/bitmovin/bitmovin-player-ios-samples/main/CustomHtmlUi/Supporting%20Files/bitmovinplayer-ui.min.css',
          playerUiJs:
              'https://cdn.statically.io/gh/bitmovin/bitmovin-player-ios-samples/main/CustomHtmlUi/Supporting%20Files/bitmovinplayer-ui.min.js',
          supplementalPlayerUiCss: 'https://cdn.bitmovin.com/player/ui/ui-customized-sample.css',
        ),
        analyticsConfig: AnalyticsConfig(licenseKey: '88210dbd-db28-4a1b-97d3-4a5d8d23fb1e'));
    _player = Player(config: playerConfig);
    // Set up event listeners
    // _player.setTimeShift(timeShift);
    _player.onError = _onPlayerError;
    // Load the source
    _setupPlayerSource();
  }

  void _onPlayerReady() {
    debugPrint("Player ready");
  }

  void _onPlayerError(ErrorEvent errorEvent) {
    debugPrint("Player error: ${errorEvent.message}");
  }

  void _setupPlayerSource() {
    if (widget.videoUrl != null) {
      var sourceConfig = SourceConfig(
        url: widget.videoUrl!,
        type: (widget.isLive == false)? SourceType.progressive:SourceType.hls, // or SourceType.dash or SourceType.progressive based on your source
      );
      _player.loadSourceConfig(sourceConfig).then((x) async {
        if (widget.stopTime != null && widget.stopTime! > 0) {
          // Seek to the position provided by stopTime
          /*_player.seek(double.parse(widget.stopTime.toString())).then((_) {
            _player.play(); // Start playback after seeking
          });*/
          // _player.setTimeShift(double.parse(widget.stopTime.toString()));

          await _player.play();
          await _player.seek(double.parse(widget.stopTime.toString()));
        } else {
          await _player.play(); // Start playback immediately if stopTime is not provided
        }
      }).catchError((error) {
        debugPrint("Error loading source: $error");
      });

      _fullscreenHandler.onStateChange = _refresh;
    }
    _listen();
  }

  void _refresh() {
    setState(() {});
  }

  Future<bool> onBackPressed() async {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    await getCurrentVideoPosition();
    debugPrint("onBackPressed playerCPosition :===> $currentVideoPlayPosition");
    debugPrint("onBackPressed videoDuration :===> $currentVideoPlayPosition");
    debugPrint("onBackPressed playType :===> ${widget.playType}");

    if (widget.playType == "Video" || widget.playType == "Show") {
      if ((currentVideoPlayPosition ?? 0) > 300) {
        await playerProvider.addToContinue("${widget.videoId}", "${widget.videoType}", "$currentVideoPlayPosition");
        if (!mounted) return Future.value(false);
        Navigator.pop(context, true);
        return Future.value(true);
      } else {
        if (!mounted) return Future.value(false);
        Navigator.pop(context, false);
        return Future.value(true);
      }
    } else {
      if (!mounted) return Future.value(false);
      Navigator.pop(context, false);
      return Future.value(true);
    }
  }

  @override
  void dispose() {
    getCurrentVideoPosition();
    // Reset orientation when leaving the page
    /*SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);*/
    _player.dispose();
    super.dispose();
  }

  Future<void> getCurrentVideoPosition() async {
    currentVideoPlayPosition = await _player.currentTime;
    debugPrint(">>>>>>>>>currentVideoPlayPosition$currentVideoPlayPosition");
  }

  final _playerViewConfig = const PlayerViewConfig(
    pictureInPictureConfig: PictureInPictureConfig(
      isEnabled: true,
      shouldEnterOnBackground: true,
    ),
  );

  final _eventsKey = GlobalKey<EventsState>();
  bool _isInPictureInPicture = false;

  void _onPictureInPictureEnterEvent(Event event) {
    _onEvent(event);
    setState(() {
      _isInPictureInPicture = true;
    });
  }

  void _onPictureInPictureExitEvent(Event event) {
    _onEvent(event);
    setState(() {
      _isInPictureInPicture = false;
    });
  }

  Future<void> setupAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  // Since PiP on Android is basically just the whole activity fitted in a small
  // floating window, we don't want to display the whole scaffold
  bool get renderOnlyPlayerView => Platform.isAndroid && _isInPictureInPicture;

  @override
  Widget build(BuildContext context) {
    final playerView = PlayerView(
      player: _player,
      key: _playerViewKey,
      fullscreenHandler: _fullscreenHandler,
      onFullscreenEnter: (event) => _logger.d('received ${event.runtimeType}: ${event.toJson()}'),
      onFullscreenExit: (event) => _logger.d('received ${event.runtimeType}: ${event.toJson()}'),
      playerViewConfig: _playerViewConfig,
      onPictureInPictureEnter: _onPictureInPictureEnterEvent,
      onPictureInPictureEntered: _onEvent,
      onPictureInPictureExit: _onPictureInPictureExitEvent,
      onPictureInPictureExited: _onEvent,
    );
    if (renderOnlyPlayerView) {
      return playerView;
    }

    return WillPopScope(
      onWillPop: onBackPressed,
      child: KeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKeyEvent: ((KeyEvent event) async {
          if (event is KeyDownEvent) {
            switch (event.logicalKey) {
              case LogicalKeyboardKey.select: // D-pad Center (Enter)
                _player.play();
                break;
              case LogicalKeyboardKey.mediaPlayPause: // Media Play/Pause key
                _togglePlayPause();
                break;
              case LogicalKeyboardKey.mediaPause: // Media Play/Pause key
                _togglePlayPause();
                break;
              case LogicalKeyboardKey.mediaStop: // Media Play/Pause key
                _togglePlayPause();
                break;
              case LogicalKeyboardKey.mediaPlay: // Media Play/Pause key
                _togglePlayPause();
                break;
              case LogicalKeyboardKey.pause: // Media Play/Pause key
                _togglePlayPause();
                break;
              case LogicalKeyboardKey.arrowRight: // D-pad Right
                _player.seek(await _player.currentTime + 10);
                break;
              case LogicalKeyboardKey.mediaFastForward: // D-pad Right
                _player.seek(await _player.currentTime + 10);
                break;
              case LogicalKeyboardKey.arrowLeft: // D-pad Left
                _player.seek(await _player.currentTime - 10);
                break;
              case LogicalKeyboardKey.arrowUp: // D-pad Up
                _adjustVolume(0.1); // Increase volume by 10%;
                break;
              case LogicalKeyboardKey.arrowDown: // D-pad Down
                _adjustVolume(-0.1); // Decrease volume by 10%
                break;
              default:
                debugPrint('Unhandled key pressed: ${event.logicalKey.keyLabel}');
            }
          }
        }),
        child: Scaffold(
          backgroundColor: _fullscreenHandler.isFullscreen ? Colors.black : Colors.white,
          // body: AspectRatio(aspectRatio: 16 / 9, child: playerView),
          body: playerView,
        ),
      ),
    );
  }
}

class ExampleFullscreenHandler implements FullscreenHandler {
  @override
  bool get isFullscreen => _isFullscreen;
  bool _isFullscreen = false;
  void Function()? onStateChange;

  @override
  void enterFullscreen() {
    _isFullscreen = true;

    // Hide status/navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );

    onStateChange?.call();
  }

  @override
  void exitFullscreen() {
    _isFullscreen = false;

    // Show status/navigation bar
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    onStateChange?.call();
  }
}
