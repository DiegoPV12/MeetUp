// lib/widgets/guests_overview/vip_guest_carousel.dart
import 'package:flutter/material.dart';
import '../../../models/guest_model.dart';

class VipGuestCarousel extends StatelessWidget {
  final List<GuestModel> guests;
  const VipGuestCarousel({super.key, required this.guests});

  @override
  Widget build(BuildContext context) {
    final vips =
        guests.where((g) => g.isVip == true).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
    if (vips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top 5 VIP', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: vips.length.clamp(0, 5),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final g = vips[i];
              final initials =
                  g.name
                      .trim()
                      .split(' ')
                      .take(2)
                      .map((p) => p[0])
                      .join()
                      .toUpperCase();
              return Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.purple.shade100,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 80,
                    child: Text(
                      g.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
