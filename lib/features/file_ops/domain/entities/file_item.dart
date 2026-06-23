class FileItem {
  final String path;
  final String name;
  final int sizeInBytes;

  const FileItem({
    required this.path,
    required this.name,
    required this.sizeInBytes,
  });

  double get sizeKb => sizeInBytes / 1024;
}
