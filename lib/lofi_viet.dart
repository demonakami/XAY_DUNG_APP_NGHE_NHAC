import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'bolero_thu_gian.dart';
import 'danh_sach.dart';
import 'downloaded_music_manager.dart';

class LofiVietScreen extends StatefulWidget {
  @override
  _LofiVietScreenState createState() => _LofiVietScreenState();
}

class _LofiVietScreenState extends State<LofiVietScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingIndex;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Music> lofiVietSongs = [
    Music(
      title: 'Lofi Chill - Nhạc Lofi Chill Việt Nam Hay Nhất',
      artist: 'Lofi Việt',
      assetPath: 'music/bolero-10-H5.mp3',
      duration: '3:45',
      coverArt: 'assets/images/lofi_chill_cover.jpg',
    ),
    Music(
      title: 'Lofi Việt - Những Bản Nhạc Lofi Buồn',
      artist: 'Lofi Vibes',
      assetPath: 'music/bolero-music-midnight-bolero-H4.mp3',
      duration: '4:12',
      coverArt: 'assets/images/lofi_viet_cover.jpg',
    ),
    Music(
      title: 'Nhạc Lofi Bolero Nhẹ Nhàng',
      artist: 'Bolero Lofi',
      assetPath: 'music/celtic-heartbeat-bolero-H3.mp3',
      duration: '3:30',
      coverArt: 'assets/images/lofi_bolero_cover.jpg',
    ),
    Music(
      title: 'Chill Beats - Lofi Việt Nam',
      artist: 'Chill Studio',
      assetPath: 'music/chill-beats-F3.mp3',
      duration: '4:45',
      coverArt: 'assets/images/chill_beats_cover.jpg',
    ),
    Music(
      title: 'Lofi Bachata Việt',
      artist: 'Lofi Latin',
      assetPath: 'music/cort_bolerobachata_dm-H1.mp3',
      duration: '3:15',
      coverArt: 'assets/images/bachata_cover.jpg',
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
        await audioPlayer.play(AssetSource(lofiVietSongs[index].assetPath));
        setState(() {
          currentlyPlayingIndex = index;
        });
      } catch (e) {
        print('Lỗi khi phát nhạc: $e');
        _showErrorSnackBar('Không thể phát nhạc: ${lofiVietSongs[index].title}');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
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
        backgroundColor: Colors.red,
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
        title: const Text('Lofi Việt'),
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
              itemCount: lofiVietSongs.length,
              itemBuilder: (context, index) {
                final song = lofiVietSongs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        song.coverArt,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.music_note, size: 50),
                      ),
                    ),
                    title: Text(
                      song.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${song.artist} • ${song.duration}',
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
                            color: Colors.blue,
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
    final song = lofiVietSongs[currentlyPlayingIndex!];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        border: const Border(
          bottom: BorderSide(color: Colors.blue),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Đang phát',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            song.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
                  color: Colors.blue,
                ),
                onPressed: () => _playPauseSong(currentlyPlayingIndex!),
              ),
              Expanded(
                child: Slider(
                  min: 0,
                  max: _duration.inSeconds.toDouble(),
                  value: _position.inSeconds.toDouble(),
                  onChanged: (value) async {
                    await audioPlayer.seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(
                '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}