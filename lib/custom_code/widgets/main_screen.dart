// Automatic FlutterFlow imports
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class MainScreen extends StatefulWidget {
  final double? height;
  final double? width;

  const MainScreen({
    super.key,
    this.height,
    this.width,
  });

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}

// Home Screen
final supabase = SupaFlow.client;

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  // void _showAdminLogin(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => AdminDashboard()),
  //   );
  // }
  void _showAdminLogin(BuildContext context) {
    String password = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Admin Access ', style: TextStyle(color: Colors.red)),
        content: TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter admin password !',
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          onChanged: (value) => password = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (password == 'admin123') {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminDashboard()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Incorrect password')),
                );
              }
            },
            child: Text('Login'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              snap: false,
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 248, 11, 31),
              title: AnimatedBuilder(
                animation: ModalRoute.of(context)?.animation ??
                    kAlwaysCompleteAnimation,
                builder: (context, child) {
                  return Container(
                    height: 40,
                    child: Row(
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.newspaper,
                            color: Color.fromARGB(255, 248, 11, 31),
                            size: 19,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'www.palakkadonlinenews.com',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background gradient
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 248, 11, 31),
                            Color.fromARGB(255, 236, 94, 120),
                            Color.fromARGB(255, 255, 152, 167),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // Overlay pattern for visual depth
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    // Main content
                    Positioned(
                      top: 80,
                      left: 16,
                      right: 16,
                      child: Column(
                        children: [
                          // Logo/Image container
                          Container(
                            height: 100,
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: Offset(0, 8),
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  // Placeholder for image
                                  Image.asset(
                                    'assets/images/palakkadnewspic.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.95),
                                              Colors.white.withOpacity(0.85),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.newspaper,
                                                size: 28,
                                                color: Color.fromARGB(
                                                    255, 248, 11, 31),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Palakkad News',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 248, 11, 31),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  letterSpacing: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Subtle overlay for better text visibility if needed
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Actions in the app bar
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => _showAdminLogin(context),
                  ),
                ),
              ],
            ),
            // Custom tab bar as a sliver
            SliverPersistentHeader(
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Color.fromARGB(255, 248, 11, 31),
                  indicatorWeight: 3,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 12),
                  labelColor: Color.fromARGB(255, 248, 11, 31),
                  unselectedLabelColor: Colors.grey[600],
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🔥'),
                            SizedBox(width: 4),
                            Text('Breaking'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('📈'),
                            SizedBox(width: 4),
                            Text('Trending'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('💼'),
                            SizedBox(width: 4),
                            Text('Jobs'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🌹'),
                            SizedBox(width: 4),
                            Text('Memorial'),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('📰'),
                            SizedBox(width: 4),
                            Text('All News'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF8FAFC),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: TabBarView(
            controller: _tabController,
            children: [
              NewsListView(category: 'breaking'),
              NewsListView(category: 'trending'),
              JobsListView(),
              MemorialApp(),
              NewsListView(category: 'all'),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
              spreadRadius: 2,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final Uri whatsappGroupUrl =
                Uri.parse("https://chat.whatsapp.com/G6Zj0ajnIcQ8gm1GyCDgmG");

            if (await canLaunchUrl(whatsappGroupUrl)) {
              await launchUrl(whatsappGroupUrl,
                  mode: LaunchMode.externalApplication);
            } else {
              print("Could not launch WhatsApp group link");
            }
          },
          icon: Icon(Icons.group, size: 20),
          label: Text(
            'Join Group',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}

// News List View
class NewsListView extends StatefulWidget {
  final String category;

  const NewsListView({required this.category});

  @override
  _NewsListViewState createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  List<Map<String, dynamic>> news = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      final response = widget.category == 'all'
          ? await supabase
              .from('news')
              .select()
              .order('created_at', ascending: false)
          : await supabase
              .from('news')
              .select()
              .eq('category', widget.category)
              .order('created_at', ascending: false);

      setState(() {
        news = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching news: $e'),
          backgroundColor: Color(0xFFE53E3E),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _showDeleteConfirmation(Map<String, dynamic> newsItem) async {
    final TextEditingController passwordController = TextEditingController();
    bool isDeleting = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4444).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_forever_rounded,
                        color: Color(0xFFEF4444),
                        size: 32,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Delete News Article',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'This action cannot be undone. The article and all associated media will be permanently deleted.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        enabled: !isDeleting,
                        decoration: InputDecoration(
                          hintText: 'Enter admin password',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFF6B7280),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: isDeleting
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isDeleting
                                ? null
                                : () async {
                                    if (passwordController.text == 'admin123') {
                                      setDialogState(() {
                                        isDeleting = true;
                                      });
                                      await _deleteNewsItem(newsItem);
                                      Navigator.of(context).pop();
                                    } else {
                                      // _showErrorSnackBar(
                                      //     'Invalid admin password');
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEF4444),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: isDeleting
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _deleteNewsItem(Map<String, dynamic> newsItem) async {
    try {
      final supabase = SupaFlow.client;

      // Separate files by storage bucket
      final List<String> newsMediaFiles = [];
      final List<String> advertisementFiles = [];

      // Add image file to deletion list (news-media bucket)
      if (newsItem['image_url'] != null) {
        final imageUrl = newsItem['image_url'] as String;
        if (imageUrl.contains('news-media/images/')) {
          final fileName = imageUrl.split('/').last.split('?').first;
          newsMediaFiles.add('images/$fileName');
        }
      }

      // Add video file to deletion list (news-media bucket)
      if (newsItem['video_url'] != null) {
        final videoUrl = newsItem['video_url'] as String;
        if (videoUrl.contains('news-media/videos/')) {
          final fileName = videoUrl.split('/').last.split('?').first;
          newsMediaFiles.add('videos/$fileName');
        }
      }

      // Add advertising image to deletion list (advertisements bucket)
      if (newsItem['advertising_image_url'] != null) {
        final adImageUrl = newsItem['advertising_image_url'] as String;
        if (adImageUrl.contains('advertisements/advertising/')) {
          final fileName = adImageUrl.split('/').last.split('?').first;
          advertisementFiles.add('advertising/$fileName');
        }
      }

      // Delete files from news-media storage bucket
      if (newsMediaFiles.isNotEmpty) {
        try {
          await supabase.storage.from('news-media').remove(newsMediaFiles);
          print('Successfully deleted news-media files: $newsMediaFiles');
        } catch (storageError) {
          print('Error deleting news-media files: $storageError');
        }
      }

      // Delete files from advertisements storage bucket
      if (advertisementFiles.isNotEmpty) {
        try {
          await supabase.storage
              .from('advertisements')
              .remove(advertisementFiles);
          print(
              'Successfully deleted advertisement files: $advertisementFiles');
        } catch (storageError) {
          print('Error deleting advertisement files: $storageError');
        }
      }

      // Delete news record from database
      await supabase.from('news').delete().eq('id', newsItem['id']);

      // Remove item from local list and update UI
      setState(() {
        news.removeWhere((item) => item['id'] == newsItem['id']);
      });

      _showSuccessSnackBar('News article deleted successfully');
    } catch (e) {
      print('Error deleting news: $e');
      // Optionally show error message to user
      // _showErrorSnackBar('Failed to delete news article');
    }
  }

  void _navigateToDetail(BuildContext context, Map<String, dynamic> newsItem) {
    if (kIsWeb) {
      // For Web (Chrome / Edge etc.), use GoRouter
      context.goNamed(
        NewsDetailScreen.routeName,
        queryParameters: {
          'id': newsItem['id']?.toString() ??
              '', // Pass the UUID as query parameter
        }.withoutNulls,
      );
      print('Navigating to context');
    } else if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isWindows ||
        Platform.isMacOS ||
        Platform.isLinux) {
      // For Mobile/Desktop, use Navigator.push
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(
            id: newsItem['id'] as String,
          ),
        ),
      );
    } else {
      // Fallback (just in case)
      context.pushNamed(
        NewsDetailScreen.routeName,
        extra: newsItem, // Pass your newsItem here
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 8,
                      blurRadius: 32,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading amazing content...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (news.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF667EEA).withOpacity(0.08),
                      spreadRadius: 8,
                      blurRadius: 32,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.newspaper_outlined,
                  size: 96,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 32),
              Text(
                'No news available yet',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Check back later for updates',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _fetchNews,
        color: Color(0xFF667EEA),
        backgroundColor: Colors.white,
        strokeWidth: 3,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: news.length,
          itemBuilder: (context, index) {
            final item = news[index];
            return Hero(
              tag: 'news_${item['id']}',
              child: Container(
                margin: EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF667EEA).withOpacity(0.06),
                      spreadRadius: 0,
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _navigateToDetail(context, item),
                    onLongPress: () {
                      _showDeleteConfirmation(item);
                    },
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item['image_url'] != null)
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24)),
                                    child: Container(
                                      width: double.infinity,
                                      child: Image.network(
                                        item['image_url'],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF667EEA),
                                                  Color(0xFF764BA2)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                size: 72,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    left: 20,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color:
                                            _getCategoryColor(item['category']),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.25),
                                            blurRadius: 12,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        _getCategoryEmoji(item['category']) +
                                            ' ${item['category'].toString().toUpperCase()}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            Padding(
                              padding: EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item['image_url'] == null)
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      margin: EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _getCategoryColor(item['category'])
                                                .withOpacity(0.1),
                                            _getCategoryColor(item['category'])
                                                .withOpacity(0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: _getCategoryColor(
                                                  item['category'])
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                      child: Text(
                                        _getCategoryEmoji(item['category']) +
                                            ' ${item['category'].toString().toUpperCase()}',
                                        style: TextStyle(
                                          color: _getCategoryColor(
                                              item['category']),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                      height: 1.4,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    item['description'] ?? '',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF64748B),
                                      height: 1.6,
                                      letterSpacing: 0.1,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF667EEA)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.access_time_rounded,
                                              size: 16,
                                              color: Color(0xFF667EEA),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            _formatDate(item['created_at']),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF64748B),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF667EEA),
                                              Color(0xFF764BA2)
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF667EEA)
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (item['advertising_image_url'] != null)
                              Stack(
                                children: [
                                  Text('Ads'),
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(24)),
                                    child: Container(
                                      width: double.infinity,
                                      child: Image.network(
                                        item['advertising_image_url'],
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF667EEA),
                                                  Color(0xFF764BA2)
                                                ],
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons
                                                    .image_not_supported_outlined,
                                                size: 64,
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        // Delete Button
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'breaking':
        return Color(0xFFE53E3E);
      case 'trending':
        return Color(0xFF38A169);
      case 'sports':
        return Color(0xFF3182CE);
      case 'technology':
        return Color(0xFF805AD5);
      case 'health':
        return Color(0xFFD69E2E);
      default:
        return Color(0xFF667EEA);
    }
  }

  String _getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'breaking':
        return '🔥';
      case 'trending':
        return '📈';
      case 'sports':
        return '⚽';
      case 'technology':
        return '💻';
      case 'health':
        return '🏥';
      default:
        return '📰';
    }
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }
}

// Enhanced News Detail Screen with Share functionality and Link Tap Time

// Jobs List View
class JobsListView extends StatefulWidget {
  @override
  _JobsListViewState createState() => _JobsListViewState();
}

class _JobsListViewState extends State<JobsListView> {
  List<Map<String, dynamic>> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final response = await supabase
          .from('jobs')
          .select()
          .order('created_at', ascending: false);
      setState(() {
        jobs = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteJob(String jobId, int index) async {
    try {
      await supabase.from('jobs').delete().eq('id', jobId);

      setState(() {
        jobs.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete job: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showDeleteConfirmation(String jobId, int index) async {
    final TextEditingController passwordController = TextEditingController();
    bool isDeleting = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              content: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFEF4444).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_forever_rounded,
                        color: Color(0xFFEF4444),
                        size: 32,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Delete Job',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Are you sure you want to delete ?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Color(0xFFE5E7EB)),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        enabled: !isDeleting,
                        decoration: InputDecoration(
                          hintText: 'Enter admin password',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Color(0xFF6B7280),
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: isDeleting
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isDeleting
                                ? null
                                : () async {
                                    if (passwordController.text == 'admin123') {
                                      setDialogState(() {
                                        isDeleting = true;
                                      });
                                      await _deleteJob(jobId, index);
                                      ;
                                      Navigator.of(context).pop();
                                    } else {
                                      // _showErrorSnackBar(
                                      //     'Invalid admin password');
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFEF4444),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: isDeleting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Color(0xFF667EEA)),
              )
            : jobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work_off_outlined,
                          size: 64,
                          color: Color(0xFF94A3B8),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No jobs found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap + to add your first job',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchJobs,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return GestureDetector(
                          onTap: () {
                            if (kIsWeb) {
                              context.goNamed(
                                JobDetailScreen.routeName,
                                queryParameters: {
                                  'id': job['id']?.toString() ??
                                      '', // Pass the UUID as query parameter
                                }.withoutNulls,
                              );
                            } else if (Platform.isAndroid || Platform.isIOS) {
                              // Android / iOS → use Navigator.push
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailScreen(
                                    jobId: job['id'],
                                  ),
                                ),
                              );
                            } else {
                              // Fallback → Web style navigation
                              context.push(
                                '/job-detail/${job['id']}',
                                extra: job,
                              );
                            }
                          },
                          onLongPress: () => _showDeleteConfirmation(
                            job['id'],
                            index,
                          ),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF667EEA).withOpacity(0.08),
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF667EEA)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.work_outline,
                                        color: Color(0xFF667EEA),
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            job['title'] ?? 'No Title',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B),
                                            ),
                                          ),
                                          Text(
                                            job['company'] ?? 'No Company',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF667EEA),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (job['location'] != null) ...[
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: 16,
                                        color: Color(0xFF94A3B8),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        job['location'],
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (job['salary'] != null) ...[
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.work,
                                        size: 16,
                                        color: Color(0xFF94A3B8),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        job['salary'],
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (job['description'] != null) ...[
                                  SizedBox(height: 12),
                                  Text(
                                    job['description'],
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                SizedBox(height: 12),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

//job detail page

class JobDetailScreen extends StatefulWidget {
  static String routeName = 'JobDetail';
  static String routePath = '/JobDetail';
  final String jobId; // Only need jobId parameter

  const JobDetailScreen({
    super.key,
    required this.jobId,
  });

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool isLoading = true;
  Map<String, dynamic>? jobDetails;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchJobDetails();
  }

  Future<void> _fetchJobDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Filter job by ID and fetch from Supabase
      final response = await supabase.from('jobs').select('''
            id,
            title,
            company,
            location,
            description,
            requirements,
            salary,
            created_at
          ''').eq('id', widget.jobId).single();

      setState(() {
        jobDetails = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Job not found or failed to load';
        isLoading = false;
      });
      print('Error fetching job details: $e');
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'Unknown';
    }
  }

  String _generateJobLink() {
    const baseUrl = AppConstants.baseUrl;
    return '$baseUrl/job-detail/${widget.jobId}';
  }

  String _generateShareContent() {
    if (jobDetails == null) return '';

    final jobLink = _generateJobLink();

    String shareText = '''
🚀 Job Opportunity Alert!

📋 Position: ${jobDetails!['title'] ?? 'Job Title'}
🏢 Company: ${jobDetails!['company'] ?? 'Company Name'}
${jobDetails!['location'] != null ? '📍 Location: ${jobDetails!['location']}\n' : ''}${jobDetails!['salary'] != null ? '💰 Salary: ${jobDetails!['salary']}\n' : ''}
📅 Posted: ${_formatDate(jobDetails!['created_at'])}

${jobDetails!['description'] != null ? '📝 Description:\n${jobDetails!['description']}\n\n' : ''}🔗 View Full Details: $jobLink

#JobOpportunity #Hiring #Career
    '''
        .trim();

    return shareText;
  }

  Future<void> _shareJob() async {
    if (jobDetails == null) return;

    try {
      final shareContent = _generateShareContent();

      await Share.share(
        shareContent,
        subject: 'Job Opportunity: ${jobDetails!['title']}',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Job shared successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      _copyToClipboard();
    }
  }

  void _copyToClipboard() {
    final jobLink = _generateJobLink();
    Clipboard.setData(ClipboardData(text: jobLink));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.content_copy, color: Colors.white),
              SizedBox(width: 8),
              Text('Job link copied to clipboard!'),
            ],
          ),
          backgroundColor: Color(0xFF667EEA),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Refresh job details
  Future<void> _refreshJobDetails() async {
    await _fetchJobDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Job Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (jobDetails != null) ...[
                      GestureDetector(
                        onTap: _refreshJobDetails,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      GestureDetector(
                        onTap: _shareJob,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF667EEA),
            ),
            SizedBox(height: 16),
            Text(
              'Loading job details...',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Color(0xFFEF4444),
              size: 64,
            ),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshJobDetails,
              child: Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667EEA),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (jobDetails == null) {
      return Center(
        child: Text(
          'No job details available',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 16,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Header Card
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667EEA).withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF667EEA).withOpacity(0.1),
                        Color(0xFF764BA2).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.work_outline,
                    color: Color(0xFF667EEA),
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  jobDetails!['title'] ?? 'No Title',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  jobDetails!['company'] ?? 'No Company',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF667EEA),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    if (jobDetails!['location'] != null)
                      _buildInfoChip(
                        Icons.location_on_outlined,
                        jobDetails!['location'],
                      ),
                    _buildInfoChip(
                      Icons.access_time,
                      _formatDate(jobDetails!['created_at']),
                    ),
                    _buildInfoChip(
                      Icons.fingerprint,
                      'ID: ${widget.jobId.substring(0, 8)}...',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Salary Section
          if (jobDetails!['salary'] != null &&
              jobDetails!['salary'].toString().isNotEmpty)
            _buildDetailSection(
              'Salary Range',
              jobDetails!['salary'],
              Icons.attach_money,
              Color(0xFF10B981),
            ),

          if (jobDetails!['salary'] != null &&
              jobDetails!['salary'].toString().isNotEmpty)
            SizedBox(height: 20),

          // Description Section
          if (jobDetails!['description'] != null &&
              jobDetails!['description'].toString().isNotEmpty)
            _buildDetailSection(
              'Job Description',
              jobDetails!['description'],
              Icons.description_outlined,
              Color(0xFF667EEA),
            ),

          if (jobDetails!['description'] != null &&
              jobDetails!['description'].toString().isNotEmpty)
            SizedBox(height: 20),

          // Requirements Section
          if (jobDetails!['requirements'] != null &&
              jobDetails!['requirements'].toString().isNotEmpty)
            _buildDetailSection(
              'Requirements',
              jobDetails!['requirements'],
              Icons.checklist_outlined,
              Color(0xFFEF4444),
            ),

          SizedBox(height: 32),

          // Apply Button (commented out as per original)
          // Container(
          //   width: double.infinity,
          //   height: 56,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text('Application feature coming soon!'),
          //           backgroundColor: Color(0xFF667EEA),
          //         ),
          //       );
          //     },
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.send, color: Colors.white),
          //         SizedBox(width: 8),
          //         Text(
          //           'Apply Now',
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ],
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Color(0xFF667EEA),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16),
          //       ),
          //       elevation: 0,
          //     ),
          //   ),
          // ),

          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF667EEA).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: Color(0xFF667EEA),
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF667EEA),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Memorial List View
class MemorialApp extends StatefulWidget {
  @override
  _MemorialAppState createState() => _MemorialAppState();
}

class _MemorialAppState extends State<MemorialApp> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> memorials = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMemorials();
  }

  // Load all memorials from Supabase
  Future<void> _loadMemorials() async {
    setState(() => isLoading = true);
    try {
      final response = await supabase
          .from('memorial')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        memorials = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Error loading memorials: $e');
    }
  }

  // Add new memorial to Supabase
  Future<void> _addMemorial(String name, int age, String description,
      DateTime deathDate, File? imageFile) async {
    try {
      setState(() => isLoading = true);

      String? imageUrl;

      // Upload image if provided
      if (imageFile != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${name.replaceAll(' ', '_')}.jpg';
        final uploadPath = await supabase.storage
            .from('memorial-images')
            .upload(fileName, imageFile);

        imageUrl =
            supabase.storage.from('memorial-images').getPublicUrl(fileName);
      }

      // Calculate birth date
      DateTime birthDate =
          DateTime(deathDate.year - age, deathDate.month, deathDate.day);

      // Insert memorial data
      await supabase.from('memorial').insert({
        'name': name,
        'birth_date': birthDate.toIso8601String().split('T')[0],
        'death_date': deathDate.toIso8601String().split('T')[0],
        'description': description,
        'image_url': imageUrl,
      });

      await _loadMemorials();
      _showSuccessSnackBar('Memorial added successfully');
    } catch (e) {
      _showErrorSnackBar('Error adding memorial: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Delete memorial from Supabase
  Future<void> _deleteMemorial(String id, String? imageUrl) async {
    try {
      setState(() => isLoading = true);

      // Delete image from storage if exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final fileName = imageUrl.split('/').last;
        await supabase.storage.from('memorial-images').remove([fileName]);
      }

      // Delete memorial record
      await supabase.from('memorial').delete().eq('id', id);

      await _loadMemorials();
      _showSuccessSnackBar('Memorial deleted successfully');
    } catch (e) {
      _showErrorSnackBar('Error deleting memorial: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Show error message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Show success message
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Calculate age from birth and death dates
  int _calculateAge(DateTime birthDate, DateTime deathDate) {
    int age = deathDate.year - birthDate.year;
    if (deathDate.month < birthDate.month ||
        (deathDate.month == birthDate.month && deathDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void _showDeleteConfirmation(Map<String, dynamic> memorial) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Memorial'),
          content: Text(
              'Are you sure you want to delete ${memorial['name']}\'s memorial?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteMemorial(memorial['id'], memorial['image_url']);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.red))
          : RefreshIndicator(
              color: Colors.red,
              onRefresh: _loadMemorials,
              child: memorials.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No memorials yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap + to add the first memorial',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: memorials.length,
                      itemBuilder: (context, index) {
                        final memorial = memorials[index];
                        final birthDate =
                            DateTime.parse(memorial['birth_date']);
                        final deathDate =
                            DateTime.parse(memorial['death_date']);
                        final age = _calculateAge(birthDate, deathDate);

                        return GestureDetector(
                          onTap: () {
                            if (kIsWeb) {
                              context.goNamed(
                                MemorialDetailScreen.routeName,
                                queryParameters: {
                                  'id': memorial['id']?.toString() ??
                                      '', // Pass the UUID as query parameter
                                }.withoutNulls,
                              );
                            } else if (Platform.isAndroid || Platform.isIOS) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MemorialDetailScreen(
                                    memorialId: memorial['id'],
                                  ),
                                ),
                              );
                            } else {
                              context.goNamed(
                                MemorialDetailScreen.routeName,
                                queryParameters: {
                                  'id': memorial['id']?.toString() ??
                                      '', // Pass the UUID as query parameter
                                }.withoutNulls,
                              );
                            }

                            context.goNamed(
                              MemorialDetailScreen.routeName,
                              queryParameters: {
                                'id': memorial['id']?.toString() ??
                                    '', // Pass the UUID as query parameter
                              }.withoutNulls,
                            );
                          },
                          onLongPress: () => _showDeleteConfirmation(memorial),
                          child: Card(
                            margin: EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: memorial['image_url'] !=
                                            null
                                        ? NetworkImage(memorial['image_url'])
                                        : null,
                                    backgroundColor: Colors.grey[200],
                                    child: memorial['image_url'] == null
                                        ? Icon(Icons.person, color: Colors.grey)
                                        : null,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          memorial['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Age: $age',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        if (memorial['description'] != null &&
                                            memorial['description']
                                                .isNotEmpty) ...[
                                          SizedBox(height: 4),
                                          Text(
                                            memorial['description'],
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ],
                                        SizedBox(height: 4),
                                        Text(
                                          DateFormat('MMM dd, yyyy')
                                              .format(deathDate),
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

class MemorialDetailScreen extends StatefulWidget {
  static String routeName = 'MemorialDetail';
  static String routePath = '/MemorialDetail';
  final String memorialId;

  const MemorialDetailScreen({
    super.key,
    required this.memorialId,
  });

  @override
  _MemorialDetailScreenState createState() => _MemorialDetailScreenState();
}

class _MemorialDetailScreenState extends State<MemorialDetailScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? memorial;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Use passed data initially, then fetch fresh data

    _loadMemorialDetails();
  }

  Future<void> _loadMemorialDetails() async {
    try {
      final response = await supabase
          .from('memorial')
          .select()
          .eq('id', widget.memorialId)
          .single();

      setState(() {
        memorial = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Error loading memorial details: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  int _calculateAge(DateTime birthDate, DateTime deathDate) {
    int age = deathDate.year - birthDate.year;
    if (deathDate.month < birthDate.month ||
        (deathDate.month == birthDate.month && deathDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String _getMemorialLink() {
    // Replace with your actual domain/base URL
    String baseUrl =
        'https://palakkadonlinenews.com'; // Change this to your actual domain
    return '$baseUrl/memorial-detail/${widget.memorialId}';
  }

  Future<void> _shareMemorial() async {
    if (memorial == null) return;

    final birthDate = DateTime.parse(memorial!['birth_date']);
    final deathDate = DateTime.parse(memorial!['death_date']);
    final age = _calculateAge(birthDate, deathDate);
    final memorialLink = _getMemorialLink();

    String shareText = """
🕊️ In Loving Memory of ${memorial!['name']} 🕊️

Born: ${DateFormat('MMM dd, yyyy').format(birthDate)}
Passed: ${DateFormat('MMM dd, yyyy').format(deathDate)}
Age: $age years

${memorial!['description'] != null && memorial!['description'].isNotEmpty ? memorial!['description'] : 'Forever in our hearts and memories.'}

View full memorial: $memorialLink

#InLovingMemory #Memorial #RIP
""";

    try {
      await Share.share(
        shareText.trim(),
        subject: 'In Memory of ${memorial!['name']}',
      );
    } catch (e) {
      _showErrorSnackBar('Error sharing memorial: $e');
    }
  }

  Future<void> _shareToWhatsApp() async {
    if (memorial == null) return;

    final birthDate = DateTime.parse(memorial!['birth_date']);
    final deathDate = DateTime.parse(memorial!['death_date']);
    final age = _calculateAge(birthDate, deathDate);
    final memorialLink = _getMemorialLink();

    String whatsappText = """🕊️ *In Loving Memory of ${memorial!['name']}* 🕊️

*Born:* ${DateFormat('MMM dd, yyyy').format(birthDate)}
*Passed:* ${DateFormat('MMM dd, yyyy').format(deathDate)}
*Age:* $age years

${memorial!['description'] != null && memorial!['description'].isNotEmpty ? memorial!['description'] : 'Forever in our hearts and memories.'}

🔗 *View full memorial:* $memorialLink

_Rest in Peace_ 🙏""";

    final Uri whatsappUri = Uri.parse(
        'whatsapp://send?text=${Uri.encodeComponent(whatsappText.trim())}');

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
      } else {
        // Fallback to regular share if WhatsApp is not installed
        await _shareMemorial();
      }
    } catch (e) {
      _showErrorSnackBar('Error sharing to WhatsApp: $e');
    }
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Share Memorial',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ShareOption(
                    icon: Icons.share,
                    label: 'Share',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pop(context);
                      _shareMemorial();
                    },
                  ),
                  _ShareOption(
                    icon: Icons.chat,
                    label: 'WhatsApp',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pop(context);
                      _shareToWhatsApp();
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (memorial == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Memorial Details'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Text('Memorial not found'),
        ),
      );
    }

    final birthDate = DateTime.parse(memorial!['birth_date']);
    final deathDate = DateTime.parse(memorial!['death_date']);
    final age = _calculateAge(birthDate, deathDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(memorial!['name']),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _showShareOptions,
            tooltip: 'Share Memorial',
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header with image and basic info
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: memorial!['image_url'] != null
                                ? NetworkImage(memorial!['image_url'])
                                : null,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: memorial!['image_url'] == null
                                ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          SizedBox(height: 16),
                          Text(
                            memorial!['name'],
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Age: $age',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Details section
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dates section
                        Card(
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Life Dates',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.cake,
                                        color: Colors.green, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Born: ${DateFormat('MMM dd, yyyy').format(birthDate)}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.favorite,
                                        color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Passed: ${DateFormat('MMM dd, yyyy').format(deathDate)}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 16),

                        // Description section
                        if (memorial!['description'] != null &&
                            memorial!['description'].isNotEmpty)
                          Card(
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'About',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    memorial!['description'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(height: 24),

                        // Full-size image if available
                        if (memorial!['image_url'] != null)
                          Card(
                            elevation: 2,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                memorial!['image_url'],
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// Missing _ShareOption widget
class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// Jobs List View

Future<List<JobItem>> _fetchJobs() async {
  await Future.delayed(Duration(seconds: 1));
  return [
    JobItem(
      id: '1',
      title: 'Software Developer',
      company: 'Tech Corp',
      location: 'Remote',
      salary: '\$80,000 - \$120,000',
      postedAt: DateTime.now(),
    ),
  ];
}

// Job Card Widget
class JobCard extends StatelessWidget {
  final JobItem job;

  JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(job.company, style: TextStyle(color: Colors.red)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(job.location, style: TextStyle(color: Colors.grey)),
                Spacer(),
                Text(job.salary,
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Memorial List View

Future<List<MemorialItem>> _fetchMemorials() async {
  await Future.delayed(Duration(seconds: 1));
  return [
    MemorialItem(
      id: '1',
      name: 'John Doe',
      age: 75,
      description: 'Beloved father and grandfather',
      imageUrl: 'https://via.placeholder.com/100x100',
      dateOfDeath: DateTime.now().subtract(Duration(days: 1)),
    ),
  ];
}

// Memorial Card Widget
class MemorialCard extends StatelessWidget {
  final MemorialItem memorial;

  MemorialCard({required this.memorial});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(memorial.imageUrl ?? ''),
              backgroundColor: Colors.grey[200],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    memorial.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Age: ${memorial.age}',
                      style: TextStyle(color: Colors.grey)),
                  Text(memorial.description),
                  Text(
                    DateFormat('MMM dd, yyyy').format(memorial.dateOfDeath),
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// News Detail Screen
class NewsDetailScreens extends StatelessWidget {
  final NewsItem news;

  NewsDetailScreens({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: news.imageUrl ?? '',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat('MMM dd, yyyy • HH:mm').format(news.publishedAt),
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Text(
                    news.description,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Saved News Screen

// Search Screen

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isLoading = false;

  Future<void> _performSearch() async {
    final String searchTerm = searchController.text.trim();

    if (searchTerm.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await SupaFlow.client
          .from('news')
          .select('id, title, content, image_url, created_at')
          .ilike('title', '%$searchTerm%') // case-insensitive LIKE
          .order('created_at', ascending: false)
          .limit(20);

      setState(() {
        searchResults = response;
        isLoading = false;
      });
    } catch (e) {
      print('Search error: $e');
      setState(() {
        searchResults = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // white background
      appBar: AppBar(
        backgroundColor: Colors.red, // red appbar
        title: const Text(
          'Search News',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter search term...',
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.black),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: _performSearch,
                  child: const Text('Search',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Results
            if (isLoading) ...[
              const CircularProgressIndicator(color: Colors.red),
            ] else if (searchResults.isEmpty) ...[
              const Text(
                'No results found.',
                style: TextStyle(color: Colors.black),
              ),
            ] else ...[
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final item = searchResults[index];
                    final createdAt = item['created_at'] != null
                        ? DateTime.tryParse(item['created_at'])?.toLocal()
                        : null;

                    return InkWell(
                      onTap: () {
                        // Handle tap if needed
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Image or Icon
                              if (item['image_url'] != null &&
                                  item['image_url'].toString().isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['image_url'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              else
                                Container(
                                  width: double.infinity,
                                  height: 180,
                                  color: Colors.red.shade100,
                                  child: const Icon(Icons.image,
                                      size: 80, color: Colors.red),
                                ),

                              const SizedBox(height: 12),

                              // Title
                              Text(
                                item['title'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Category and Date
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item['category'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  if (createdAt != null)
                                    Text(
                                      'Published: ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                                      style: const TextStyle(
                                          color: Colors.black54, fontSize: 12),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Description
                              if (item['description'] != null &&
                                  (item['description'] as String).isNotEmpty)
                                Text(
                                  item['description'],
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 14),
                                ),

                              const SizedBox(height: 8),

                              // Content preview
                              if (item['content'] != null &&
                                  (item['content'] as String).isNotEmpty)
                                Text(
                                  (item['content'] as String).length > 120
                                      ? '${(item['content'] as String).substring(0, 120)}...'
                                      : item['content'],
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                ),

                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Settings Screen

// Admin Dashboard
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Action Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActionCard(
                    'Upload News',
                    Icons.add_circle,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UploadNewsScreen()),
                    ),
                  ),
                  _buildActionCard(
                    'Add Job',
                    Icons.work_outline,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddJobScreen()),
                    ),
                  ),
                  _buildActionCard(
                    'Add Memorial',
                    Icons.person_add,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMemorialScreen()),
                    ),
                  ),
                  _buildActionCard(
                    'Analytics',
                    Icons.analytics,
                    () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.red),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(title, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.red),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Upload News Screen
class UploadNewsScreen extends StatefulWidget {
  const UploadNewsScreen({super.key});

  @override
  _UploadNewsScreenState createState() => _UploadNewsScreenState();
}

class _UploadNewsScreenState extends State<UploadNewsScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _advertisingTextController = TextEditingController();
  String _selectedCategory = 'breaking';
  // File? _selectedImage;
  // File? _selectedVideo;
  // File? _selectedAdvertisingImage;
  bool _isUploading = false;
  Uint8List? _selectedImage;
  Uint8List? _selectedVideo;
  Uint8List? _selectedAdvertisingImage;

  // Future<void> _pickVideo() async {
  //   final result = await FilePicker.platform.pickFiles(
  //     type: FileType.video,
  //     allowMultiple: false,
  //   );
  //   if (result != null && result.files.single.path != null) {
  //     setState(() {
  //       _selectedVideo = File(result.files.single.path!);
  //     });
  //   }
  // }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = bytes;
      });
    }
  }

  Future<void> _pickAdvertisingImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedAdvertisingImage = bytes;
      });
    }
  }

  Future<String?> uploadFile(
      Uint8List bytes, String folder, String fileName) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final path = '$folder/www.palakkadonlinenews.com${timestamp}$fileName';
      await supabase.storage.from('news-media').uploadBinary(path, bytes);
      final url = supabase.storage.from('news-media').getPublicUrl(path);
      return url;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<String?> _uploadAdvertisingImage(
      Uint8List bytes, String fileName) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'advertising/${timestamp}_$fileName';

      await supabase.storage.from('advertisements').uploadBinary(path, bytes);

      final url = supabase.storage.from('advertisements').getPublicUrl(path);

      return url;
    } catch (e) {
      print('Error uploading advertising image: $e');
      return null;
    }
  }

  Future<void> _uploadNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      String? imageUrl;
      String? videoUrl;
      String? advertisingImageUrl;

      // Clean the title for use in filename (remove special characters)
      String cleanTitle = _titleController.text
          .replaceAll(RegExp(r'[^\w\s-]'), '') // Remove special characters
          .replaceAll(RegExp(r'\s+'), '_') // Replace spaces with underscores
          .toLowerCase();

      if (_selectedImage != null) {
        imageUrl = await uploadFile(_selectedImage!, 'images', '.jpg');
      }

      if (_selectedVideo != null) {
        videoUrl =
            await uploadFile(_selectedVideo!, 'videos', '${cleanTitle}.mp4');
      }

      if (_selectedAdvertisingImage != null) {
        advertisingImageUrl = await _uploadAdvertisingImage(
            _selectedAdvertisingImage!, '${cleanTitle}.jpg');
      }

      await supabase.from('news').insert({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'content': _contentController.text,
        'category': _selectedCategory,
        'image_url': imageUrl,
        'video_url': videoUrl,
        'advertising_text': _advertisingTextController.text.isNotEmpty
            ? _advertisingTextController.text
            : null,
        'advertising_image_url': advertisingImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('News uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading news: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Upload News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[700]!, Colors.red[500]!, Colors.red[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 13,
        shadowColor: Colors.red.withOpacity(0.3),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              margin: EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create News Article',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Fill in the details below to publish your news',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.red.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 40,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Article Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Title Field
                  TextField(
                    controller: _titleController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'News Title *',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'Enter compelling news title...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[600]!, width: 2.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Icon(Icons.title, color: Colors.red[600], size: 20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Category *',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[600]!, width: 2.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.category,
                            color: Colors.red[600], size: 20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    dropdownColor: Colors.white,
                    items: [
                      'breaking',
                      'trending',
                      'sports',
                      'technology',
                      'health'
                    ]
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(
                                category.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value!),
                  ),

                  SizedBox(height: 20),

                  // Description Field
                  TextField(
                    controller: _descriptionController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Short Description',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'Brief summary of the news...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[600]!, width: 2.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.description,
                            color: Colors.red[600], size: 20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    maxLines: 3,
                  ),

                  SizedBox(height: 20),

                  // Content Field
                  TextField(
                    controller: _contentController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Full Content *',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'Write the complete news article here...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[600]!, width: 2.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.article,
                            color: Colors.red[600], size: 20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 8,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Advertising Section Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 40,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.campaign,
                            color: Colors.orange[600], size: 24),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Advertisement',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'Optional advertising content',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Advertising Text Field
                  TextField(
                    controller: _advertisingTextController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Advertising Text (Optional)',
                      labelStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'Enter promotional text or advertisement...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange[600]!, width: 2.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.text_fields,
                            color: Colors.orange[600], size: 20),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    maxLines: 4,
                  ),

                  SizedBox(height: 20),

                  // Advertising Image Button
                  ElevatedButton.icon(
                    onPressed: _pickAdvertisingImage,
                    icon: Icon(Icons.add_photo_alternate_outlined,
                        color: Colors.white, size: 20),
                    label: Text(
                      'Pick Advertising Image',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[600],
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: Colors.orange.withOpacity(0.3),
                    ),
                  ),

                  // Advertising Image Preview

                  _selectedAdvertisingImage != null
                      ? Image.memory(
                          _selectedAdvertisingImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                        ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Media Upload Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.red.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 40,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.perm_media,
                            color: Colors.red[600], size: 24),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Media Files',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'Add images or videos to your article',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: Icon(Icons.image_outlined,
                              color: Colors.white, size: 20),
                          label: Text(
                            'Pick Image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            shadowColor: Colors.red.withOpacity(0.3),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      // Expanded(
                      //   child: ElevatedButton.icon(
                      //     onPressed: _pickVideo,
                      //     icon: Icon(Icons.videocam_outlined,
                      //         color: Colors.white, size: 20),
                      //     label: Text(
                      //       'Pick Video',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w600,
                      //       ),
                      //     ),
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: Colors.red[600],
                      //       foregroundColor: Colors.white,
                      //       padding: EdgeInsets.symmetric(vertical: 16),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(12),
                      //       ),
                      //       elevation: 4,
                      //       shadowColor: Colors.red.withOpacity(0.3),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),

                  // Image Preview

                  // For displaying selected image from Uint8List
                  _selectedImage != null
                      ? Image.memory(
                          _selectedImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey[600],
                          ),
                        ),

// If you want to show both selected image and a placeholder

                  // Video Preview
                  if (_selectedVideo != null)
                    Container(
                      margin: EdgeInsets.only(top: 24),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[200]!, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.video_file,
                                color: Colors.white, size: 20),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Video Selected',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[700],
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Ready to upload',
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle,
                              color: Colors.red[600], size: 24),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Upload Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: _isUploading
                      ? [Colors.grey[400]!, Colors.grey[500]!]
                      : [Colors.red[600]!, Colors.red[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isUploading ? Colors.grey : Colors.red)
                        .withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isUploading ? null : _uploadNews,
                child: _isUploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Uploading News...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined,
                              color: Colors.white, size: 22),
                          SizedBox(width: 12),
                          Text(
                            'Upload News Article',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _advertisingTextController.dispose();
    super.dispose();
  }
}
//   void _pickImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _selectedImage = File(pickedFile.path));
//     }
//   }

//   void _pickVideo() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _selectedVideo = File(pickedFile.path));
//     }
//   }

//   void _uploadNews() {
//     // Implement upload functionality with Supabase
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('News uploaded successfully!')),
//     );
//     Navigator.pop(context);
//   }
// }
// Add Job Screen
// Updated AddJobScreen with complete functionality
class AddJobScreen extends StatefulWidget {
  @override
  _AddJobScreenState createState() => _AddJobScreenState();
}

class _AddJobScreenState extends State<AddJobScreen> {
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _locationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _salaryController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Job'),
        backgroundColor: Color(0xFF667EEA),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              _buildTextField(
                controller: _titleController,
                label: 'Job Title',
                icon: Icons.work_outline,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _companyController,
                label: 'Company Name',
                icon: Icons.business_outlined,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _locationController,
                label: 'Location',
                icon: Icons.location_on_outlined,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _salaryController,
                label: 'Salary Range',
                icon: Icons.attach_money_outlined,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Job Description',
                icon: Icons.description_outlined,
                maxLines: 4,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _requirementsController,
                label: 'Requirements',
                icon: Icons.checklist_outlined,
                maxLines: 3,
              ),
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addJob,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Add Job',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF667EEA),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF1E293B),
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Color(0xFF667EEA),
          ),
          labelStyle: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(0xFF667EEA),
              width: 2,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _addJob() async {
    // Validate input
    if (_titleController.text.trim().isEmpty ||
        _companyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await supabase.from('jobs').insert({
        'title': _titleController.text.trim(),
        'company': _companyController.text.trim(),
        'location': _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        'salary': _salaryController.text.trim().isEmpty
            ? null
            : _salaryController.text.trim(),
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'requirements': _requirementsController.text.trim().isEmpty
            ? null
            : _requirementsController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Job added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add job: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

// Add Memorial Screen
class AddMemorialScreen extends StatefulWidget {
  final VoidCallback? onMemorialAdded;

  AddMemorialScreen({this.onMemorialAdded});

  @override
  _AddMemorialScreenState createState() => _AddMemorialScreenState();
}

class _AddMemorialScreenState extends State<AddMemorialScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  Uint8List? _selectedImage;

  // Pick image from gallery or camera
  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    final bytes = await image.readAsBytes();
                    setState(() {
                      _selectedImage = bytes;
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    final bytes = await image.readAsBytes();
                    setState(() {
                      _selectedImage = bytes;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Select date of death
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.red),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Add memorial with validation and Supabase integration
  Future<void> _addMemorial() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter a name');
      return;
    }

    if (_ageController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter an age');
      return;
    }

    final age = int.tryParse(_ageController.text.trim());
    if (age == null || age <= 0 || age > 150) {
      _showErrorSnackBar('Please enter a valid age');
      return;
    }

    try {
      setState(() => isLoading = true);

      String? imageUrl;

      // Upload image if provided
      if (_selectedImage != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${_nameController.text.trim().replaceAll(' ', '_')}.jpg';

        await supabase.storage
            .from('memorial-images')
            .uploadBinary(fileName, _selectedImage!);

        imageUrl =
            supabase.storage.from('memorial-images').getPublicUrl(fileName);
      }

      // Calculate birth date
      DateTime birthDate = DateTime(
          _selectedDate.year - age, _selectedDate.month, _selectedDate.day);

      // Insert memorial data
      await supabase.from('memorial').insert({
        'name': _nameController.text.trim(),
        'birth_date': birthDate.toIso8601String().split('T')[0],
        'death_date': _selectedDate.toIso8601String().split('T')[0],
        'description': _descriptionController.text.trim(),
        'image_url': imageUrl,
      });

      _showSuccessSnackBar('Memorial added successfully');

      // Call callback if provided
      if (widget.onMemorialAdded != null) {
        widget.onMemorialAdded!();
      }

      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('Error adding memorial: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Show error message
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Show success message
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Memorial'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Image picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.memory(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.red,
                      ),
              ),
            ),
            SizedBox(height: 24),

            // Name field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelStyle: TextStyle(color: Colors.grey[700]),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            SizedBox(height: 16),

            // Age field
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelStyle: TextStyle(color: Colors.grey[700]),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),

            // Description field
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Memorial Message (Optional)',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                labelStyle: TextStyle(color: Colors.grey[700]),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
            SizedBox(height: 16),

            // Date picker
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date of Death',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(_selectedDate),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),

            // Add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _addMemorial,
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Adding Memorial...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Add Memorial',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
class NewsItem {
  final String id;
  final String title;
  final String description;
  final String? content;
  final String? imageUrl;
  final String? videoUrl;
  final String category;
  final DateTime publishedAt;
  final DateTime createdAt;

  NewsItem({
    required this.id,
    required this.title,
    required this.description,
    this.content,
    this.imageUrl,
    this.videoUrl,
    required this.category,
    required this.publishedAt,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'category': category,
      'published_at': publishedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
      category: json['category'],
      publishedAt: DateTime.parse(json['published_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class JobItem {
  final String id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String? description;
  final DateTime postedAt;

  JobItem({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    this.description,
    required this.postedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'salary': salary,
      'description': description,
      'posted_at': postedAt.toIso8601String(),
    };
  }

  factory JobItem.fromJson(Map<String, dynamic> json) {
    return JobItem(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      description: json['description'],
      postedAt: DateTime.parse(json['posted_at']),
    );
  }
}

class MemorialItem {
  final String id;
  final String name;
  final int age;
  final String description;
  final String? imageUrl;
  final DateTime dateOfDeath;
  final DateTime createdAt;

  MemorialItem({
    required this.id,
    required this.name,
    required this.age,
    required this.description,
    this.imageUrl,
    required this.dateOfDeath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'description': description,
      'image_url': imageUrl,
      'date_of_death': dateOfDeath.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MemorialItem.fromJson(Map<String, dynamic> json) {
    return MemorialItem(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      description: json['description'],
      imageUrl: json['image_url'],
      dateOfDeath: DateTime.parse(json['date_of_death']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

// Supabase Service Class
class SupabaseService {
  static final SupabaseClient supabase = Supabase.instance.client;

  // News operations
  static Future<List<NewsItem>> fetchNews({String? category}) async {
    try {
      var query = supabase.from('news').select();

      if (category != null && category != 'all') {
        query = query.eq('category', category);
      }

      final response = await query.order('published_at', ascending: false);

      return (response as List).map((item) => NewsItem.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching news: $e');
      return [];
    }
  }

  static Future<bool> insertNews(NewsItem news) async {
    try {
      await supabase.from('news').insert(news.toJson());
      return true;
    } catch (e) {
      print('Error inserting news: $e');
      return false;
    }
  }

  // Job operations
  static Future<List<JobItem>> fetchJobs() async {
    try {
      final response = await supabase
          .from('jobs')
          .select()
          .order('posted_at', ascending: false);

      return (response as List).map((item) => JobItem.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching jobs: $e');
      return [];
    }
  }

  static Future<bool> insertJob(JobItem job) async {
    try {
      await supabase.from('jobs').insert(job.toJson());
      return true;
    } catch (e) {
      print('Error inserting job: $e');
      return false;
    }
  }

  // Memorial operations
  static Future<List<MemorialItem>> fetchMemorials() async {
    try {
      final response = await supabase
          .from('memorials')
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => MemorialItem.fromJson(item))
          .toList();
    } catch (e) {
      print('Error fetching memorials: $e');
      return [];
    }
  }

  static Future<bool> insertMemorial(MemorialItem memorial) async {
    try {
      await supabase.from('memorials').insert(memorial.toJson());
      return true;
    } catch (e) {
      print('Error inserting memorial: $e');
      return false;
    }
  }

  // File upload
  static Future<String?> uploadFile(
      File file, String bucket, String path) async {
    try {
      await supabase.storage.from(bucket).upload(path, file);
      final url = supabase.storage.from(bucket).getPublicUrl(path);
      return url;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}
//  FFRoute(
//           name: 'NewsDetail',
//           path: '/news-detail/:id',
//           builder: (context, params) {
//             final newsItem = params.state.extra as Map<String, dynamic>?;
//             final tapTime = params.state.uri.queryParameters['tapTime'];

//             if (newsItem == null) {
//               return const Scaffold(
//                 body: Center(
//                   child: Text('No news item provided.'),
//                 ),
//               );
//             }

//             // Instead of building the Scaffold here, use your Widget class
//             return NewsDetailScreen(
//               newsItem: newsItem,
//               tapTime: tapTime,
//             );
//           },
//         ),
class AppConstants {
  static const String baseUrl = 'https://palakkadonlinenews.com';
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
