class UploadedFile {
  final String filename;
  final String contentType;
  final List<int> bytes;

  UploadedFile({
    required this.filename,
    required this.contentType,
    required this.bytes,
  });
}
