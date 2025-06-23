// Automatic FlutterFlow imports
import 'dart:ui' as img;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:palakkad_news_app/custom_code/widgets/main_screen.dart';

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

class UploadNewssScreen extends StatefulWidget {
  static String routeName = 'UploadNews';
  static String routePath = '/UploadNews';

  const UploadNewssScreen({
    super.key,
  });

  @override
  _UploadNewssScreenState createState() => _UploadNewssScreenState();
}

class _UploadNewssScreenState extends State<UploadNewssScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _advertisingTextController = TextEditingController();
  String _selectedCategory = 'breaking';
  bool _isUploading = false;
  Uint8List? _selectedImage;
  Uint8List? _selectedVideo;
  Uint8List? _selectedAdvertisingImage;
  String? _uploadedNewsId; // Store the uploaded news ID

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

  Future<String?> uploadFile(Uint8List bytes, String folder, String fileName,
      {String? customName, bool compressImage = true}) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // Use custom name if provided, otherwise use the original filename
      String finalFileName = customName ?? fileName;

      // Compress image if it's an image file and compression is enabled
      Uint8List finalBytes = bytes;
      if (compressImage && _isImageFile(fileName)) {
        finalBytes = await _compressImage(bytes);
      }

      // Create dynamic path without the static domain part
      final path = '$folder/${timestamp}_$finalFileName';

      await supabase.storage.from('news-media').uploadBinary(path, finalBytes);
      final url = supabase.storage.from('news-media').getPublicUrl(path);
      return url;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

