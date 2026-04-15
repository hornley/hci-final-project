class Achievement {
  final String id;
  final String title;
  final String description;
  final String assetPath; // relative asset path, may not exist yet

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.assetPath,
  });
}
