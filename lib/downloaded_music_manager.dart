import 'package:shared_preferences/shared_preferences.dart';

class DownloadedMusicManager {
  static const String _key = 'downloaded_music_list';

  // Lấy danh sách nhạc đã tải về
  static Future<List<String>> getDownloadedMusic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  // Thêm bài hát vào danh sách đã tải về
  static Future<void> addDownloadedMusic(String song) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> downloadedSongs = await getDownloadedMusic();
    if (!downloadedSongs.contains(song)) {
      downloadedSongs.add(song);
      await prefs.setStringList(_key, downloadedSongs);
    }
  }

  // Xóa bài hát khỏi danh sách đã tải về
  static Future<void> removeDownloadedMusic(String song) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> downloadedSongs = await getDownloadedMusic();
    downloadedSongs.remove(song);
    await prefs.setStringList(_key, downloadedSongs);
  }
}