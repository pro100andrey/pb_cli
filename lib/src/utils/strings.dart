/// Common strings and messages used throughout the CLI application.
///
/// This class provides centralized access to all user-facing strings,
/// making it easier to maintain consistency and support localization.
///
library;

import '../extensions/string_style.dart';
// ignore_for_file: avoid_classes_with_only_static_members

abstract final class S {
  static const String appName = 'pb_cli';

  static const String appDescription =
      'A utility for synchronizing PocketBase schemas and data.';

  // Commands
  static const String setupCommand = 'setup';
  static const String pushCommand = 'push';
  static const String pullCommand = 'pull';

  // Command descriptions
  static const setupDescription =
      'Setup the local environment for managing PocketBase schema and data.';

  static const pushDescription =
      'Pushes the local PocketBase schema and seed data to the remote '
      'instance.';

  static const pullDescription =
      'Pulls the remote PocketBase schema and collection data into local JSON '
      'files.';

  // Options/Flags/Abbr/Helps/Defaults

  static const String dirOptionName = 'dir';
  static const String dirOptionAbbr = 'd';
  static const dirOptionHelp =
      'The local working directory for storing the PocketBase schema, config, '
      'and seed data files.';

  static const String batchSizeOptionName = 'batch-size';
  static const String batchSizeOptionAbbr = 'b';
  static const pullBatchSizeOptionHelp =
      'Number of records to fetch per batch. Maximum is 500.';
  static const pushBatchSizeOptionHelp =
      'Number of records to create per batch. Maximum is 50.';
  static const String pushBatchSizeOptionDefault = '20';
  static const String pullBatchSizeOptionDefault = '100';

  static const String verboseFlagName = 'verbose';
  static const String verboseFlagAbbr = 'v';
  static const String verboseFlagHelp = 'Enable verbose logging.';

  static const String truncateFlagName = 'truncate';
  static const String truncateFlagAbbr = 't';
  static const String truncateFlagHelp =
      'Whether to truncate existing collections before import.';

  // Info Messages
  static String startSetupForDir(String dir) =>
      'Starting setup for directory: ${dir.yellow.underlined}';
}
