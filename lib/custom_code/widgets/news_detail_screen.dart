import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palakkad_news_app/custom_code/widgets/main_screen.dart';
import 'package:palakkad_news_app/flutter_flow/flutter_flow_util.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:js' as js;

class NewsDetailScreen extends StatefulWidget {
  static String routeName = 'NewsDetail';
  static String routePath = '/NewsDetail';
  final String? id;

  const NewsDetailScreen({
    super.key,
    this.id,
  });

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  String? linkTapTime;
  Map<String, dynamic>? newsItem; // Store the fetched news item
  bool isLoading = true;
  String? error;
  List<Map<String, dynamic>> news = [];

  // Get Supabase client
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchNewsDetail();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    try {
      final response = 'breaking' == 'all'
          ? await supabase
              .from('news')
              .select()
              .order('created_at', ascending: false)
          : await supabase
              .from('news')
              .select()
              .eq('category', 'breaking')
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

  // Fetch news detail from Supabase
  Future<void> _fetchNewsDetail() async {
    if (widget.id == null || widget.id!.isEmpty) {
      setState(() {
        error = 'No news ID provided';
        isLoading = false;
      });
      return;
    }

    try {
      print('Fetching news with ID: ${widget.id}'); // Debug log

      final response =
          await supabase.from('news').select('*').eq('id', widget.id!).single();

      print('News fetched successfully: ${response['title']}'); // Debug log

      setState(() {
        newsItem = response;
        isLoading = false;
        error = null;
      });
    } on PostgrestException catch (e) {
      print('Supabase error: ${e.message}'); // Debug log
      setState(() {
        if (e.code == 'PGRST116') {
          error = 'News article not found';
        } else {
          error = 'Database error: ${e.message}';
        }
        isLoading = false;
      });
    } catch (e) {
      print('General error: $e'); // Debug log
      setState(() {
        error = 'Failed to load news: ${e.toString()}';
        isLoading = false;
      });
    }
  }

// Replace your existing methods with these simplified versions:

// 1. Replace your _shareToWhatsApp method with this:
  void _updateMetaTags() {
    if (newsItem == null || !kIsWeb) return;

    try {
      final title = newsItem!['title'] ?? 'Palakkad News';
      final description =
          newsItem!['description'] ?? 'Latest news from Palakkad';
      final imageUrl = newsItem!['image_url'] ??
          'https://vfwdnzztsvtapbrjvkxi.supabase.co/storage/v1/object/public/news-media/images/1749461191787_palkkad%20news%20logo.jpg';
      final newsUrl =
          '${AppConstants.baseUrl}/NewsDetail?id=${newsItem!['id']}';

      // Use JavaScript interop to call the window function
      js.context.callMethod('updateNewsMetaTags', [
        js.JsObject.jsify({
          'title': title,
          'description': description,
          'image_url': imageUrl,
          'url': newsUrl,
        })
      ]);

      print('Meta tags updated for: $title');
    } catch (e) {
      print('Error updating meta tags: $e');
    }
  }

  void _updateMetaTag(String attribute, String attributeValue, String content) {
    try {
      // Find existing meta tag
      final existingTag =
          html.document.querySelector('meta[$attribute="$attributeValue"]');

      if (existingTag != null) {
        // Update existing tag
        existingTag.setAttribute('content', content);
      } else {
        // Create new meta tag
        final metaTag = html.MetaElement();
        metaTag.setAttribute(attribute, attributeValue);
        metaTag.setAttribute('content', content);
        html.document.head?.append(metaTag);
      }
    } catch (e) {
      print('Error updating meta tag $attributeValue: $e');
    }
  }

  // Update your _fetchNewsDetail method to call _updateMetaTags
  // Future<void> _fetchNewsDetail() async {
  //   if (widget.id == null || widget.id!.isEmpty) {
  //     setState(() {
  //       error = 'No news ID provided';
  //       isLoading = false;
  //     });
  //     return;
  //   }

  //   try {
  //     print('Fetching news with ID: ${widget.id}');

  //     final response =
  //         await supabase.from('news').select('*').eq('id', widget.id!).single();

  //     print('News fetched successfully: ${response['title']}');

  //     setState(() {
  //       newsItem = response;
  //       isLoading = false;
  //       error = null;
  //     });

  //     // Update meta tags after successful fetch
  //     _updateMetaTags();
  //   } on PostgrestException catch (e) {
  //     print('Supabase error: ${e.message}');
  //     setState(() {
  //       if (e.code == 'PGRST116') {
  //         error = 'News article not found';
  //       } else {
  //         error = 'Database error: ${e.message}';
  //       }
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     print('General error: $e');
  //     setState(() {
  //       error = 'Failed to load news: ${e.toString()}';
  //       isLoading = false;
  //     });
  //   }
  // }

  // Enhanced share methods with better meta tag handling
  Future<void> _shareToWhatsApp() async {
    if (newsItem == null) return;

    try {
      final String newsUrl =
          '${AppConstants.baseUrl}/NewsDetail?id=${newsItem!['id']}';
      final String shareText = '''📰 ${newsItem!['title']}

${newsItem!['description'] ?? ''}

🔗 Read more: $newsUrl''';

      if (newsItem!['image_url'] != null && newsItem!['image_url'].isNotEmpty) {
        _showLoadingDialog();

        final imageFile = await _downloadImage(newsItem!['image_url']);
        Navigator.of(context).pop();

        if (imageFile != null) {
          await Share.shareXFiles([XFile(imageFile.path)], text: shareText);
          _showSnackBar('Shared with image to WhatsApp!', Colors.green);
          imageFile.delete().catchError((e) => print('Cleanup error: $e'));
        } else {
          _shareTextToWhatsApp(shareText);
        }
      } else {
        _shareTextToWhatsApp(shareText);
      }
    } catch (e) {
      if (Navigator.canPop(context)) Navigator.of(context).pop();
      _showSnackBar('Error sharing to WhatsApp', Colors.red);
    }
  }

  Future<void> _shareToWhatsAppWeb() async {
    if (newsItem == null) return;

    final String newsUrl = '${AppConstants.baseUrl}/og?id=${newsItem!['id']}';

    final String shareText = '''📰 ${newsItem!['title']}
  
${newsItem!['description'] ?? ''}



🔗 Read more: $newsUrl''';

    final String whatsappUrl =
        'https://wa.me/?text=${Uri.encodeComponent(shareText)}';

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl),
          mode: LaunchMode.externalApplication);
      _showSnackBar('Opened WhatsApp for sharing!', Colors.green);
    } else {
      _showSnackBar('Could not open WhatsApp', Colors.red);
    }
  }

  String generateDynamicNewsUrl() {
    final String newsId = newsItem!['id'];
    final String title = Uri.encodeComponent(newsItem!['title'] ?? '');
    final String description =
        Uri.encodeComponent(newsItem!['description'] ?? '');
    final String imageUrl = Uri.encodeComponent(newsItem!['image_url'] ?? '');

    // This URL should return proper Open Graph meta tags
    return 'https://palakkadonlinenews.com/NewsDetail?id=$newsId&title=$title&desc=$description&img=$imageUrl';
  }

  // Add a method to generate shareable link with proper meta tags
  String _generateShareableLink() {
    if (newsItem == null) return '${AppConstants.baseUrl}';
    return '${AppConstants.baseUrl}/og?id=${newsItem!['id']}';
  }

