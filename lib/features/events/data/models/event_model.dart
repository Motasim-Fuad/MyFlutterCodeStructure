// =========================================
// EVENT MODEL - Event er sob data
// =========================================
class EventModel {
  final int id;
  final String name;
  final String aboutTheEvent;
  final String location;
  final String latitude;
  final String longitude;
  final String fromDate;
  final String toDate;
  final List<EventImage> images; // Event er images
  final String adminName;
  final String adminEmail;
  final String adminPhone;
  final int totalShops;
  final String status; // approved/pending
  final String eventDateStatus; // ongoing/ended
  final String createdAt;

  EventModel({
    required this.id,
    required this.name,
    required this.aboutTheEvent,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.fromDate,
    required this.toDate,
    required this.images,
    required this.adminName,
    required this.adminEmail,
    required this.adminPhone,
    required this.totalShops,
    required this.status,
    required this.eventDateStatus,
    required this.createdAt,
  });

  // ====== FROM JSON ======
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      aboutTheEvent: json['about_the_event'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude'] ?? '0',
      longitude: json['longitude'] ?? '0',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      // Images array ke EventImage list e convert
      images: (json['images'] as List?)
          ?.map((e) => EventImage.fromJson(e))
          .toList() ?? [],
      adminName: json['admin_name'] ?? '',
      adminEmail: json['admin_email'] ?? '',
      adminPhone: json['admin_phone'] ?? '',
      totalShops: json['total_shops'] ?? 0,
      status: json['status'] ?? '',
      eventDateStatus: json['event_date_status'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  // ====== HELPER METHODS ======
  // Status check korar shortcut methods
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isOngoing => eventDateStatus.toLowerCase() == 'ongoing';
  bool get isEnded => eventDateStatus.toLowerCase() == 'ended';

  // First image URL - jodi thake
  String get firstImageUrl => images.isNotEmpty ? images.first.image : '';
}

// =========================================
// EVENT IMAGE MODEL - Single image
// =========================================
class EventImage {
  final int id;
  final String image; // Image URL
  final String uploadedAt;

  EventImage({
    required this.id,
    required this.image,
    required this.uploadedAt,
  });

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      uploadedAt: json['uploaded_at'] ?? '',
    );
  }
}