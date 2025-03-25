import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'danh_sach.dart';
import 'downloaded_music_manager.dart';

class TamTinhLauPhaiScreen extends StatefulWidget {
  @override
  _TamTinhLauPhaiScreenState createState() => _TamTinhLauPhaiScreenState();
}

class _TamTinhLauPhaiScreenState extends State<TamTinhLauPhaiScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingIndex;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Music> tamTinhLauPhaiSongs = [
    Music(
      title: 'Piano Nhẹ Nhàng',
      artist: 'Piano Tâm Tình',
      assetPath: 'music/soft-background-piano-E1.mp3',
      duration: '4:30',
      coverArt: 'assets/images/tam_tinh_1.jpg',
    ),
    Music(
      title: 'Summer Walk - Dạo Bước Mùa Hè',
      artist: 'Nhạc Tâm Trạng',
      assetPath: 'music/summer-walk-D1.mp3',
      duration: '3:45',
      coverArt: 'assets/images/tam_tinh_2.jpg',
    ),
    Music(
      title: 'Tap Room Rag',
      artist: 'Nhạc Acoustic',
      assetPath: 'music/tap-room-rag-C1.mp3',
      duration: '5:20',
      coverArt: 'assets/images/tam_tinh_3.jpg',
    ),
    Music(
      title: 'Tasty Chill Lofi Vibe',
      artist: 'Lofi Việt',
      assetPath: 'music/tasty-chill-lofi-vibe-A2.mp3',
      duration: '4:15',
      coverArt: 'assets/images/tam_tinh_4.jpg',
    ),
    Music(
      title: 'Town - Phố Nhỏ',
      artist: 'Nhạc Trữ Tình',
      assetPath: 'music/town-G5.mp3',
      duration: '3:50',
      coverArt: 'assets/images/tam_tinh_5.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAudioPlayerListeners();
  }

  void _setupAudioPlayerListeners() {
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });

    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _position = Duration.zero;
        currentlyPlayingIndex = null;
        _playerState = PlayerState.stopped;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseSong(int index) async {
    if (currentlyPlayingIndex == index) {
      if (_playerState == PlayerState.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.resume();
      }
    } else {
      await audioPlayer.stop();
      try {
        await audioPlayer.play(AssetSource(tamTinhLauPhaiSongs[index].assetPath));
        setState(() {
          currentlyPlayingIndex = index;
        });
      } catch (e) {
        print('Lỗi khi phát nhạc: $e');
        _showErrorSnackBar('Không thể phát nhạc: ${tamTinhLauPhaiSongs[index].title}');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.purple[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[300],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tâm Tình Lâu Phai'),
        backgroundColor: Colors.purple[400],
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Điều hướng đến màn hình tìm kiếm
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (currentlyPlayingIndex != null) _buildNowPlayingBar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: tamTinhLauPhaiSongs.length,
              itemBuilder: (context, index) {
                final song = tamTinhLauPhaiSongs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  elevation: 1,
                  color: Colors.purple[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        song.coverArt,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.music_note, size: 50, color: Colors.purple[400]),
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${song.artist} • ${song.duration}',
                      style: TextStyle(color: Colors.purple[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            currentlyPlayingIndex == index &&
                                _playerState == PlayerState.playing
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.purple[400],
                          ),
                          onPressed: () => _playPauseSong(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download, color: Colors.green),
                          onPressed: () async {
                            try {
                              await DownloadedMusicManager.addDownloadedMusic(song.title);
                              _showSuccessSnackBar('Đã tải xuống ${song.title}');
                            } catch (e) {
                              _showErrorSnackBar('Lỗi khi tải xuống: ${song.title}');
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      SelectedMusic.addSong(song.title, song.assetPath);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã thêm ${song.title} vào danh sách')),
                      );
                    },
                  )
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingBar() {
    final song = tamTinhLauPhaiSongs[currentlyPlayingIndex!];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        border: Border(
          bottom: BorderSide(color: Colors.purple[400]!),
        ),
      ),
      child: Column(
        children: [
          Text(
            'ĐANG PHÁT',
            style: TextStyle(
              fontSize: 12,
              color: Colors.purple[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            song.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _playerState == PlayerState.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.purple[400],
                ),
                onPressed: () => _playPauseSong(currentlyPlayingIndex!),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  activeColor: Colors.purple[400],
                  inactiveColor: Colors.purple[200],
                  onChanged: (value) async {
                    await audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(
                '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.purple[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Music {
  final String title;
  final String artist;
  final String assetPath;
  final String duration;
  final String coverArt;

  Music({
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.duration,
    required this.coverArt,
  });
}