// Enhanced copy link with comprehensive data
  Future<void> _copyLink() async {
    if (newsItem == null) return;

    try {
      // 🔗 Generate the OG preview link
      final String newsUrl = _generateShareableLink();

      final String shareText = '''📰 ${newsItem!['title']}

${newsItem!['description'] ?? ''}....

🔗 Read more: $newsUrl
📰 തുടർന്ന് വായിക്കാം.
ക്ലിക്ക് ചെയ്യൂ.👆

𝐉𝐨𝐢𝐧 𝐎𝐮𝐫 𝐰𝐡𝐚𝐭𝐬𝐀𝐩𝐩 𝐆𝐫𝐨𝐮𝐩 🪀
Palakkad Online News 
https://chat.whatsapp.com/G6Zj0ajnIcQ8gm1GyCDgmG

www.palakkadonlinenews.com
#News #Breaking''';

      await Clipboard.setData(ClipboardData(text: shareText));

      _showSnackBar('Complete news data copied to clipboard!', Colors.blue);
    } catch (e) {
      _showSnackBar('Error copying data', Colors.red);
    }
  }

  Future<void> copyDynamicLink() async {
    final String dynamicUrl = generateDynamicNewsUrl();
    await Clipboard.setData(ClipboardData(text: dynamicUrl));
    _showSnackBar('Link copied! Paste in WhatsApp to see preview', Colors.blue);
  }

