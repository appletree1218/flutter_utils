class AudioData{
  final String fileName;
  final String path;

  const AudioData({
    required this.fileName,
    required this.path,
  });

  Map<String, Object?> toMap(){
    return {
      "file_name": fileName,
      "path": path
    };
  }

}