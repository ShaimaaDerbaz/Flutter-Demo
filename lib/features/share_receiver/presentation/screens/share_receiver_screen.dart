import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ShareReceiverScreen extends StatefulWidget {
  final List<SharedMediaFile> files;

  const ShareReceiverScreen({super.key, required this.files});

  @override
  State<ShareReceiverScreen> createState() => _ShareReceiverScreenState();
}

class _ShareReceiverScreenState extends State<ShareReceiverScreen> {
  int _currentIndex = 0;

  SharedMediaFile get _currentFile => widget.files[_currentIndex];

  bool get _isPdf {
    final path = _currentFile.path.toLowerCase();
    final mime = _currentFile.mimeType?.toLowerCase() ?? '';
    return path.endsWith('.pdf') || mime.contains('pdf');
  }

  String get _fileName => _currentFile.path.split('/').last;

  void _prev() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  void _next() {
    if (_currentIndex < widget.files.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          _fileName,
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (widget.files.length > 1) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: _currentIndex > 0 ? _prev : null,
            ),
            Center(
              child: Text(
                '${_currentIndex + 1} / ${widget.files.length}',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
              onPressed: _currentIndex < widget.files.length - 1 ? _next : null,
            ),
          ],
        ],
      ),
      body: _isPdf ? _PdfViewer(path: _currentFile.path) : _ImageViewer(path: _currentFile.path),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final String path;

  const _ImageViewer({required this.path});

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    if (!file.existsSync()) {
      return const Center(
        child: Text('File not found', style: TextStyle(color: Colors.white)),
      );
    }
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 5,
      child: Center(
        child: Image.file(file, fit: BoxFit.contain),
      ),
    );
  }
}

class _PdfViewer extends StatefulWidget {
  final String path;

  const _PdfViewer({required this.path});

  @override
  State<_PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<_PdfViewer> {
  int _totalPages = 0;
  int _currentPage = 0;
  bool _isReady = false;
  PDFViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PDFView(
          filePath: widget.path,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          onRender: (pages) => setState(() {
            _totalPages = pages ?? 0;
            _isReady = true;
          }),
          onViewCreated: (controller) => _controller = controller,
          onPageChanged: (page, _) => setState(() => _currentPage = page ?? 0),
          onError: (e) => debugPrint('PDF error: $e'),
        ),
        if (!_isReady)
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        if (_isReady && _totalPages > 0)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: _currentPage > 0
                      ? () => _controller?.setPage(_currentPage - 1)
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentPage + 1} / $_totalPages',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: _currentPage < _totalPages - 1
                      ? () => _controller?.setPage(_currentPage + 1)
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
