import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/event_model.dart';

// =========================================
// EVENT CARD - Single event er card
// =========================================
class EventCard extends StatelessWidget {
  final EventModel event; // Event data
  final VoidCallback onDelete; // Delete callback

  const EventCard({
    Key? key,
    required this.event,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====== EVENT IMAGE ======
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: event.firstImageUrl.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: event.firstImageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              // Loading placeholder
              placeholder: (context, url) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              // Error placeholder
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            )
                : Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 50),
            ),
          ),

          // ====== EVENT DETAILS ======
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event name
                Text(
                  event.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Date range
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${event.fromDate} - ${event.toDate}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Status badges
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusChip(
                      label: event.status.toUpperCase(),
                      color: event.isApproved ? Colors.green : Colors.orange,
                    ),
                    _buildStatusChip(
                      label: event.eventDateStatus.toUpperCase(),
                      color: event.isOngoing ? Colors.blue : Colors.grey,
                    ),
                    _buildStatusChip(
                      label: '${event.totalShops} Shops',
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    // View button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // View details logic ekhane
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('View'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Delete button
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onDelete, // Delete callback call
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====== BUILD STATUS CHIP ======
  // Status badge widget
  Widget _buildStatusChip({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}