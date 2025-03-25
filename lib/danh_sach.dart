import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Trang danh sách nhạc đã chọn
class SelectedMusicScreen extends StatefulWidget {
  @override
  _SelectedMusicScreenState createState() => _SelectedMusicScreenState();
}

class _SelectedMusicScreenState extends State<SelectedMusicScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  String? currentlyPlayingSongPath;
  PlayerState _playerState = PlayerState.stopped;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPauseSong(String songPath) async {
    if (currentlyPlayingSongPath == songPath) {
      if (_playerState == PlayerState.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.resume();
      }
    } else {
      await audioPlayer.stop();
      try {
        await audioPlayer.play(AssetSource(songPath));
        setState(() {
          currentlyPlayingSongPath = songPath;
          _playerState = PlayerState.playing;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể phát nhạc: $songPath')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách nhạc'),
      ),
      body: SelectedMusic.songTitles.isEmpty
          ? Center(child: Text('Danh sách nhạc trống'))
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: SelectedMusic.songTitles.length,
        itemBuilder: (context, index) {
          final title = SelectedMusic.songTitles[index];
          final path = SelectedMusic.getPathFromTitle(title);

          return Card(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              leading: Icon(
                currentlyPlayingSongPath == path &&
                    _playerState == PlayerState.playing
                    ? Icons.pause
                    : Icons.music_note,
                size: 50,
                color: currentlyPlayingSongPath == path
                    ? Colors.blue
                    : Colors.grey,
              ),
              title: Text(title),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  SelectedMusic.removeSong(title);
                  if (currentlyPlayingSongPath == path) {
                    audioPlayer.stop();
                    currentlyPlayingSongPath = null;
                    _playerState = PlayerState.stopped;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xóa $title khỏi danh sách')),
                  );
                  setState(() {});
                },
              ),
              onTap: () {
                if (path != null) {
                  _playPauseSong(path);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Không tìm thấy đường dẫn bài hát')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

/// Lớp quản lý danh sách nhạc đã chọn
class SelectedMusic {
  static List<String> songTitles = [];
  static Map<String, String> titleToPathMap = {};

  static void addSong(String title, String path) {
    if (!songTitles.contains(title)) {
      songTitles.add(title);
      titleToPathMap[title] = path;
    }
  }

  static void removeSong(String title) {
    songTitles.remove(title);
    titleToPathMap.remove(title);
  }

  static String? getPathFromTitle(String title) {
    return titleToPathMap[title];
  }
}