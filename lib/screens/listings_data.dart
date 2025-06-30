import 'package:flutter/material.dart';

class Listing {
  final String id;
  final String title;
  final String category; // Plastic | Glass | Paper | Metal
  final String price;
  final String image;
  final double rating;
  final int ratingCount;
  final String region;

  const Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.image,
    required this.rating,
    required this.ratingCount,
    required this.region,
  });
}

const kAllListings = <Listing>[
  // Plastic
  Listing(
    id: 'pwr-1',
    title: 'Pure Water Rubbers',
    category: 'Plastic',
    price: 'GHS 1.00 per kg',
    image: 'assets/images/blue_bag.png',
    rating: 4.9,
    ratingCount: 345,
    region: 'Greater Accra',
  ),
  Listing(
    id: 'pb-1',
    title: 'Plastic Bottle',
    category: 'Plastic',
    price: 'GHS 0.90 per kg',
    image: 'assets/images/blue_bag.png',
    rating: 4.8,
    ratingCount: 210,
    region: 'Ashanti',
  ),

  // Glass
  Listing(
    id: 'gl-1',
    title: 'Green Glass Bottles',
    category: 'Glass',
    price: 'GHS 1.60 per kg',
    image: 'assets/images/glass.png',
    rating: 4.7,
    ratingCount: 120,
    region: 'Volta',
  ),

  // Paper
  Listing(
    id: 'pa-1',
    title: 'Old Newspapers',
    category: 'Paper',
    price: 'GHS 0.50 per kg',
    image: 'assets/images/paper.png',
    rating: 4.6,
    ratingCount: 90,
    region: 'Central',
  ),

  // Metal
  Listing(
    id: 'me-1',
    title: 'Aluminium Cans',
    category: 'Metal',
    price: 'GHS 2.20 per kg',
    image: 'assets/images/metal.png',
    rating: 4.9,
    ratingCount: 510,
    region: 'Greater Accra',
  ),
];
