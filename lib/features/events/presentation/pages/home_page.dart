import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../widgets/event_card.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/empty_widget.dart';

// =========================================
// HOME PAGE - Event list show kore
// =========================================
class HomePage extends GetView<EventController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Events'),
        centerTitle: true,
        elevation: 0,
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshEvents,
          ),
        ],
      ),

      // Obx - loadingState change hole rebuild
      body: Obx(() {
        // State onujayi different UI show
        switch (controller.loadingState.value) {
        // ====== LOADING STATE ======
          case EventLoadingState.loading:
            return const LoadingWidget(message: 'Loading events...');

        // ====== ERROR STATE ======
          case EventLoadingState.error:
            return CustomErrorWidget(
              message: controller.errorMessage.value,
              onRetry: controller.retry, // Retry button
            );

        // ====== EMPTY STATE ======
          case EventLoadingState.empty:
            return const EmptyWidget(
              icon: Icons.event_busy,
              message: 'No events found',
              subMessage: 'You haven\'t created any events yet',
            );

        // ====== SUCCESS STATE ======
          case EventLoadingState.success:
            return RefreshIndicator(
              onRefresh: controller.refreshEvents, // Pull to refresh
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.events.length,
                itemBuilder: (context, index) {
                  final event = controller.events[index];
                  return EventCard(
                    event: event,
                    onDelete: () => controller.deleteEvent(event.id),
                  );
                },
              ),
            );

          default:
            return const SizedBox.shrink();
        }
      }),
    );
  }
}