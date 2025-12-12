import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;

  String? _publicImageUrl;
  bool _isUploading = false;

  Future<void> _pickAndUploadToPublicBucket() async {
    final picker = ImagePicker();
    //memanggil library membuka folder dll
    final picked = await picker.pickImage(source: ImageSource.gallery);
    // jika diambil maka mempunyai nilai
    // jika tidak di ambil tdk ada nilai atau null
    if (picked == null) return;
    // karena sudah di ambil diberikan status proses uploading
    // _isuploading jadi true
    setState(() => _isUploading = true);

    //mulai persiapan mengirim image
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
      final filePath = 'uploads/$fileName';

      // mengecek apakah menggunakan web
      if (kIsWeb) {
        //khusus untuk di web
        final bytes = await picked.readAsBytes();
        await supabase.storage
            .from('bucket_images')
            .uploadBinary(
              filePath,
              bytes,
              fileOptions: const FileOptions(
                contentType: 'image/png', // atau image/png sesuai kebutuhan
              ),
            );
      } else {
        // sama dengan code sebelumnya
        final file = File(picked.path);
        // upload ke bucket public
        await supabase.storage.from('bucket_images').upload(filePath, file);
      }

      //ambil public URL
      final publicUrl = supabase.storage
          .from('bucket_images')
          .getPublicUrl(filePath);
      setState(() {
        _publicImageUrl = publicUrl;
      });
    } catch (e) {
      debugPrint('Error upload: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal upload: $e')));
      }
      // Final ini jika semua proses diatas sudah selesai
      // baik gagal atau berhasil lakukan printah ini
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Image Upload')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_isUploading) const LinearProgressIndicator(),
            const SizedBox(height: 16),

            // Button untuk pilih image
            ElevatedButton(
              onPressed: _isUploading ? null : _pickAndUploadToPublicBucket,
              child: const Text('Pilih & Upload Gambar'),
            ),

            const SizedBox(height: 24),

            if (_publicImageUrl != null) ...[
              const Text('Gambar dari Public URL:'),
              const SizedBox(height: 8),

              Expanded(child: Image.network(_publicImageUrl!)),

              const SizedBox(height: 8),

              SelectableText(
                _publicImageUrl!,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
