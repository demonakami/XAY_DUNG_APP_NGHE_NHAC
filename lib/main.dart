import 'package:flutter/material.dart';

import 'TKSM.dart';
import 'bolero_thu_gian.dart';
import 'dang_ky.dart';
import 'dang_nhap.dart';
import 'danh_sach.dart';
import 'lofi_chill.dart';
import 'lofi_viet.dart';
import 'moc_mac.dart';
import 'nhac_chill_yeu_doi.dart';
import 'nhac_da_luu.dart';
import 'nhac_hoa_loi_viet.dart';
import 'nhac_trung_cuc_chill.dart';
import 'tam_tinh_lau_phai.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng âm nhạc',
      debugShowCheckedModeBanner: false, // Ẩn chữ Debug
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Trang chính
    );
  }
}

/// Trang chính (Explore)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
        actions: [
          IconButton(
            icon: MouseRegion(
              cursor: SystemMouseCursors.click, // Hiển thị con trỏ chuột khi di chuột qua
              child: Icon(Icons.person_add, color: Colors.blueGrey, size: 28),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
          ),
          SizedBox(width: 8), // Khoảng cách giữa các icon
          IconButton(
            icon: Icon(Icons.login, color: Colors.blueGrey, size: 28), // Icon đăng nhập
            onPressed: () {
              // Điều hướng sang trang đăng nhập
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          SizedBox(width: 8), // Khoảng cách giữa các icon
          IconButton(
            icon: Icon(Icons.search, color: Colors.blueGrey, size: 28), // Icon tìm kiếm
            onPressed: () {
              // Điều hướng sang trang tìm kiếm
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          SizedBox(width: 8), // Khoảng cách giữa các icon
          IconButton(
            icon: Icon(Icons.list, color: Colors.blueGrey, size: 28), // Icon danh sách
            onPressed: () {
              // Điều hướng sang trang danh sách nhạc đã chọn
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectedMusicScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/hinhnendep.jpg"), // Đường dẫn đến hình nền
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            MusicCategoryCard(
              title: 'Lofi Việt',
              subtitle: 'Nghe không dứt ra được',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LofiVietScreen()),
                );
              },
            ),
            MusicCategoryCard(
              title: 'Lofi Chill',
              subtitle: 'Nghe là nghiện',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LofiChillScreen()),
                );
              },
            ),
            MusicCategoryCard(
              title: 'Mộc mạc',
              subtitle: 'Chất indie nguyên sơ trong từng tiếng đàn',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MocMacScreen()),
                );
              },
            ),
            MusicCategoryCard(
              title: 'Tâm tình lâu phai',
              subtitle: 'Chút tâm tình này xin phép được lâu phai',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TamTinhLauPhaiScreen()),
                );
              },
            ),
            MusicCategoryCard(
              title: 'Nhạc Hoa lời Việt nhẹ nhàng',
              subtitle: 'Lắng nghe những giai điệu nhạc Hoa lời Việt nhẹ nhàng',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NhacHoaLoiVietScreen()),
                );
              },
            ),
            MusicCategoryCard(
              title: 'Nhạc chill yêu đời',
              subtitle: 'Những giai điệu nhẹ nhàng dễ thương giúp bạn iu đời hơn',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NhacChillYeuDoiScreen()),
                );
              },
            ),
            MusicCategoryCard(
              title: 'Nhạc trung cực chill',
              subtitle: 'Ở đây có nhạc Trung cực hot cực chill',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NhacTrungCucChillScreen()),
                );
              },
            ),
            MusicCategoryCard(
              title: 'Bolero thư giãn',
              subtitle: 'Thả tâm tình vào những giai điệu bolero nhẹ nhàng thư giãn',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BoleroThuGianScreen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Chỉ mục của mục được chọn
        selectedItemColor: Colors.blue, // Màu sắc khi được chọn
        unselectedItemColor: Colors.grey, // Màu sắc khi không được chọn
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Dã tải về',
          ),
        ],
        onTap: (index) {
          // Xử lý khi người dùng chọn một mục trong BottomNavigationBar
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SelectedMusicScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DownloadedMusicScreen()),
            );
          }
        },
      ),
    );
  }
}

class MusicCategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  MusicCategoryCard({required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 14.0)),
        onTap: onTap,
      ),
    );
  }
}