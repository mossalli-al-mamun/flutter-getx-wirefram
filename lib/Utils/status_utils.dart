import 'package:flutter/material.dart';

import '../Widgets/chips/status_chip.dart';

/// A definition for a status, containing UI-related properties.
class StatusDefinition {
  final String labelKey;
  final StatusTone tone;
  final IconData? icon;

  const StatusDefinition({
    required this.labelKey,
    required this.tone,
    this.icon,
  });
}

/// A helper class to manage and retrieve status definitions throughout the app.
class StatusHelper {
  /// A map of pre-defined status keys to their definitions.
  /// This can be extended with statuses from other modules.
  static final Map<String, StatusDefinition> _statusMap = {
    'approved': const StatusDefinition(
      labelKey: 'approved',
      tone: StatusTone.success,
      icon: Icons.check_circle_rounded,
    ),
    'pending': const StatusDefinition(
      labelKey: 'pending',
      tone: StatusTone.warning,
      icon: Icons.schedule_rounded,
    ),
    'rejected': const StatusDefinition(
      labelKey: 'rejected',
      tone: StatusTone.error,
      icon: Icons.cancel_rounded,
    ),
    // Add more general or module-specific statuses here.
  };

  /// Retrieves a [StatusDefinition] for a given [statusKey].
  ///
  /// If the [statusKey] is not found, it returns a default neutral status.
  static StatusDefinition getStatus(String statusKey) {
    return _statusMap[statusKey] ??
        StatusDefinition(
          labelKey: statusKey, // Fallback to the key itself as label
          tone: StatusTone.neutral,
          icon: Icons.info_rounded, // Default icon
        );
  }

  /// Dynamically registers or updates a status definition at runtime.
  ///
  /// This is useful for statuses that are defined on the backend.
  static void registerStatus(String key, StatusDefinition definition) {
    _statusMap[key] = definition;
  }
}
