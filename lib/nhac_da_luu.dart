import 'package:flutter/material.dart';
import 'downloaded_music_manager.dart';

class DownloadedMusicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhạc đã tải về'),
      ),
      body: FutureBuilder<List<String>>(
        future: DownloadedMusicManager.getDownloadedMusic(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có bài hát nào được tải về'));
          } else {
            final downloadedSongs = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: downloadedSongs.length,
              itemBuilder: (context, index) {
                final songName = downloadedSongs[index];
                return ListTile(
                  title: Text(songName),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      // Xóa bài hát khỏi danh sách đã tải về
                      await DownloadedMusicManager.removeDownloadedMusic(songName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã xóa $songName')),
                      );
                      // Cập nhật UI
                      (context as Element).markNeedsBuild();
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}