import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wardrobe_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String _selectedCategory = AppConstants.clothingCategories[0];
  String? _selectedSubcategory;
  String _selectedColor = AppConstants.clothingColors[0];
  String _selectedPattern = AppConstants.patterns[0];
  String _selectedSeason = AppConstants.seasons[0];
  final List<String> _selectedOccasions = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });

        // Analyze image with AI
        if (mounted) {
          final wardrobeProvider = Provider.of<WardrobeProvider>(context, listen: false);
          final analysis = await wardrobeProvider.analyzeImage(_imageFile!);

          if (analysis != null) {
            setState(() {
              _selectedCategory = analysis.category;
              _selectedSubcategory = analysis.subcategory;
              if (analysis.colors.isNotEmpty) {
                _selectedColor = analysis.colors.first;
              }
              _selectedPattern = analysis.pattern;
              _selectedOccasions.addAll(analysis.occasions);
            });
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: ${e.toString()}')),
      );
    }
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final wardrobeProvider = Provider.of<WardrobeProvider>(context, listen: false);

      final item = await wardrobeProvider.addClothingItem(
        userId: authProvider.user!.id,
        imageFile: _imageFile!,
        category: _selectedCategory,
        subcategory: _selectedSubcategory ?? '',
        color: _selectedColor,
        pattern: _selectedPattern,
        season: _selectedSeason,
        occasionTags: _selectedOccasions,
      );

      if (!mounted) return;

      if (item != null) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(wardrobeProvider.error ?? 'Failed to add item'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subcategories = AppConstants.subcategoriesMap[_selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Clothing Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Take Photo'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text('Tap to add photo', style: TextStyle(color: Colors.grey[600])),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Category
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: AppConstants.clothingCategories.map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _selectedSubcategory = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Subcategory
              if (subcategories.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: _selectedSubcategory,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: subcategories.map((sub) {
                    return DropdownMenuItem(value: sub, child: Text(sub));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubcategory = value;
                    });
                  },
                ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _imageFile == null ? null : _saveItem,
                child: const Text('Add to Wardrobe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
