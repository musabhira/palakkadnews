import 'dart:async';

import 'package:palakkad_news_app/custom_code/widgets/main_screen.dart';
import 'package:palakkad_news_app/custom_code/widgets/news_detail_screen.dart';

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


class LazyLoadingNewsWidget extends StatefulWidget {
  final String category;
  final Function(BuildContext, Map<String, dynamic>)? onNavigateToDetail;
  final Function(Map<String, dynamic>)? onShowDeleteConfirmation;

  const LazyLoadingNewsWidget({
    Key? key,
    this.category = 'all',
    this.onNavigateToDetail,
    this.onShowDeleteConfirmation,
  }) : super(key: key);

  @override
  _LazyLoadingNewsWidgetState createState() => _LazyLoadingNewsWidgetState();
}

class _LazyLoadingNewsWidgetState extends State<LazyLoadingNewsWidget> {
  late PageController _pageController;
  List<Map<String, dynamic>> _news = [];
  int _currentPage = 0;
  final int _itemsPerPage = 10;
  bool _isLoading = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = true;
  int _currentIndex = 0;
  Timer? _autoScrollTimer;
  Timer? _resumeScrollTimer;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchInitialNews();
  }

  // Fetch initial news data
  Future<void> _fetchInitialNews() async {
    setState(() {
      _isInitialLoading = true;
      _currentPage = 0;
      _news.clear();
      _hasMoreData = true;
    });

    await _fetchNews();
    
    setState(() {
      _isInitialLoading = false;
    });

    // Start auto-scroll after initial load
    if (_news.isNotEmpty) {
      _startAutoScroll();
    }
  }

  // Fetch news with pagination
  Future<void> _fetchNews() async {
    if (_isLoading || !_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = widget.category == 'all'
          ? await supabase
              .from('news')
              .select()
              .order('created_at', ascending: false)
              .range(_currentPage * _itemsPerPage, (_currentPage + 1) * _itemsPerPage - 1)
          : await supabase
              .from('news')
              .select()
              .eq('category', widget.category)
              .order('created_at', ascending: false)
              .range(_currentPage * _itemsPerPage, (_currentPage + 1) * _itemsPerPage - 1);

      final newItems = List<Map<String, dynamic>>.from(response);
      
      setState(() {
        if (newItems.length < _itemsPerPage) {
          _hasMoreData = false;
        }
        _news.addAll(newItems);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching news: $e'),
            backgroundColor: Color(0xFFE53E3E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  // Auto-scroll functionality
  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (_news.isEmpty) return;

    _autoScrollTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && mounted && !_isUserScrolling) {
        _currentIndex = (_currentIndex + 1) % _news.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _handleUserScroll() {
    if (!_isUserScrolling) {
      setState(() {
        _isUserScrolling = true;
      });
      _stopAutoScroll();

      // Resume auto-scroll after 5 seconds of no interaction
      _resumeScrollTimer?.cancel();
      _resumeScrollTimer = Timer(Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _isUserScrolling = false;
          });
          _startAutoScroll();
        }
      });
    }
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _resumeScrollTimer?.cancel();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToDetail(BuildContext context, Map<String, dynamic> newsItem) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            NewsDetailScreen(id: newsItem['id'] as String),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  Color _getCategoryColor(String? category) {
    switch (category?.toLowerCase()) {
      case 'breaking':
        return Color(0xFFFF6B6B);
      case 'sports':
        return Color(0xFF4ECDC4);
      case 'technology':
        return Color(0xFF45B7D1);
      case 'entertainment':
        return Color(0xFFFFA726);
      case 'politics':
        return Color(0xFFAB47BC);
      case 'business':
        return Color(0xFF66BB6A);
      case 'health':
        return Color(0xFFEF5350);
      default:
        return Color(0xFF667EEA);
    }
  }

  String _getCategoryEmoji(String? category) {
    switch (category?.toLowerCase()) {
      case 'breaking':
        return '🚨';
      case 'sports':
        return '⚽';
      case 'technology':
        return '💻';
      case 'entertainment':
        return '🎬';
      case 'politics':
        return '🏛️';
      case 'business':
        return '💼';
      case 'health':
        return '🏥';
      default:
        return '📰';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown date';
    }
  }

  Widget _buildNewsItem(Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF667EEA).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToDetail(context, item),
          onLongPress: widget.onShowDeleteConfirmation != null
              ? () => widget.onShowDeleteConfirmation!(item)
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              // Left side - Image
              Expanded(
                flex: 2,
                child: Container(
                  height: double.infinity,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: item['image_url'] != null
                              ? Image.network(
                                  item['image_url'],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _getCategoryColor(item['category']).withOpacity(0.3),
                                            _getCategoryColor(item['category']).withOpacity(0.1),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: _getCategoryColor(item['category']),
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            _getCategoryColor(item['category']),
                                            _getCategoryColor(item['category']).withOpacity(0.7),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _getCategoryEmoji(item['category']),
                                              style: TextStyle(fontSize: 32),
                                            ),
                                            SizedBox(height: 8),
                                            Icon(
                                              Icons.image_not_supported_outlined,
                                              size: 24,
                                              color: Colors.white.withOpacity(0.8),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _getCategoryColor(item['category']).withOpacity(0.8),
                                        _getCategoryColor(item['category']).withOpacity(0.4),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getCategoryEmoji(item['category']),
                                      style: TextStyle(fontSize: 48),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      // Category badge
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(item['category']),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _getCategoryColor(item['category']).withOpacity(0.4),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            (item['category'] ?? 'NEWS').toString().toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Right side - Content
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] ?? 'No title',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            item['content'] ?? 'No content available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(item['created_at']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF94A3B8),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF8FAFC),
            Color(0xFFE2E8F0),
          ],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _fetchInitialNews,
        color: Color(0xFF667EEA),
        backgroundColor: Colors.white,
        strokeWidth: 3,
        child: _isInitialLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF667EEA),
                ),
              )
            : _news.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.newspaper_outlined,
                          size: 48,
                          color: Color(0xFF64748B),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No news available',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      // Page indicator
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Color(0xFF667EEA).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${_currentIndex + 1} / ${_news.length}',
                                style: TextStyle(
                                  color: Color(0xFF667EEA),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // PageView
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentIndex = index;
                            });
                            _handleUserScroll();
                            
                            // Load more data when approaching the end
                            if (index >= _news.length - 3 && _hasMoreData && !_isLoading) {
                              _fetchNews();
                            }
                          },
                          itemCount: _news.length + (_hasMoreData ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= _news.length) {
                              // Loading indicator for next page
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF667EEA).withOpacity(0.08),
                                      spreadRadius: 0,
                                      blurRadius: 20,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Color(0xFF667EEA),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Loading more news...',
                                        style: TextStyle(
                                          color: Color(0xFF64748B),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            return _buildNewsItem(_news[index]);
                          },
                        ),
                      ),
                      // Loading indicator at bottom
                      if (_isLoading && _news.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF667EEA),
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Loading more...',
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 14,
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