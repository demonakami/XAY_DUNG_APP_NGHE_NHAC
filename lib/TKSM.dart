import 'dart:async';

import 'package:flutter/material.dart';
import 'danh_sach.dart';

/// Trang tìm kiếm bài hát (phiên bản cải tiến)
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = []; // Thay đổi từ List<String> sang List<Map>
  bool _isSearching = false;
  bool _noResults = false;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _searchSongs(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _noResults = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _noResults = false;
    });

    // Giả lập delay call API
    await Future.delayed(Duration(milliseconds: 500));

    // Giả lập kết quả từ API với cả title và path
    final mockDatabase = [
      {
        'title': 'Lofi Chill - Nhạc Lofi Chill Việt Nam Hay Nhất',
        'path': 'music/lofi_chill.mp3',
        'artist': 'Lofi Việt',
        'duration': '3:45'
      },
      {
        'title': 'Lofi Việt - Những Bản Nhạc Lofi Buồn',
        'path': 'music/lofi_viet.mp3',
        'artist': 'Lofi Vibes',
        'duration': '4:12'
      },
      {
        'title': 'Bolero Trữ Tình - Nhạc Vàng Hay Nhất',
        'path': 'music/bolero.mp3',
        'artist': 'Bolero Việt',
        'duration': '5:20'
      },
    ];

    setState(() {
      _searchResults = mockDatabase
          .where((song) => song['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _isSearching = false;
      _noResults = _searchResults.isEmpty;
    });
  }

  void _onSearchTextChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      _searchSongs(query);
    });
  }

  Widget _buildSearchResults() {
    if (_isSearching) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_noResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy kết quả',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Hãy thử từ khóa khác',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tìm kiếm bài hát yêu thích',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _searchSongs(_searchController.text),
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final song = _searchResults[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            elevation: 2,
            child: ListTile(
              leading: Icon(Icons.music_note, color: Colors.blue),
              title: Text(
                song['title']!,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text('${song['artist']} • ${song['duration']}'),
              trailing: Icon(Icons.add_circle_outline),
              onTap: () {
                SelectedMusic.addSong(song['title']!, song['path']!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã thêm "${song['title']}" vào danh sách'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        SelectedMusic.removeSong(song['title']!);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm bài hát, nghệ sĩ...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          autofocus: true,
          onChanged: _onSearchTextChanged,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchSongs(_searchController.text);
            },
          ),
        ],
      ),
      body: _buildSearchResults(),
    );
  }
}