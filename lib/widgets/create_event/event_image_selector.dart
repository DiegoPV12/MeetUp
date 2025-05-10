import 'package:flutter/material.dart';

class EventImageSelector extends StatelessWidget {
  final String? selectedImage;
  final Function(String) onImageSelected;

  const EventImageSelector({
    super.key,
    required this.selectedImage,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> availableImages = [
      '1.png',
      '2.png',
      '3.png',
      '4.png',
      '5.png',
      '6.png',
      '7.png',
    ];

    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona una imagen:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableImages.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final imageName = availableImages[index];
              return GestureDetector(
                onTap: () => onImageSelected(imageName),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          selectedImage == imageName
                              ? Colors.blue
                              : cs.secondary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.asset(
                    'assets/images/$imageName',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
