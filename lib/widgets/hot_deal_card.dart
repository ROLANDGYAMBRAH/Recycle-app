import 'package:flutter/material.dart';

class HotDealCard extends StatelessWidget {
  const HotDealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Compounder image (replace with dynamic in future)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/compounder_profile.png',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Kwame Compounder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 4),
                Text('Buys Pure Water Rubber', style: TextStyle(fontSize: 13, color: Colors.black87)),
                SizedBox(height: 2),
                Text('GHS 1.40 per kg • Adabraka', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          // Chevron
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