// 2. Helper method for WhatsApp text-only sharing
  Future<void> _shareTextToWhatsApp(String text) async {
    try {
      const whatsappUrl = 'whatsapp://send?text=';
      final encodedText = Uri.encodeComponent(text);
      final fullUrl = whatsappUrl + encodedText;

      if (await canLaunchUrl(Uri.parse(fullUrl))) {
        await launchUrl(Uri.parse(fullUrl));
      } else {
        await Share.share(text);
      }
      _showSnackBar('Shared to WhatsApp!', Colors.green);
    } catch (e) {
      _showSnackBar('Error sharing text', Colors.red);
    }
  }

// 4. Add these new methods to your class:
  Future<File?> _downloadImage(String imageUrl) async {
    try {
      print('📥 Downloading: $imageUrl');

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) return null;

      final tempDir = await getTemporaryDirectory();
      final fileName =
          'news_${newsItem!['id']}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${tempDir.path}/$fileName');

      await file.writeAsBytes(response.bodyBytes);
      print('✅ Image saved: ${file.path}');

      return file;
    } catch (e) {
      print('❌ Download error: $e');
      return null;
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
              ),
              SizedBox(height: 16),
              Text(
                'Preparing image...',
                style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ),
    );
  }

// 5. Remove your old _shareWithImage method entirely - it's no longer needed!

