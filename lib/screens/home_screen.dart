import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../services/wallpaper_service.dart';
import '../widgets/wallpaper_card.dart';
import '../widgets/prompt_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WallpaperService _wallpaperService = WallpaperService();
  List<String> _generatedImages = [];
  bool _isLoading = false;
  String? _error;
  int _selectedStyle = 0;

  final List<Map<String, String>> _stylePresets = [
    {'name': '🎨 Abstract', 'prompt': 'abstract art, vibrant colors, fluid shapes, 4K'},
    {'name': '🌌 Space', 'prompt': 'cosmic space, nebula, stars, galaxies, 4K'},
    {'name': '🏔️ Nature', 'prompt': 'nature landscape, mountains, lake, sunset, 4K'},
    {'name': '🌸 Anime', 'prompt': 'anime style, beautiful girl, cherry blossoms, 4K'},
    {'name': '🔥 Cyberpunk', 'prompt': 'cyberpunk city, neon lights, rain, 4K'},
    {'name': '🌊 Ocean', 'prompt': 'ocean waves, underwater, coral reef, 4K'},
    {'name': '⭐ Minimalist', 'prompt': 'minimalist, simple, clean background, 4K'},
    {'name': '🦋 Fantasy', 'prompt': 'fantasy world, magical, castle, dragons, 4K'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Wallpaper',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Create stunning wallpapers',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C5CE7).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 16, color: Color(0xFF6C5CE7)),
                        SizedBox(width: 4),
                        Text(
                          'Free',
                          style: TextStyle(
                            color: Color(0xFF6C5CE7),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Style presets
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _stylePresets.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedStyle == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedStyle = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6C5CE7)
                            : const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6C5CE7)
                              : const Color(0xFF333333),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _stylePresets[index]['name']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFFAAAAAA),
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Prompt input
            PromptInput(
              initialPrompt: _stylePresets[_selectedStyle]['prompt']!,
              onGenerate: _generateWallpaper,
              isLoading: _isLoading,
            ),

            const SizedBox(height: 16),

            // Generated images
            Expanded(
              child: _generatedImages.isEmpty && !_isLoading
                  ? _buildEmptyState()
                  : _buildImageGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 48,
              color: Color(0xFF6C5CE7),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No wallpapers yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter a prompt and tap Generate\nto create AI wallpapers',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF888888),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: _generatedImages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isLoading && index == 0) {
          return _buildLoadingCard();
        }
        final imageIndex = _isLoading ? index - 1 : index;
        return WallpaperCard(
          imageUrl: _generatedImages[imageIndex],
          onFavorite: () => _toggleFavorite(_generatedImages[imageIndex]),
          onSetWallpaper: () => _setWallpaper(_generatedImages[imageIndex]),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1A1A1A),
      highlightColor: const Color(0xFF2A2A2A),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF6C5CE7)),
              SizedBox(height: 12),
              Text(
                'Generating...',
                style: TextStyle(color: Color(0xFF888888), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateWallpaper(String prompt) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Simulate API call - replace with real API
      await Future.delayed(const Duration(seconds: 2));
      final newImage = _wallpaperService.generatePlaceholderImage(prompt);

      setState(() {
        _generatedImages.insert(0, newImage);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _toggleFavorite(String imageUrl) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to favorites!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _setWallpaper(String imageUrl) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Set as Wallpaper',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _buildWallpaperOption(Icons.home, 'Home Screen'),
            _buildWallpaperOption(Icons.lock, 'Lock Screen'),
            _buildWallpaperOption(Icons.phone_android, 'Both'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF888888)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallpaperOption(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6C5CE7)),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label wallpaper set!')),
        );
      },
    );
  }
}
