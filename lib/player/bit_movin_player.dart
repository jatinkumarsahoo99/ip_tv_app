import 'package:bitmovin_player/bitmovin_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class BitMovInPlayerVideo extends StatefulWidget {
  final int? videoId, videoType, typeId, otherId, stopTime;
  final String? playType, videoUrl, vUploadType, videoThumb;

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
    super.key,
  });

  @override
  _BitMovInPlayerVideoState createState() => _BitMovInPlayerVideoState();
}

class _BitMovInPlayerVideoState extends State<BitMovInPlayerVideo> {
  late Player _player;
  final _playerViewKey = GlobalKey<PlayerViewState>();

  final _fullscreenHandler = ExampleFullscreenHandler();
  final _logger = Logger();

  @override
  void initState() {
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

  void _initializePlayer() {
    // Create a Player instance with PlayerConfig
    const playerConfig = PlayerConfig(
      key: "ca403726-ea89-4f00-9db9-743b10fa05e2",
      remoteControlConfig: RemoteControlConfig(isCastEnabled: false),
    );
    _player = Player(config: playerConfig);

    // Set up event listeners
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
        type: SourceType.progressive, // or SourceType.dash or SourceType.progressive based on your source
      );
      _player.loadSourceConfig(sourceConfig).then((x) {
        if (widget.stopTime != null && widget.stopTime! > 0) {
          // Seek to the position provided by stopTime
          _player.seek(double.parse(widget.stopTime.toString())).then((_) {
            _player.play(); // Start playback after seeking
          });
        } else {
          _player.play(); // Start playback immediately if stopTime is not provided
        }
      }).catchError((error) {
        debugPrint("Error loading source: $error");
      });

      _fullscreenHandler.onStateChange = _refresh;
    }
  }

  void _refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _fullscreenHandler.isFullscreen
          ? null
          : AppBar(
              title: const Text('Fullscreen Handling'),
            ),
      backgroundColor: _fullscreenHandler.isFullscreen ? Colors.black : Colors.white,
      body: Column(
        mainAxisAlignment: _fullscreenHandler.isFullscreen ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: PlayerView(
              player: _player,
              key: _playerViewKey,
              fullscreenHandler: _fullscreenHandler,
              onFullscreenEnter: (event) => _logger.d('received ${event.runtimeType}: ${event.toJson()}'),
              onFullscreenExit: (event) => _logger.d('received ${event.runtimeType}: ${event.toJson()}'),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    _playerViewKey.currentState?.enterFullscreen();
                  },
                  child: const Text('Enter Fullscreen'),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                  ),
                  onPressed: () {
                    _playerViewKey.currentState?.exitFullscreen();
                  },
                  child: const Text('Exit Fullscreen'),
                ),
              ),
            ],
          ),
        ],
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