// Helper function to check if file is an image
  bool _isImageFile(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

// Image compression function
  Future<Uint8List> _compressImage(Uint8List bytes) async {
    try {
      // Decode the image
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return bytes;

      // Resize if image is too large (maintain aspect ratio)
      const int maxWidth = 1200;
      const int maxHeight = 1200;

      if (image.width > maxWidth || image.height > maxHeight) {
        image = img.copyResize(
          image,
          width: image.width > image.height ? maxWidth : null,
          height: image.height > image.width ? maxHeight : null,
          interpolation: img.Interpolation.linear,
        );
      }

      // Compress and encode as JPEG with quality 85
      final compressedBytes = img.encodeJpg(image, quality: 85);

      print('Original size: ${bytes.length} bytes');
      print('Compressed size: ${compressedBytes.length} bytes');
      print(
          'Compression ratio: ${((bytes.length - compressedBytes.length) / bytes.length * 100).toStringAsFixed(1)}%');

      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      print('Error compressing image: $e');
      return bytes; // Return original bytes if compression fails
    }
  }

// Alternative version with more compression options
  Future<Uint8List> _compressImageAdvanced(
    Uint8List bytes, {
    int maxWidth = 1200,
    int maxHeight = 1200,
    int quality = 85,
    bool maintainFormat = false,
  }) async {
    try {
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return bytes;

      // Resize if needed
      if (image.width > maxWidth || image.height > maxHeight) {
        image = img.copyResize(
          image,
          width: image.width > image.height ? maxWidth : null,
          height: image.height > image.width ? maxHeight : null,
        );
      }

      // Choose compression format
      List<int> compressedBytes;
      if (maintainFormat) {
        // Try to maintain original format (basic implementation)
        compressedBytes = img.encodeJpg(image, quality: quality);
      } else {
        // Always use JPEG for better compression
        compressedBytes = img.encodeJpg(image, quality: quality);
      }

      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      print('Error in advanced compression: $e');
      return bytes;
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

  Future<void> _copyLink() async {
    if (_uploadedNewsId != null) {
      final newsUrl = 'https://palakkadonlinenews.com/og?id=$_uploadedNewsId';

      // Create the formatted text with title, description, and additional content
      final formattedText = '''${_titleController.text}

${_descriptionController.text.isNotEmpty ? _descriptionController.text : ''}

🔗 Read more: $newsUrl
📰 തുടർന്ന് വായിക്കാം.
ക്ലിക്ക് ചെയ്യൂ.👆

𝐉𝐨𝐢𝐧 𝐎𝐮𝐫 𝐰𝐡𝐚𝐭𝐬𝐀𝐩𝐩 𝐆𝐫𝐨𝐮𝐩 🪀
Palakkad Online News 
https://chat.whatsapp.com/G6Zj0ajnIcQ8gm1GyCDgmG

www.palakkadonlinenews.com
#News #Breaking''';

      await Clipboard.setData(ClipboardData(text: formattedText));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('News content with link copied to clipboard!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _shareLink() async {
    if (_uploadedNewsId != null) {
      final newsUrl = 'https://palakkadonlinenews.com/og?id=$_uploadedNewsId';

      // Create the formatted text with title, description, and additional content
      final formattedText = '''${_titleController.text}

${_descriptionController.text.isNotEmpty ? _descriptionController.text : ''}

🔗 Read more: $newsUrl
📰 തുടർന്ന് വായിക്കാം.
ക്ലിക്ക് ചെയ്യൂ.👆

𝐉𝐨𝐢𝐧 𝐎𝐮𝐫 𝐰𝐡𝐚𝐭𝐬𝐀𝐩𝐩 𝐆𝐫𝐨𝐮𝐩 🪀
Palakkad Online News 
https://chat.whatsapp.com/G6Zj0ajnIcQ8gm1GyCDgmG

www.palakkadonlinenews.com
#News #Breaking''';

      await Share.share(formattedText, subject: _titleController.text);
    }
  }

  Future<void> _uploadNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      if (cleanTitle.length > 50) {
        cleanTitle = cleanTitle.substring(0, 50);
      }

      if (_selectedImage != null) {
        imageUrl = await uploadFile(_selectedImage!, 'images', 'image.jpg',
            customName: 'image.jpg');
      }

      if (_selectedVideo != null) {
        videoUrl =
            await uploadFile(_selectedVideo!, 'videos', '${cleanTitle}.mp4');
      }

      if (_selectedAdvertisingImage != null) {
        advertisingImageUrl = await _uploadAdvertisingImage(
            _selectedAdvertisingImage!, '${cleanTitle}.jpg');
      }

      // Insert news and get the returned data with ID
      final response = await supabase
          .from('news')
          .insert({
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
          })
          .select('id')
          .single();

      // Store the uploaded news ID
      _uploadedNewsId = response['id'];

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('News uploaded successfully!'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'Copy Link',
              textColor: Colors.white,
              onPressed: _copyLink,
            ),
          ),
        );

        // Show success dialog with options
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading news: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success!'),
          content: Text('Your news has been published successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                });
                // Close dialog
              },
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Close dialog
                _copyLink();
              },
              child: Text('Copy Link'),
            ),
            TextButton(
              onPressed: () {
                // Close dialog
                _shareLink();
              },
              child: Text('Share'),
            ),
          ],
        );
      },
    ).then((_) {
      // After dialog is closed, navigate back
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: AppBar(
        title: Text(
          'Add New Post',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF23282D),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Title Field
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Add title',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),

            // Divider
            Container(
              height: 1,
              color: Colors.grey[300],
            ),

            SizedBox(height: 8),

            // Content Field
            Container(
              color: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _contentController,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Start writing your post here...',
                  hintStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF0073AA), width: 2),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
                maxLines: 10,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),

            SizedBox(height: 16),

            // Settings Panel
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Category
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.folder_outlined,
                            size: 20, color: Colors.grey[600]),
                        SizedBox(width: 12),
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        DropdownButton<String>(
                          value: _selectedCategory,
                          underline: SizedBox(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          items: [
                            'breaking',
                            'trending',
                            'sports',
                            'technology',
                            'health'
                          ]
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.toUpperCase()),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedCategory = value!),
                        ),
                      ],
                    ),
                  ),

                  // Excerpt
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.short_text,
                                size: 19, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Text(
                              'Excerpt',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _descriptionController,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Write an excerpt (optional)',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF0073AA)),
                            ),
                            contentPadding: EdgeInsets.all(12),
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),

                  // Featured Image
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.image_outlined,
                                size: 20, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Text(
                              'Featured Image',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        _selectedImage != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.memory(
                                      _selectedImage!,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _selectedImage = null),
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Icon(Icons.close,
                                            color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  height: 120,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[300]!,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate_outlined,
                                          size: 32, color: Colors.grey[400]),
                                      SizedBox(height: 8),
                                      Text(
                                        'Set featured image',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF0073AA),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Advertisement Section
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.campaign_outlined,
                                size: 20, color: Colors.grey[600]),
                            SizedBox(width: 12),
                            Text(
                              'Advertisement',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _advertisingTextController,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Advertisement text (optional)',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF0073AA)),
                            ),
                            contentPadding: EdgeInsets.all(12),
                          ),
                          maxLines: 3,
                        ),
                        SizedBox(height: 12),
                        _selectedAdvertisingImage != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.memory(
                                      _selectedAdvertisingImage!,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => setState(() =>
                                          _selectedAdvertisingImage = null),
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Icon(Icons.close,
                                            color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : GestureDetector(
                                onTap: _pickAdvertisingImage,
                                child: Container(
                                  height: 80,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[300]!,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate_outlined,
                                          size: 24, color: Colors.grey[400]),
                                      SizedBox(height: 4),
                                      Text(
                                        'Add advertisement image',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF0073AA),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _isUploading ? null : _uploadNews,
                      child: _isUploading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Publish',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
