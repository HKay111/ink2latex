/// Ink2LaTeX configuration.
///
/// To enable Mathpix cloud recognition (T3):
/// 1. Sign up at https://mathpix.com/pricing/api ($19.99 one-time setup)
/// 2. Create an organization and get your API key
/// 3. Replace the value below with your key (format: "app_id:app_key")
class AppConfig {
  /// Mathpix API key for cloud-based LaTeX recognition.
  /// Set to null or empty to disable cloud recognition.
  static const String mathpixApiKey = '';

  /// Whether to use Mathpix cloud recognition (T3) as fallback.
  static bool get isMathpixEnabled => mathpixApiKey.isNotEmpty;
}