// 6. Optional: Add a test button to verify image sharing works
  Widget _buildTestShareButton() {
    return ElevatedButton(
      onPressed: () async {
        const testUrl =
            'https://vfwdnzztsvtapbrjvkxi.supabase.co/storage/v1/object/public/news-media/images/1749470900614_image.jpg';

        _showLoadingDialog();
        final file = await _downloadImage(testUrl);
        Navigator.of(context).pop();

        if (file != null) {
          await Share.shareXFiles([XFile(file.path)],
              text: 'Test image from Supabase!');
          file.delete().catchError((e) => null);
          _showSnackBar('Test successful!', Colors.green);
        } else {
          _showSnackBar('Test failed!', Colors.red);
        }
      },
      child: Text('Test Image Share'),
    );
  }

  // Future<void> _copyLink() async {
  //   if (newsItem == null) return;

  //   try {
  //     final link = '${AppConstants.baseUrl}/NewsDetail?id=${newsItem!['id']}';
  //     await Clipboard.setData(ClipboardData(text: link));
  //     _showSnackBar('Link copied to clipboard!', Colors.blue);
  //   } catch (e) {
  //     _showSnackBar('Error copying link', Colors.red);
  //   }
  // }

  Future<void> _shareGeneral() async {
    if (newsItem == null) return;

    try {
      final String newsUrl =
          '${AppConstants.baseUrl}/NewsDetail?id=${newsItem!['id']}';

      final String shareText = '''
📰 ${newsItem!['title']}

${newsItem!['description'] ?? ''}

🔗 Read more: $newsUrl
      '''
          .trim();

      // Try to share with image if available
      if (newsItem!['image_url'] != null && newsItem!['image_url'].isNotEmpty) {
        await _shareWithImage(shareText, newsItem!['image_url'], 'general');
      } else {
        await Share.share(shareText);
      }
    } catch (e) {
      _showSnackBar('Error sharing content', Colors.red);
    }
  }

  // New method to handle image sharing
  Future<void> _shareWithImage(
      String text, String imageUrl, String platform) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
                ),
                SizedBox(height: 16),
                Text(
                  'Preparing to share...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Download image to temporary directory
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'news_${newsItem!['id']}.jpg';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      // Close loading dialog
      Navigator.pop(context);

      // Share with image
      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );

      _showSnackBar('Shared with image successfully!', Colors.green);
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Fallback to text-only sharing
      if (platform == 'whatsapp') {
        const whatsappUrl = 'whatsapp://send?text=';
        final encodedText = Uri.encodeComponent(text);
        final fullUrl = whatsappUrl + encodedText;

        if (await canLaunchUrl(Uri.parse(fullUrl))) {
          await launchUrl(Uri.parse(fullUrl));
        } else {
          await Share.share(text);
        }
      } else {
        await Share.share(text);
      }

      _showSnackBar('Shared as text (image failed to load)', Colors.orange);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Share News',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: Color(0xFF25D366),
                  onTap: _shareToWhatsApp,
                ),
                _buildShareOption(
                  icon: Icons.chat,
                  label: 'WhatsApp web',
                  color: Color(0xFF25D366),
                  onTap: _shareToWhatsAppWeb,
                ),
                _buildShareOption(
                  icon: Icons.link,
                  label: 'Copy Link',
                  color: Color(0xFF667EEA),
                  onTap: _copyLink,
                ),
                _buildShareOption(
                  icon: Icons.share,
                  label: 'Share',
                  color: Color(0xFF64748B),
                  onTap: copyDynamicLink,
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: isLoading
          ? _buildLoadingState()
          : error != null
              ? _buildErrorState()
              : newsItem != null
                  ? _buildNewsContent()
                  : _buildNotFoundState(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667EEA)),
          ),
          SizedBox(height: 14),
          Text(
            'Loading news...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Color(0xFFEF4444),
          ),
          SizedBox(height: 16),
          Text(
            'Error',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLoading = true;
                error = null;
              });
              _fetchNewsDetail();
            },
            child: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF667EEA),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildNotFoundState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 79,
            color: Color(0xFF94A3B8),
          ),
          SizedBox(height: 16),
          Text(
            'News Not Found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The news article you\'re looking for doesn\'t exist.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 50,
          pinned: true,
          backgroundColor: Color(0xFF667EEA),
          iconTheme: IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (kIsWeb) {
                // On Web → go to Home
                context.go('/');
              } else if (Platform.isAndroid ||
                  Platform.isIOS ||
                  Platform.isWindows ||
                  Platform.isMacOS ||
                  Platform.isLinux) {
                // On Mobile/Desktop → just pop
                Navigator.pop(context);
              } else {
                // Fallback → go to Home
                context.go('/');
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: _showShareOptions,
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
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
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Link Tap Time Display
                      if (linkTapTime != null) ...[
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFF667EEA).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF667EEA).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 16,
                                color: Color(0xFF667EEA),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Opened: $linkTapTime',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF667EEA),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/palakkadnewspic.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.7),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Palakkad News',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 248, 11, 31),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: SimplePageViewNewsWidget(
                          news: news,
                          onRefresh: _fetchNews,
                        ),
                      ),
                      SizedBox(height: 18),
                      if (newsItem!['image_url'] != null)
                        Image.network(
                          newsItem!['image_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
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
                                  Icons.image_not_supported_outlined,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 16),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(newsItem!['category'])
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_getCategoryEmoji(newsItem!['category'])} ${newsItem!['category'].toString().toUpperCase()}',
                          style: TextStyle(
                            color: _getCategoryColor(newsItem!['category']),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      Text(
                        newsItem!['title'] ?? 'No Title',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 18,
                            color: Color(0xFF94A3B8),
                          ),
                          SizedBox(width: 8),
                          Text(
                            _formatDate(newsItem!['created_at']),
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (newsItem!['description'] != null &&
                          newsItem!['description'].isNotEmpty) ...[
                        SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            newsItem!['description'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF475569),
                              height: 1.6,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 32),
                      Text(
                        'Full Story',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        newsItem!['content'] ?? 'No content available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF475569),
                          height: 1.7,
                        ),
                      ),
                      SizedBox(height: 38),

                      // Share Button at the bottom
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _showShareOptions,
                          icon: Icon(Icons.share, color: Colors.white),
                          label: Text(
                            'Share this news',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF667EEA),
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      if (newsItem!['advertising_text'] != null)
                        Text(
                          newsItem!['advertising_text'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF475569),
                            height: 1.7,
                          ),
                        ),
                      SizedBox(height: 10),
                      if (newsItem!['advertising_image_url'] != null)
                        Image.network(
                          newsItem!['advertising_image_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
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
                                  Icons.image_not_supported_outlined,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

// Make sure you have AppConstants defined somewhere in your project
class SimplePageViewNewsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> news;
  final Function(BuildContext, Map<String, dynamic>)? onNavigateToDetail;
  final Function(Map<String, dynamic>)? onShowDeleteConfirmation;
  final Future<void> Function() onRefresh;

  const SimplePageViewNewsWidget({
    Key? key,
    required this.news,
    this.onNavigateToDetail,
    this.onShowDeleteConfirmation,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _SimplePageViewNewsWidgetState createState() =>
      _SimplePageViewNewsWidgetState();
}

class _SimplePageViewNewsWidgetState extends State<SimplePageViewNewsWidget> {
  late PageController _pageController;
  int _currentIndex = 0;
  Timer? _autoScrollTimer;
  Timer? _resumeScrollTimer;
  bool _isLoading = false;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (widget.news.isEmpty) return;

    _autoScrollTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_pageController.hasClients && mounted && !_isUserScrolling) {
        _currentIndex = (_currentIndex + 1) % widget.news.length;
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

      // Resume auto-scroll after 6 seconds of no interaction
      _resumeScrollTimer?.cancel();
      _resumeScrollTimer = Timer(Duration(seconds: 2), () {
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
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          await widget.onRefresh();
          setState(() {
            _isLoading = false;
          });
        },
        color: Color(0xFF667EEA),
        backgroundColor: Colors.white,
        strokeWidth: 3,
        child: Column(
          children: [
            // Header

            // PageView Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF667EEA),
                      ),
                    )
                  : widget.news.isEmpty
                      ? Center(
                          child: Text(
                            'No news available',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            // PageView
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                  // Handle user interaction
                                  _handleUserScroll();
                                },
                                itemCount: widget.news.length,
                                itemBuilder: (context, index) {
                                  final item = widget.news[index];
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF667EEA)
                                              .withOpacity(0.08),
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
                                        onTap: () =>
                                            _navigateToDetail(context, item),
                                        onLongPress: widget
                                                    .onShowDeleteConfirmation !=
                                                null
                                            ? () => widget
                                                .onShowDeleteConfirmation!(item)
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
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(16),
                                                        bottomLeft:
                                                            Radius.circular(16),
                                                      ),
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        child:
                                                            item['image_url'] !=
                                                                    null
                                                                ? Image.network(
                                                                    item[
                                                                        'image_url'],
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    loadingBuilder:
                                                                        (context,
                                                                            child,
                                                                            loadingProgress) {
                                                                      if (loadingProgress ==
                                                                          null)
                                                                        return child;
                                                                      return Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                            colors: [
                                                                              _getCategoryColor(item['category']).withOpacity(0.3),
                                                                              _getCategoryColor(item['category']).withOpacity(0.1),
                                                                            ],
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                _getCategoryColor(item['category']),
                                                                            strokeWidth:
                                                                                2,
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                            colors: [
                                                                              _getCategoryColor(item['category']),
                                                                              _getCategoryColor(item['category']).withOpacity(0.7),
                                                                            ],
                                                                            begin:
                                                                                Alignment.topLeft,
                                                                            end:
                                                                                Alignment.bottomRight,
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
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
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      gradient:
                                                                          LinearGradient(
                                                                        colors: [
                                                                          _getCategoryColor(item['category'])
                                                                              .withOpacity(0.8),
                                                                          _getCategoryColor(item['category'])
                                                                              .withOpacity(0.4),
                                                                        ],
                                                                        begin: Alignment
                                                                            .topLeft,
                                                                        end: Alignment
                                                                            .bottomRight,
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        _getCategoryEmoji(
                                                                            item['category']),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                48),
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
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _getCategoryColor(
                                                              item['category']),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: _getCategoryColor(
                                                                      item[
                                                                          'category'])
                                                                  .withOpacity(
                                                                      0.4),
                                                              blurRadius: 8,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Text(
                                                          (item['category'] ??
                                                                  'NEWS')
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Title
                                                        Text(
                                                          item['title'] ??
                                                              'No title',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF1E293B),
                                                            height: 1.3,
                                                          ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),

                                                        SizedBox(height: 2),

                                                        // Description
                                                        if (item['description'] !=
                                                                null &&
                                                            item['description']
                                                                .toString()
                                                                .trim()
                                                                .isNotEmpty)
                                                          Text(
                                                            item['description'],
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xFF64748B),
                                                              height: 1.5,
                                                            ),
                                                            maxLines: 4,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                      ],
                                                    ),

                                                    // Footer with time and read more
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                        0xFF667EEA)
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6),
                                                              ),
                                                              child: Icon(
                                                                Icons
                                                                    .access_time_rounded,
                                                                size: 12,
                                                                color: Color(
                                                                    0xFF667EEA),
                                                              ),
                                                            ),
                                                            SizedBox(width: 2),
                                                            Text(
                                                              _formatDate(item[
                                                                  'created_at']),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Color(
                                                                    0xFF64748B),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 2),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xFF667EEA),
                                                                Color(
                                                                    0xFF764BA2)
                                                              ],
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                        0xFF667EEA)
                                                                    .withOpacity(
                                                                        0.3),
                                                                blurRadius: 8,
                                                                offset: Offset(
                                                                    0, 4),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                'Read More',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  width: 2),
                                                              Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                size: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ],
                                                          ),
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
                                },
                              ),
                            ),

                            // Page Indicators
                            if (widget.news.length > 1)
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    widget.news.length,
                                    (index) => AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 4),
                                      width: _currentIndex == index ? 24 : 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        gradient: _currentIndex == index
                                            ? LinearGradient(
                                                colors: [
                                                  Color(0xFF667EEA),
                                                  Color(0xFF764BA2)
                                                ],
                                              )
                                            : null,
                                        color: _currentIndex == index
                                            ? null
                                            : Color(0xFF667EEA)
                                                .withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
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
