import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'danh_sach.dart';
import 'downloaded_music_manager.dart';

class NhacChillYeuDoiScreen extends StatefulWidget {
  @override
  _NhacChillYeuDoiScreenState createState() => _NhacChillYeuDoiScreenState();
}

class _NhacChillYeuDoiScreenState extends State<NhacChillYeuDoiScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingIndex;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Music> chillYeuDoiSongs = [
    Music(
      title: 'Lofi Chill Nhẹ Nhàng',
      artist: 'Chill Vibes',
      assetPath: 'music/lofi-B4.mp3',
      duration: '3:20',
      coverArt: 'assets/images/chill_1.jpg',
    ),
    Music(
      title: 'Nhạc Nền Lofi Thư Giãn',
      artist: 'Relaxation Station',
      assetPath: 'music/lofi-background-music-B3.mp3',
      duration: '4:15',
      coverArt: 'assets/images/chill_2.jpg',
    ),
    Music(
      title: 'Left Behind - Bản Chill Buồn',
      artist: 'Sad Melodies',
      assetPath: 'music/left-behind-C5.mp3',
      duration: '3:45',
      coverArt: 'assets/images/chill_3.jpg',
    ),
    Music(
      title: 'Lofi Chill Jazz',
      artist: 'Jazz Lovers',
      assetPath: 'music/lofi-chill-B2.mp3',
      duration: '5:10',
      coverArt: 'assets/images/chill_4.jpg',
    ),
    Music(
      title: 'Lofi Chill Yêu Đời',
      artist: 'Happy Tunes',
      assetPath: 'music/lofi-chill-jazz-F1.mp3',
      duration: '2:50',
      coverArt: 'assets/images/chill_5.jpg',
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
        await audioPlayer.play(AssetSource(chillYeuDoiSongs[index].assetPath));
        setState(() {
          currentlyPlayingIndex = index;
        });
      } catch (e) {
        print('Lỗi khi phát nhạc: $e');
        _showErrorSnackBar('Không thể phát nhạc: ${chillYeuDoiSongs[index].title}');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.teal[300],
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
        title: const Text('Nhạc Chill Yêu Đời'),
        backgroundColor: Colors.teal[400],
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
              itemCount: chillYeuDoiSongs.length,
              itemBuilder: (context, index) {
                final song = chillYeuDoiSongs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  elevation: 1,
                  color: Colors.teal[50],
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
                            Icon(Icons.music_note, size: 50, color: Colors.teal[400]),
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${song.artist} • ${song.duration}',
                      style: TextStyle(color: Colors.teal[600]),
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
                            color: Colors.teal[400],
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
    final song = chillYeuDoiSongs[currentlyPlayingIndex!];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal[100],
        border: Border(
          bottom: BorderSide(color: Colors.teal[400]!),
        ),
      ),
      child: Column(
        children: [
          Text(
            'ĐANG PHÁT',
            style: TextStyle(
              fontSize: 12,
              color: Colors.teal[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            song.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
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
                  color: Colors.teal[400],
                ),
                onPressed: () => _playPauseSong(currentlyPlayingIndex!),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  activeColor: Colors.teal[400],
                  inactiveColor: Colors.teal[200],
                  onChanged: (value) async {
                    await audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(
                '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.teal[800],
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