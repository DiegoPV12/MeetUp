// lib/widgets/activities/activity_timeline.dart
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../../models/activity_model.dart';
import 'activity_timeline_entry.dart';

const _kTileHeight = 220.0;

class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({
    super.key,
    required this.activities,
    required this.onEdit,
    required this.onDelete,
    this.readOnly = false,
  });

  final List<ActivityModel> activities;
  final ValueChanged<ActivityModel> onEdit;
  final ValueChanged<ActivityModel> onDelete;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Timeline.tileBuilder(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      theme: TimelineThemeData(
        nodePosition: 0, // rail pegado al borde
        nodeItemOverlap: true,
        connectorTheme: const ConnectorThemeData(thickness: 6),
        indicatorTheme: const IndicatorThemeData(size: 24),
      ),
      builder: TimelineTileBuilder.connected(
        itemCount: activities.length,
        connectionDirection: ConnectionDirection.before,

        indicatorBuilder:
            (context, index) => OutlinedDotIndicator(
              borderWidth: 3,
              color: cs.primary,
              backgroundColor: cs.onPrimary,
            ),

        connectorBuilder: (_, __, ___) => SolidLineConnector(color: cs.primary),

        contentsBuilder:
            (_, idx) => ActivityTimelineEntry(
              activity: activities[idx],
              readOnly: readOnly,
              onEdit: () => onEdit(activities[idx]),
              onDelete: () => onDelete(activities[idx]),
            ),

        indicatorPositionBuilder: (_, __) => 0.08,

        itemExtentBuilder: (_, __) => _kTileHeight,
      ),
    );
  }
}
