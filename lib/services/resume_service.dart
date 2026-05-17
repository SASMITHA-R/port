// Conditional import: uses package:web on web, stub on mobile/desktop.
import 'resume_downloader_stub.dart'
    if (dart.library.html) 'resume_downloader_web.dart';

class ResumeService {
  /// Call this from any button to download / open the resume PDF.
  /// Web   → triggers a browser "Save As" download automatically.
  /// Mobile → stub (extend with path_provider + open_file for full support).
  static Future<void> downloadResume() async {
    await downloadResumeImpl();
  }
}
