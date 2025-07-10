import 'dart:math';

class UsernameService {
  static final List<String> _adjectives = [
    'Awesome', 'Brilliant', 'Creative', 'Dynamic', 'Epic', 'Fantastic', 
    'Galactic', 'Heroic', 'Incredible', 'Jazzy', 'Kinetic', 'Legendary',
    'Magical', 'Noble', 'Outstanding', 'Phenomenal', 'Quantum', 'Radiant',
    'Stellar', 'Terrific', 'Ultimate', 'Vibrant', 'Wonderful', 'Xtra',
    'Youthful', 'Zesty', 'Cosmic', 'Electric', 'Mystic', 'Phoenix'
  ];

  static final List<String> _nouns = [
    'Explorer', 'Adventurer', 'Dreamer', 'Innovator', 'Creator', 'Guardian',
    'Warrior', 'Sage', 'Pioneer', 'Champion', 'Voyager', 'Architect',
    'Genius', 'Maverick', 'Rebel', 'Visionary', 'Storyteller', 'Wanderer',
    'Seeker', 'Builder', 'Thinker', 'Maker', 'Rider', 'Hunter',
    'Traveler', 'Scholar', 'Artist', 'Navigator', 'Trailblazer', 'Legend'
  ];

  static final List<String> _colors = [
    'Red', 'Blue', 'Green', 'Purple', 'Orange', 'Yellow', 'Pink', 'Cyan',
    'Silver', 'Gold', 'Emerald', 'Ruby', 'Sapphire', 'Diamond', 'Pearl'
  ];

  static String generateFunUsername() {
    final random = Random();
    final adjective = _adjectives[random.nextInt(_adjectives.length)];
    final noun = _nouns[random.nextInt(_nouns.length)];
    final color = _colors[random.nextInt(_colors.length)];
    final number = random.nextInt(999) + 1;
    
    // Generate different patterns of usernames
    final patterns = [
      '$adjective$noun$number',
      '$color$noun$number',
      '$adjective$color$noun',
      '${adjective}The$noun$number',
    ];
    
    return patterns[random.nextInt(patterns.length)];
  }
}
