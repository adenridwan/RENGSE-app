import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ==================== THEME COLORS ====================

// Light theme colors
const _lightBg = Color(0xFFF7F8FC);
const _lightSurface = Color(0xFFFFFFFF);
const _lightLine = Color(0xFFE5E8F1);
const _lightText = Color(0xFF1C2540);
const _lightMuted = Color(0xFF69738D);

// Dark theme colors
const _darkBg = Color(0xFF121218);
const _darkSurface = Color(0xFF1E1E26);
const _darkLine = Color(0xFF2E2E3A);
const _darkText = Color(0xFFE8E8EC);
const _darkMuted = Color(0xFF9898A8);

// Accent colors (shared)
const accent = Color(0xFF6255E7);
const accentDark = Color(0xFFEAE8FF);
const mint = Color(0xFFDDF8EE);
const sky = Color(0xFFE0F2FF);
const peach = Color(0xFFFFE9D7);
const rose = Color(0xFFFFE4EA);

// Dark theme tints
const _darkMint = Color(0xFF1A2E28);
const _darkSky = Color(0xFF1A2530);
const _darkPeach = Color(0xFF2E2520);
const _darkRose = Color(0xFF2E2025);
const _darkAccentTint = Color(0xFF252040);

// App theme provider
class AppTheme extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  // Theme-aware colors
  Color get bg => _isDark ? _darkBg : _lightBg;
  Color get surface => _isDark ? _darkSurface : _lightSurface;
  Color get line => _isDark ? _darkLine : _lightLine;
  Color get text => _isDark ? _darkText : _lightText;
  Color get muted => _isDark ? _darkMuted : _lightMuted;
  Color get mintTint => _isDark ? _darkMint : mint;
  Color get skyTint => _isDark ? _darkSky : sky;
  Color get peachTint => _isDark ? _darkPeach : peach;
  Color get roseTint => _isDark ? _darkRose : rose;
  Color get accentTint => _isDark ? _darkAccentTint : accentDark;

  void setDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDark);
    notifyListeners();
  }
}

// Global theme instance
final appTheme = AppTheme();

// Convenience getters (for backward compatibility)
Color get bg => appTheme.bg;
Color get surface => appTheme.surface;
Color get line => appTheme.line;
Color get text => appTheme.text;
Color get muted => appTheme.muted;

// ==================== LOCALIZATION ====================

class AppLocale extends ChangeNotifier {
  String _lang = 'id';
  String get lang => _lang;
  bool get isId => _lang == 'id';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString('language') ?? 'id';
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _lang = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  // App strings
  String get appName => 'RENGSÉ';
  String get today => isId ? 'Hari Ini' : 'Today';
  String get lists => isId ? 'Daftar' : 'Lists';
  String get schedule => isId ? 'Jadwal' : 'Schedule';
  String get focus => isId ? 'Fokus' : 'Focus';
  String get insights => isId ? 'Analisis' : 'Insights';

  // Today tab
  String get overdue => isId ? 'Terlambat' : 'Overdue';
  String get todayTasks => isId ? 'Hari ini' : 'Today';
  String get completed => isId ? 'Selesai' : 'Completed';
  String get noTasks => isId ? 'Belum ada tugas' : 'No tasks yet';
  String get tapToAdd => isId
      ? 'Ketuk + untuk menambah tugas pertamamu'
      : 'Tap + to add your first task';
  String get addTask => isId ? 'Tambah tugas' : 'Add task';
  String get noTasksInSection => isId ? 'Tidak ada tugas' : 'No tasks';

  // Task actions
  String get taskAdded => isId ? 'Tugas ditambahkan' : 'Task added';
  String get taskDeleted => isId ? 'Tugas dihapus' : 'Task deleted';
  String get taskCompleted => isId ? 'Selesai' : 'Completed';
  String get taskReopened => isId ? 'Dibuka lagi' : 'Reopened';
  String get deleteTask => isId ? 'Hapus tugas?' : 'Delete task?';
  String get confirmDelete =>
      isId ? 'Yakin ingin menghapus' : 'Are you sure you want to delete';
  String get cancel => isId ? 'Batal' : 'Cancel';
  String get delete => isId ? 'Hapus' : 'Delete';

  // Quick add
  String get newTask => isId ? 'Tambah tugas' : 'Add task';
  String get whatToDo =>
      isId ? 'Apa yang perlu dikerjakan?' : 'What needs to be done?';
  String get list => isId ? 'Daftar' : 'List';
  String get highPriority => isId ? 'Prioritas tinggi' : 'High priority';

  // Due dates
  String get todayDue => isId ? 'Hari ini' : 'Today';
  String get tomorrow => isId ? 'Besok' : 'Tomorrow';
  String get thisWeek => isId ? 'Minggu ini' : 'This week';
  String get later => isId ? 'Nanti' : 'Later';
  String get yesterday => isId ? 'Kemarin' : 'Yesterday';

  // Lists tab
  String get newTaskBtn => isId ? '+ Tugas baru' : '+ New task';
  String get smartViews => isId ? 'Tampilan pintar' : 'Smart views';
  String get next7Days => isId ? '7 hari ke depan' : 'Next 7 days';
  String get activeTasks => isId ? 'tugas aktif' : 'active tasks';
  String get tasks => isId ? 'tugas' : 'tasks';
  String get percentComplete => isId ? 'selesai' : 'complete';
  String get overdueCount => isId ? 'terlambat' : 'overdue';

  // Schedule tab
  String get noTasksScheduled =>
      isId ? 'Tidak ada tugas untuk tanggal ini' : 'No tasks for this date';
  String get pending => isId ? 'Tertunda' : 'Pending';
  String get priority => isId ? 'Prioritas' : 'Priority';

  // Focus tab
  String get mainPriority => isId ? 'PRIORITAS UTAMA' : 'MAIN PRIORITY';
  String get nextSession => isId ? 'SESI BERIKUTNYA' : 'NEXT SESSION';
  String get selectTaskToStart =>
      isId ? 'Pilih tugas untuk memulai' : 'Select a task to start';
  String get focusTime => isId ? 'WAKTU FOKUS' : 'FOCUS TIME';
  String get inProgress => isId ? 'Sedang berlangsung' : 'In progress';
  String get readyToStart => isId ? 'Siap untuk mulai' : 'Ready to start';
  String get pauseSession => isId ? 'Jeda sesi' : 'Pause session';
  String get startFocus => isId ? 'Mulai fokus' : 'Start focus';
  String get timerReset =>
      isId ? 'Timer diatur ulang ke 45 menit' : 'Timer reset to 45 minutes';
  String get todaySummary => isId ? 'Ringkasan hari ini' : 'Today\'s summary';
  String get done => isId ? 'selesai' : 'done';
  String get pendingLower => isId ? 'tertunda' : 'pending';
  String get priorityLower => isId ? 'prioritas' : 'priority';
  String get oneThingTip =>
      isId ? 'Ruang untuk satu hal' : 'Room for one thing';
  String get focusTip => isId
      ? 'Matikan gangguan dan kerjakan satu tugas kecil sampai tuntas.'
      : 'Turn off distractions and work on one small task until done.';

  // Insights tab
  String get yourProgress => isId ? 'PROGRES KAMU' : 'YOUR PROGRESS';
  String get startTracking =>
      isId ? 'Mulai catat progresmu' : 'Start tracking your progress';
  String get onFire => isId ? 'Kamu sedang melaju!' : 'You\'re on fire!';
  String get keepGoing =>
      isId ? 'Sedikit lagi, lanjutkan.' : 'Almost there, keep going.';
  String get tasksCompleted => isId ? 'tugas telah selesai' : 'tasks completed';
  String get taskDistribution => isId ? 'Sebaran tugas' : 'Task distribution';
  String get perList => isId ? 'per daftar' : 'per list';
  String get noDataYet =>
      isId ? 'Belum ada data untuk ditampilkan' : 'No data to display yet';
  String get priorityNeedsAttention =>
      isId ? 'Prioritas butuh perhatian' : 'Priorities need attention';
  String get readyToBuild =>
      isId ? 'Siap membangun momentum' : 'Ready to build momentum';
  String get addFirstTask => isId
      ? 'Tambahkan tugas pertama agar insight kamu mulai terbentuk.'
      : 'Add your first task to start seeing insights.';
  String get priorityTip => isId
      ? 'tugas prioritas sudah terselesaikan. Mulai dari satu yang paling penting.'
      : 'priority tasks completed. Start with the most important one.';
  String get noPriorityTip => isId
      ? 'Tidak ada prioritas tinggi saat ini. Pilih satu tugas kecil untuk diselesaikan hari ini.'
      : 'No high priorities right now. Pick one small task to complete today.';

  // Settings
  String get settings => isId ? 'Pengaturan' : 'Settings';
  String get account => isId ? 'Akun' : 'Account';
  String get localAccount => isId ? 'Akun lokal' : 'Local account';
  String get dataSavedLocally =>
      isId ? 'Data tersimpan di perangkat' : 'Data saved on device';
  String get preferences => isId ? 'Preferensi' : 'Preferences';
  String get offlineSync => isId ? 'Sinkron offline' : 'Offline sync';
  String get offlineSyncDesc => isId
      ? 'Kirim perubahan saat jaringan tersedia'
      : 'Send changes when network available';
  String get reminders => isId ? 'Pengingat' : 'Reminders';
  String get remindersDesc =>
      isId ? 'Notifikasi sebelum waktu tugas' : 'Notification before task time';
  String get appBadge => isId ? 'Lencana aplikasi' : 'App badge';
  String get appBadgeDesc =>
      isId ? 'Tampilkan jumlah tugas tertunda' : 'Show pending task count';
  String get appearance => isId ? 'Tampilan' : 'Appearance';
  String get darkMode => isId ? 'Mode gelap' : 'Dark mode';
  String get darkModeDesc =>
      isId ? 'Tampilan nyaman di malam hari' : 'Comfortable viewing at night';
  String get lightMode => isId ? 'Mode terang' : 'Light mode';
  String get lightModeDesc =>
      isId ? 'Tampilan cerah dan penuh warna' : 'Bright and colorful display';
  String get language => isId ? 'Bahasa' : 'Language';
  String get indonesian => isId ? 'Bahasa Indonesia' : 'Indonesian';
  String get english => isId ? 'English' : 'English';
  String get data => isId ? 'Data' : 'Data';
  String get exportTasks => isId ? 'Ekspor tugas' : 'Export tasks';
  String get exportDesc => isId ? 'Simpan sebagai JSON' : 'Save as JSON';
  String get deleteAllTasks => isId ? 'Hapus semua tugas' : 'Delete all tasks';
  String get deleteAllDesc => isId
      ? 'Tindakan ini tidak dapat dibatalkan'
      : 'This action cannot be undone';
  String get deleteAllConfirm => isId
      ? 'Semua tugas akan dihapus permanen. Pastikan sudah diekspor jika diperlukan.'
      : 'All tasks will be permanently deleted. Make sure to export if needed.';
  String get deleteAll => isId ? 'Hapus Semua' : 'Delete All';
  String get logout => isId ? 'Keluar' : 'Logout';
  String get version => isId ? 'Versi' : 'Version';
  String get madeWith => isId ? 'Dibuat dengan Flutter' : 'Made with Flutter';
  String get selectLanguage => isId ? 'Pilih Bahasa' : 'Select Language';
  String get exportData => isId ? 'Ekspor Data' : 'Export Data';
  String get yourTaskData => isId ? 'Data tugas kamu:' : 'Your task data:';
  String get close => isId ? 'Tutup' : 'Close';
  String get allTasksDeleted =>
      isId ? 'Semua tugas dihapus' : 'All tasks deleted';

  // Report
  String get report => isId ? 'Laporan' : 'Report';
  String get weeklyReport => isId ? 'Laporan Mingguan' : 'Weekly Report';
  String get totalTasks => isId ? 'Total tugas' : 'Total tasks';
  String get completionRate =>
      isId ? 'Tingkat penyelesaian' : 'Completion rate';
  String get highPriorityTasks =>
      isId ? 'Tugas prioritas tinggi' : 'High priority tasks';
  String get mostProductiveList =>
      isId ? 'Daftar paling produktif' : 'Most productive list';
  String get noData => isId ? 'Tidak ada data' : 'No data';

  // Task detail
  String get taskDetail => isId ? 'Detail Tugas' : 'Task Detail';
  String get dueDate => isId ? 'Jatuh tempo' : 'Due date';
  String get repeat => isId ? 'Ulangi' : 'Repeat';
  String get never => isId ? 'Tidak pernah' : 'Never';
  String get weekdays => isId ? 'Hari kerja' : 'Weekdays';
  String get tags => isId ? 'Tag' : 'Tags';
  String get noTags => isId ? 'Tidak ada' : 'None';
  String get scheduleBtn => isId ? 'Jadwalkan' : 'Schedule';
  String get priorityBtn => isId ? 'Prioritas' : 'Priority';
  String get normalBtn => isId ? 'Normal' : 'Normal';
  String get repeatBtn => isId ? 'Ulangi' : 'Repeat';
  String get subtask => isId ? 'Subtugas' : 'Subtask';
  String get subtasks => isId ? 'Subtugas' : 'Subtasks';
  String get of_ => isId ? 'dari' : 'of';
  String get markComplete => isId ? 'Tandai selesai' : 'Mark complete';
  String get reopenTask => isId ? 'Buka lagi tugas' : 'Reopen task';
  String get taskUpdated => isId ? 'Tugas diperbarui' : 'Task updated';
  String get selectDate => isId ? 'Pilih tanggal' : 'Select date';
  String get addSubtask => isId ? 'Tambah subtugas' : 'Add subtask';
  String get subtaskName => isId ? 'Nama subtugas' : 'Subtask name';
  String get add => isId ? 'Tambah' : 'Add';
  String get taskTitle => isId ? 'Judul tugas' : 'Task title';

  // Days
  String get sunday => isId ? 'Minggu' : 'Sunday';
  String get monday => isId ? 'Senin' : 'Monday';
  String get tuesday => isId ? 'Selasa' : 'Tuesday';
  String get wednesday => isId ? 'Rabu' : 'Wednesday';
  String get thursday => isId ? 'Kamis' : 'Thursday';
  String get friday => isId ? 'Jumat' : 'Friday';
  String get saturday => isId ? 'Sabtu' : 'Saturday';

  List<String> get dayNames => isId
      ? ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
      : [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday'
        ];

  List<String> get shortDayNames => isId
      ? ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab']
      : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  List<String> get monthNames => isId
      ? [
          'Januari',
          'Februari',
          'Maret',
          'April',
          'Mei',
          'Juni',
          'Juli',
          'Agustus',
          'September',
          'Oktober',
          'November',
          'Desember'
        ]
      : [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];

  // Exit
  String get exitApp => isId ? 'Keluar Aplikasi' : 'Exit App';
  String get exitConfirm => isId
      ? 'Yakin ingin keluar dari aplikasi?'
      : 'Are you sure you want to exit?';
  String get exit => isId ? 'Keluar' : 'Exit';

  // Onboarding
  String get onboardingTitle => isId
      ? 'Daftar yang kamu selesaikan, dan angka di baliknya.'
      : 'The lists you complete, and the numbers behind them.';
  String get onboardingDesc => isId
      ? 'Catat tugas dalam dua ketukan. Analisis menunjukkan kapan kamu benar-benya menyelesaikan sesuatu.'
      : 'Log tasks in two taps. Analytics show when you actually get things done.';
  String get startToday => isId ? 'Mulai dengan hari ini' : 'Start with today';
  String get loginToSync => isId ? 'Masuk untuk sinkron' : 'Login to sync';
  String get worksOffline => isId
      ? 'Bekerja offline. Sinkron opsional.'
      : 'Works offline. Sync optional.';
  String get syncComingSoon =>
      isId ? 'Sinkronisasi akan tersedia segera' : 'Sync coming soon';

  // Biometric
  String get biometricLock => isId ? 'Kunci biometrik' : 'Biometric lock';
  String get biometricDesc =>
      isId ? 'Gunakan sidik jari atau Face ID' : 'Use fingerprint or Face ID';
  String get biometricReason =>
      isId ? 'Autentikasi untuk membuka RENGSÉ' : 'Authenticate to open RENGSÉ';
  String get biometricEnabled =>
      isId ? 'Kunci biometrik aktif' : 'Biometric lock enabled';
  String get biometricDisabled =>
      isId ? 'Kunci biometrik dimatikan' : 'Biometric lock disabled';
  String get biometricNotAvailable => isId
      ? 'Biometrik tidak tersedia di perangkat ini'
      : 'Biometric not available on this device';
  String get biometricFailed =>
      isId ? 'Autentikasi gagal' : 'Authentication failed';
  String get unlockApp => isId ? 'Buka Kunci' : 'Unlock';
  String get tryAgain => isId ? 'Coba Lagi' : 'Try Again';
  String get authenticateToAccess => isId
      ? 'Autentikasi untuk mengakses tugas Anda'
      : 'Authenticate to access your tasks';
}

// ==================== BIOMETRIC SERVICE ====================

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();
  static bool _isEnabled = false;
  static bool _isAvailable = false;

  static bool get isEnabled => _isEnabled;
  static bool get isAvailable => _isAvailable;

  static Future<void> init() async {
    // Check if biometric is available (only on mobile)
    if (kIsWeb) {
      _isAvailable = false;
      return;
    }

    try {
      _isAvailable =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      final prefs = await SharedPreferences.getInstance();
      _isEnabled = prefs.getBool('biometricEnabled') ?? false;
    } catch (e) {
      _isAvailable = false;
    }
  }

  static Future<bool> checkAvailability() async {
    if (kIsWeb) return false;
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    if (kIsWeb) return [];
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  static Future<bool> authenticate(String reason) async {
    if (kIsWeb) return true;
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN/password fallback
        ),
      );
    } catch (e) {
      return false;
    }
  }

  static Future<void> setEnabled(bool value) async {
    _isEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricEnabled', value);
  }
}

// Global locale instance
final appLocale = AppLocale();

// Shortcut
AppLocale get t => appLocale;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appTheme.load();
  await appLocale.load();
  await BiometricService.init();
  runApp(const RengseApp());
}

class RengseApp extends StatefulWidget {
  const RengseApp({super.key});
  @override
  State<RengseApp> createState() => _RengseAppState();
}

class _RengseAppState extends State<RengseApp> {
  @override
  void initState() {
    super.initState();
    appTheme.addListener(_onAppChange);
    appLocale.addListener(_onAppChange);
  }

  @override
  void dispose() {
    appTheme.removeListener(_onAppChange);
    appLocale.removeListener(_onAppChange);
    super.dispose();
  }

  void _onAppChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isDark = appTheme.isDark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RENGSE — Rencana Éféktif, Ngatur Gawé Sampai Rengsé',
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: appTheme.bg,
        colorScheme: isDark
            ? ColorScheme.dark(
                primary: accent,
                secondary: const Color(0xFF00A98F),
                surface: appTheme.surface,
                onSurface: appTheme.text,
              )
            : ColorScheme.light(
                primary: accent,
                secondary: const Color(0xFF00A98F),
                surface: appTheme.surface,
                onSurface: appTheme.text,
              ),
        fontFamily: 'sans',
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: appTheme.bg,
          foregroundColor: appTheme.text,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: CardThemeData(
          color: appTheme.surface,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: appTheme.line),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDark ? appTheme.surface : const Color(0xFFFBFCFF),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: appTheme.line),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: appTheme.line),
          ),
        ),
      ),
      home: const RengseHome(),
    );
  }
}

// ==================== MODELS ====================

class Task {
  Task({
    required this.id,
    required this.title,
    required this.list,
    required this.due,
    this.high = false,
    this.done = false,
    List<Subtask>? subtasks,
    this.repeat = 'Never',
    List<String>? tags,
    DateTime? createdAt,
  })  : subtasks = subtasks ?? [],
        tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now();

  final String id;
  String title;
  String list, due, repeat;
  bool high, done;
  final List<String> tags;
  final List<Subtask> subtasks;
  final DateTime createdAt;

  int get subDone => subtasks.where((s) => s.done).length;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'list': list,
        'due': due,
        'high': high,
        'done': done,
        'repeat': repeat,
        'tags': tags,
        'subtasks': subtasks.map((s) => s.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    if (json['id'] != null && json['id'].toString().isNotEmpty) {
      id = json['id'].toString();
    }

    return Task(
      id: id,
      title: (json['title'] ?? '').toString(),
      list: (json['list'] ?? 'Inbox').toString(),
      due: (json['due'] ?? 'Hari ini').toString(),
      high: json['high'] == true,
      done: json['done'] == true,
      repeat: (json['repeat'] ?? 'Never').toString(),
      tags: json['tags'] != null
          ? List<String>.from(
              (json['tags'] as List).map((e) => e?.toString() ?? ''))
          : <String>[],
      subtasks: json['subtasks'] != null
          ? (json['subtasks'] as List)
              .map((s) => Subtask.fromJson(s as Map<String, dynamic>))
              .toList()
          : <Subtask>[],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class Subtask {
  Subtask(this.title, {this.done = false});
  String title;
  bool done;

  Map<String, dynamic> toJson() => {'title': title, 'done': done};

  factory Subtask.fromJson(Map<String, dynamic> json) => Subtask(
        (json['title'] ?? '').toString(),
        done: json['done'] == true,
      );
}

// ==================== MAIN APP ====================

class RengseHome extends StatefulWidget {
  const RengseHome({super.key});
  @override
  State<RengseHome> createState() => _RengseHomeState();
}

class _RengseHomeState extends State<RengseHome> with WidgetsBindingObserver {
  bool onboarding = true;
  bool isLoading = true;
  bool isLocked = false; // Biometric lock state
  int tab = 0;
  int seconds = 2700;
  bool running = false;
  Timer? timer;
  final tasks = <Task>[];

  // For Jadwal tab
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBiometricLock();
    _loadData();

    // Fallback timeout to prevent infinite loading
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && isLoading) {
        setState(() => isLoading = false);
      }
    });
  }

  Future<void> _checkBiometricLock() async {
    if (BiometricService.isEnabled && BiometricService.isAvailable) {
      setState(() => isLocked = true);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Lock app when it goes to background (if biometric is enabled)
    if (state == AppLifecycleState.paused && BiometricService.isEnabled) {
      setState(() => isLocked = true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    super.dispose();
  }

  Future<void> _unlockApp() async {
    final authenticated =
        await BiometricService.authenticate(t.biometricReason);
    if (authenticated && mounted) {
      setState(() => isLocked = false);
    }
  }

  // ==================== DATA PERSISTENCE ====================

  Future<void> _loadData() async {
    bool hasOnboarded = false;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load onboarding state
      hasOnboarded = prefs.getBool('onboarded') ?? false;

      // Load tasks
      final tasksJson = prefs.getString('tasks');
      if (tasksJson != null && tasksJson.isNotEmpty) {
        try {
          final decoded = jsonDecode(tasksJson);
          if (decoded is List) {
            tasks.clear();
            for (final item in decoded) {
              if (item is Map<String, dynamic>) {
                tasks.add(Task.fromJson(item));
              }
            }
          }
        } catch (jsonError) {
          debugPrint('Error parsing tasks JSON: $jsonError');
          // Clear corrupted data
          await prefs.remove('tasks');
        }
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      // Always update UI state
      if (mounted) {
        setState(() {
          onboarding = !hasOnboarded;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'tasks', jsonEncode(tasks.map((t) => t.toJson()).toList()));
  }

  void _completeOnboarding() {
    // Set state immediately for responsive UI
    setState(() => onboarding = false);

    // Save onboarding state in background
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('onboarded', true);
    }).catchError((e) {
      debugPrint('Error saving onboarding state: $e');
    });
  }

  // ==================== CRUD OPERATIONS ====================

  // CREATE
  void _addTask(Task task) {
    setState(() => tasks.insert(0, task));
    _saveTasks();
    _toast('Tugas ditambahkan: ${task.title}');
  }

  // UPDATE
  void _updateTask(Task task) {
    setState(() {});
    _saveTasks();
  }

  // DELETE
  void _deleteTask(Task task) {
    setState(() => tasks.remove(task));
    _saveTasks();
    _toast('Tugas dihapus: ${task.title}');
  }

  // TOGGLE DONE
  void _toggleTask(Task task) {
    setState(() => task.done = !task.done);
    _saveTasks();
    _toast(task.done ? 'Selesai: ${task.title}' : 'Dibuka lagi: ${task.title}');
  }

  // ==================== TIMER ====================

  void _startTimer() {
    setState(() => running = !running);
    timer?.cancel();
    if (running) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (seconds > 0) {
          setState(() => seconds--);
        } else {
          timer?.cancel();
          setState(() => running = false);
        }
      });
    }
  }

  void _toast(String message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: accentDark,
          behavior: SnackBarBehavior.floating,
        ),
      );

  // ==================== UI BUILD ====================

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/logo-rengse.png',
                    width: 80, height: 80),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(color: accent),
            ],
          ),
        ),
      );
    }

    // Show lock screen if biometric is enabled and app is locked
    if (isLocked && BiometricService.isEnabled) {
      return _lockScreen();
    }

    return onboarding
        ? _onboarding()
        : Scaffold(
            body: SafeArea(
              child: IndexedStack(
                index: tab,
                children: [
                  _today(),
                  _lists(),
                  _timeline(),
                  _focus(),
                  _insights(),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: line)),
                child: Row(children: [
                  _navItem(0, Icons.task_alt_rounded, t.today),
                  _navItem(1, Icons.grid_view_rounded, t.lists),
                  _navItem(2, Icons.calendar_today_rounded, t.schedule),
                  _navItem(3, Icons.timer_outlined, t.focus),
                  _navItem(4, Icons.insights_rounded, t.insights),
                ]),
              ),
            ),
            floatingActionButton: tab < 3
                ? FloatingActionButton(
                    onPressed: _quickAdd,
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.add),
                  )
                : null,
          );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = tab == index;
    return Expanded(
        child: InkWell(
      onTap: () => setState(() => tab = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: selected ? accentDark : Colors.transparent,
            borderRadius: BorderRadius.circular(16)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 20, color: selected ? accent : muted),
          const SizedBox(height: 3),
          Text(label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 9.5,
                  color: selected ? accent : muted,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500))
        ]),
      ),
    ));
  }

  // ==================== ONBOARDING ====================

  Widget _onboarding() => Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -95,
                right: -75,
                child: Container(
                  width: 255,
                  height: 255,
                  decoration: const BoxDecoration(
                    color: accentDark,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: 150,
                left: -80,
                child: Container(
                  width: 175,
                  height: 175,
                  decoration: BoxDecoration(
                    color: appTheme.skyTint,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 22, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 8),
                        Text('RENGSE',
                            style: TextStyle(
                                color: text,
                                fontSize: 16,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w900)),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(31),
                          boxShadow: [
                            BoxShadow(
                              color: accent.withValues(alpha: .16),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.asset('assets/logo-rengse.png',
                              width: 116, height: 116, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 27),
                    const Text('RENGSE',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.2)),
                    const SizedBox(height: 12),
                    const Text('Rencana Éféktif,\nNgatur Gawé Sampai Rengsé',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            height: 1.2,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 13),
                    Text(
                      'Rencanakan yang penting, fokus pada satu hal, lalu lihat progresmu tumbuh setiap hari.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: muted, height: 1.45, fontSize: 14),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _completeOnboarding,
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Mulai sekarang',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () =>
                          _toast('Sinkronisasi akan tersedia segera'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: line),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.cloud_outlined),
                      label: const Text('Masuk untuk sinkron'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                        'Dengan melanjutkan, kamu dapat mengatur tugas dengan tenang.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: muted, fontSize: 11)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  // ==================== LOCK SCREEN ====================

  Widget _lockScreen() => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: appTheme.accentTint,
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.lock_rounded, color: accent, size: 64),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'RENGSÉ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: text,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.authenticateToAccess,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 15),
                  ),
                  const SizedBox(height: 40),
                  FilledButton.icon(
                    onPressed: _unlockApp,
                    icon: const Icon(Icons.fingerprint_rounded),
                    label: Text(t.unlockApp),
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  // ==================== PAGE TEMPLATE ====================

  Widget _page(
    String title, {
    List<Widget> children = const [],
    List<Widget>? actions,
  }) =>
      ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              ...(actions ?? []),
            ],
          ),
          const SizedBox(height: 22),
          ...children,
        ],
      );

  // ==================== TODAY TAB (CRUD) ====================

  Widget _today() {
    final now = DateTime.now();
    final dateStr = _formatDate(now);

    final open = tasks.where((t) => !t.done).toList();
    final overdue = open.where((t) => _isOverdue(t.due)).toList();
    final todayTasks = open.where((t) => !_isOverdue(t.due)).toList();
    final completed = tasks.where((t) => t.done).toList();

    return _page(
      t.today,
      actions: [
        IconButton(onPressed: _search, icon: const Icon(Icons.search)),
        IconButton(
          onPressed: _showReport,
          icon: const Icon(Icons.bar_chart_rounded),
          tooltip: t.report,
        ),
        IconButton(
          onPressed: _settings,
          icon: const Icon(Icons.settings_outlined),
          tooltip: t.settings,
        ),
        IconButton(
          onPressed: _confirmExit,
          icon: const Icon(Icons.exit_to_app_rounded),
          tooltip: t.exitApp,
        ),
      ],
      children: [
        Text(dateStr, style: TextStyle(color: muted)),
        const SizedBox(height: 22),
        if (tasks.isEmpty)
          _emptyState()
        else ...[
          if (overdue.isNotEmpty)
            _section(
              '${t.overdue} · ${overdue.length}',
              overdue.map(_taskRow).toList(),
              isOverdue: true,
            ),
          _section(
            '${t.todayTasks} · ${todayTasks.length}',
            todayTasks.map(_taskRow).toList(),
          ),
          if (completed.isNotEmpty)
            _section(
              '${t.completed} · ${completed.length}',
              completed.map(_taskRow).toList(),
            ),
        ],
      ],
    );
  }

  // ==================== REPORT ====================

  void _showReport() {
    final total = tasks.length;
    final done = tasks.where((t) => t.done).length;
    final rate = total > 0 ? (done / total * 100).toInt() : 0;
    final highPriority = tasks.where((t) => t.high).length;
    final highDone = tasks.where((t) => t.high && t.done).length;

    // Find most productive list
    final listCounts = <String, int>{};
    for (final task in tasks.where((t) => t.done)) {
      listCounts[task.list] = (listCounts[task.list] ?? 0) + 1;
    }
    String? topList;
    int topCount = 0;
    listCounts.forEach((list, count) {
      if (count > topCount) {
        topCount = count;
        topList = list;
      }
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: appTheme.accentTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bar_chart_rounded,
                        color: accent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    t.weeklyReport,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _reportRow(Icons.assignment_outlined, t.totalTasks, '$total'),
              _reportRow(
                  Icons.check_circle_outline, t.completionRate, '$rate%'),
              _reportRow(Icons.flag_outlined, t.highPriorityTasks,
                  '$highDone / $highPriority'),
              _reportRow(Icons.folder_outlined, t.mostProductiveList,
                  topList ?? t.noData),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(14),
                  ),
                  child: Text(t.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reportRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: muted, size: 20),
            const SizedBox(width: 12),
            Expanded(
                child:
                    Text(label, style: TextStyle(color: muted, fontSize: 14))),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: text, fontSize: 14)),
          ],
        ),
      );

  // ==================== EXIT ====================

  Future<void> _confirmExit() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: surface,
        title: Text(t.exitApp),
        content: Text(t.exitConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(t.exit),
          ),
        ],
      ),
    );
    if (confirm == true) {
      // Save tasks before exiting
      await _saveTasks();
      // Exit app
      SystemNavigator.pop();
    }
  }

  Widget _emptyState() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Icon(Icons.check_circle_outline,
                  size: 80, color: muted.withValues(alpha: 0.5)),
              const SizedBox(height: 20),
              Text(
                'Belum ada tugas',
                style: TextStyle(fontSize: 20, color: muted),
              ),
              const SizedBox(height: 8),
              Text(
                'Ketuk + untuk menambah tugas pertamamu',
                style: TextStyle(color: muted, fontSize: 14),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _quickAdd,
                icon: const Icon(Icons.add),
                label: const Text('Tambah tugas'),
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );

  String _formatDate(DateTime date) {
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]}';
  }

  bool _isOverdue(String due) {
    final lower = due.toLowerCase();
    return lower.contains('lalu') ||
        lower.contains('ago') ||
        lower.contains('kemarin') ||
        lower.contains('yesterday');
  }

  Widget _section(String name, List<Widget> rows, {bool isOverdue = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: isOverdue ? const Color(0xFFE05263) : accent,
                fontSize: 13,
                letterSpacing: .5,
              ),
            ),
            const SizedBox(height: 9),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text('Tidak ada tugas', style: TextStyle(color: muted)),
              )
            else
              ...rows,
          ],
        ),
      );

  Color _taskTint(Task task) {
    if (task.done) return mint;
    if (task.high) return peach;
    const options = [sky, accentDark, rose, mint];
    return options[
        task.list.codeUnits.fold(0, (a, b) => a + b) % options.length];
  }

  Widget _taskRow(Task t) => Dismissible(
        key: Key(t.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.red.shade700,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        confirmDismiss: (direction) => _confirmDelete(t),
        onDismissed: (_) => _deleteTask(t),
        child: InkWell(
          onTap: () => _detail(t),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
            decoration: BoxDecoration(
              color: _taskTint(t),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: t.high ? const Color(0xFFF5C487) : line),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _toggleTask(t),
                  icon: Icon(
                    t.done
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: t.done ? const Color(0xFF10A57A) : accent,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        style: TextStyle(
                          fontSize: 16,
                          decoration:
                              t.done ? TextDecoration.lineThrough : null,
                          color: t.done ? muted : text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${t.due} · ${t.list}${t.high ? ' · Prioritas' : ''}${t.subtasks.isNotEmpty ? ' · ${t.subDone}/${t.subtasks.length}' : ''}',
                        style: TextStyle(
                          color: _isOverdue(t.due) && !t.done
                              ? Colors.redAccent
                              : muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (t.high)
                  const Icon(Icons.flag, color: Colors.orange, size: 18),
              ],
            ),
          ),
        ),
      );

  Future<bool> _confirmDelete(Task task) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: surface,
            title: const Text('Hapus tugas?'),
            content: Text('Yakin ingin menghapus "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ==================== LISTS TAB ====================

  Widget _lists() {
    // Group tasks by list
    final listGroups = <String, List<Task>>{};
    for (final task in tasks) {
      listGroups.putIfAbsent(task.list, () => []).add(task);
    }

    return _page(
      'Daftar',
      actions: [
        TextButton(
          onPressed: _quickAdd,
          child: const Text('+ Tugas baru'),
        ),
      ],
      children: [
        if (listGroups.isEmpty)
          _emptyState()
        else
          ...listGroups.entries.map((entry) {
            final listTasks = entry.value;
            final done = listTasks.where((t) => t.done).length;
            final progress = listTasks.isEmpty ? 0.0 : done / listTasks.length;
            final overdue =
                listTasks.where((t) => !t.done && _isOverdue(t.due)).length;

            return _listCard(
              entry.key,
              '${(progress * 100).toInt()}% selesai${overdue > 0 ? ' · $overdue terlambat' : ''} · ${listTasks.length} tugas',
              progress,
            );
          }),
        const SizedBox(height: 18),
        const Text('Tampilan pintar', style: TextStyle(color: accent)),
        const SizedBox(height: 8),
        _smartView(Icons.upcoming_rounded, '7 hari ke depan',
            '${tasks.where((t) => !t.done).length} tugas aktif'),
        _smartView(Icons.priority_high_rounded, 'Prioritas tinggi',
            '${tasks.where((t) => t.high && !t.done).length} tugas'),
        _smartView(Icons.check_circle_outline, 'Selesai',
            '${tasks.where((t) => t.done).length} tugas'),
      ],
    );
  }

  Color _smartTint(String title) {
    if (title.startsWith('7')) return sky;
    if (title.startsWith('Prioritas')) return peach;
    return mint;
  }

  Widget _smartView(IconData icon, String title, String subtitle) => Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            color: _smartTint(title), borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          onTap: _search,
          leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: surface, borderRadius: BorderRadius.circular(11)),
              child: Icon(icon, color: accent, size: 20)),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle:
              Text(subtitle, style: TextStyle(fontSize: 11.5, color: muted)),
          trailing: Icon(Icons.chevron_right_rounded, color: muted),
        ),
      );

  Widget _listCard(String name, String meta, double progress) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: line)),
        color: sky,
        child: InkWell(
          onTap: _search,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(13)),
                      child:
                          const Icon(Icons.folder_copy_rounded, color: accent)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(name,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600))),
                  Icon(Icons.arrow_forward_ios_rounded, size: 15, color: muted),
                ]),
                const SizedBox(height: 12),
                Text(meta, style: TextStyle(color: muted, fontSize: 12)),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: progress,
                  color: accent,
                  backgroundColor: line,
                ),
              ],
            ),
          ),
        ),
      );

  // ==================== TIMELINE TAB ====================

  Widget _timeline() {
    final now = DateTime.now();

    // Generate week days centered on selected date
    final weekDays = List.generate(7, (i) {
      final date = selectedDate.add(Duration(days: i - 3));
      const dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
      final isSelected = date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day;
      final isToday = date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
      return (dayNames[date.weekday % 7], date.day, date, isSelected, isToday);
    });

    // Filter tasks for selected date
    final selectedDateTasks = _getTasksForDate(selectedDate);
    final pendingTasks = selectedDateTasks.where((t) => !t.done).toList();
    final doneTasks = selectedDateTasks.where((t) => t.done).toList();

    return _page(
      'Jadwal',
      actions: [
        IconButton(
          onPressed: () => _selectCalendarDate(),
          icon: const Icon(Icons.calendar_month_outlined),
        ),
        IconButton(
          onPressed: () {
            setState(() => selectedDate = DateTime.now());
          },
          icon: const Icon(Icons.today_outlined),
        ),
      ],
      children: [
        // Month/Year header with navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  selectedDate = selectedDate.subtract(const Duration(days: 7));
                });
              },
              icon: Icon(Icons.chevron_left_rounded, color: muted),
            ),
            GestureDetector(
              onTap: () => _selectCalendarDate(),
              child: Text(
                '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
                style: TextStyle(
                  color: muted,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  selectedDate = selectedDate.add(const Duration(days: 7));
                });
              },
              icon: Icon(Icons.chevron_right_rounded, color: muted),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Week day selector
        Row(
          children: weekDays.map((entry) {
            final (dayName, dayNum, date, isSelected, isToday) = entry;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedDate = date),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accent
                        : isToday
                            ? appTheme.accentTint
                            : surface,
                    borderRadius: BorderRadius.circular(14),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: isToday ? accent : line,
                            width: isToday ? 2 : 1,
                          ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white70
                              : isToday
                                  ? accent
                                  : muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : isToday
                                  ? accent
                                  : text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Selected date info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: appTheme.accentTint,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.event_note_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDateFull(selectedDate),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pendingTasks.length} tugas tertunda${doneTasks.isNotEmpty ? ' · ${doneTasks.length} selesai' : ''}',
                      style: TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _quickAddForDate(selectedDate),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah'),
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Tasks for selected date
        if (selectedDateTasks.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_available_rounded,
                      size: 64, color: muted.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada tugas untuk tanggal ini',
                    style: TextStyle(color: muted),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _quickAddForDate(selectedDate),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah tugas'),
                  ),
                ],
              ),
            ),
          )
        else ...[
          if (pendingTasks.isNotEmpty) ...[
            Text(
              'Tertunda · ${pendingTasks.length}',
              style: const TextStyle(
                color: accent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ...pendingTasks.map((t) => _timelineTaskCard(t)),
          ],
          if (doneTasks.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Selesai · ${doneTasks.length}',
              style: TextStyle(
                color: muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ...doneTasks.map((t) => _timelineTaskCard(t)),
          ],
        ],
      ],
    );
  }

  Widget _timelineTaskCard(Task t) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: t.done ? appTheme.mintTint : surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: t.high && !t.done ? const Color(0xFFF5C487) : line,
          ),
        ),
        child: ListTile(
          onTap: () => _detail(t),
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _toggleTask(t),
            icon: Icon(
              t.done
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: t.done ? const Color(0xFF10A57A) : accent,
            ),
          ),
          title: Text(
            t.title,
            style: TextStyle(
              fontSize: 15,
              decoration: t.done ? TextDecoration.lineThrough : null,
              color: t.done ? muted : text,
            ),
          ),
          subtitle: Text(
            '${t.list}${t.high ? ' · Prioritas' : ''}',
            style: TextStyle(color: muted, fontSize: 12),
          ),
          trailing: t.high && !t.done
              ? const Icon(Icons.flag, color: Colors.orange, size: 18)
              : null,
        ),
      );

  List<Task> _getTasksForDate(DateTime date) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final selectedStart = DateTime(date.year, date.month, date.day);
    final isToday = selectedStart == todayStart;
    final isTomorrow = selectedStart == todayStart.add(const Duration(days: 1));
    final isThisWeek = selectedStart.isAfter(todayStart) &&
        selectedStart.isBefore(todayStart.add(const Duration(days: 7)));

    return tasks.where((t) {
      final due = t.due.toLowerCase();
      if (isToday && due == 'hari ini') return true;
      if (isTomorrow && due == 'besok') return true;
      if (isThisWeek && due == 'minggu ini') return true;
      // Check for specific date match
      if (due.contains('${date.day}/${date.month}') ||
          due.contains('${date.day}-${date.month}')) {
        return true;
      }
      return false;
    }).toList();
  }

  String _formatDateFull(DateTime date) {
    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    if (selected == today) return 'Hari ini';
    if (selected == today.add(const Duration(days: 1))) return 'Besok';
    if (selected == today.subtract(const Duration(days: 1))) return 'Kemarin';

    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month - 1]}';
  }

  Future<void> _selectCalendarDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: accent,
              onPrimary: Colors.white,
              surface: surface,
              onSurface: text,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _quickAddForDate(DateTime date) async {
    final controller = TextEditingController();
    final listController = TextEditingController(text: 'Inbox');
    bool isHigh = false;

    final dueText = _formatDateFull(date);

    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            18,
            20,
            MediaQuery.of(context).viewInsets.bottom + 22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Tambah tugas untuk $dueText',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => setModalState(() {}),
                decoration: InputDecoration(
                  hintText: 'Apa yang perlu dikerjakan?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: listController,
                decoration: InputDecoration(
                  labelText: 'Daftar',
                  prefixIcon: const Icon(Icons.folder_outlined, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FilterChip(
                label: const Text('Prioritas tinggi'),
                selected: isHigh,
                onSelected: (v) => setModalState(() => isHigh = v),
                selectedColor: accentDark,
                avatar: Icon(
                  Icons.flag,
                  color: isHigh ? Colors.orange : muted,
                  size: 18,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: controller.text.trim().isNotEmpty
                      ? () => Navigator.pop(context, true)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('Tambah tugas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (added == true && controller.text.trim().isNotEmpty) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: controller.text.trim(),
        list: listController.text.trim().isEmpty
            ? 'Inbox'
            : listController.text.trim(),
        due: dueText == 'Hari ini' || dueText == 'Besok'
            ? dueText
            : '${date.day}/${date.month}/${date.year}',
        high: isHigh,
      );
      _addTask(task);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }

  // ==================== FOCUS TAB ====================

  Widget _focus() {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    final focusTask = tasks.where((t) => !t.done && t.high).firstOrNull ??
        tasks.where((t) => !t.done).firstOrNull;
    final completed = tasks.where((t) => t.done).length;
    final remaining = tasks.where((t) => !t.done).length;
    final priorities = tasks.where((t) => t.high && !t.done).length;

    return _page(
      'Fokus',
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6255E7), Color(0xFF8479F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child:
                    const Icon(Icons.auto_awesome_rounded, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        focusTask?.high == true
                            ? 'PRIORITAS UTAMA'
                            : 'SESI BERIKUTNYA',
                        style: const TextStyle(
                            color: Color(0xFFDCD9FF),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1)),
                    const SizedBox(height: 5),
                    Text(
                      focusTask?.title ?? 'Pilih tugas untuk memulai',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed:
                    focusTask == null ? _quickAdd : () => _detail(focusTask),
                icon: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Center(
          child: Container(
            width: 278,
            height: 278,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: accentDark,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD9D5FF), width: 8),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 210,
                  height: 210,
                  child: CircularProgressIndicator(
                    value: 1 - seconds / 2700,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    color: accent,
                    backgroundColor: Colors.white,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('WAKTU FOKUS',
                        style: TextStyle(
                            color: muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.3)),
                    const SizedBox(height: 6),
                    Text('$mins:$secs',
                        style: const TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -2)),
                    const SizedBox(height: 3),
                    Text(running ? 'Sedang berlangsung' : 'Siap untuk mulai',
                        style: TextStyle(color: muted, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: focusTask != null ? _startTimer : null,
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: Icon(
                    running ? Icons.pause_rounded : Icons.play_arrow_rounded),
                label: Text(running ? 'Jeda sesi' : 'Mulai fokus'),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  seconds = 2700;
                  running = false;
                });
                timer?.cancel();
                _toast('Timer diatur ulang ke 45 menit');
              },
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              child: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Ringkasan hari ini',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: [
            _focusMetric('$completed', 'selesai', mint, Icons.check_rounded),
            const SizedBox(width: 8),
            _focusMetric(
                '$remaining', 'tertunda', sky, Icons.timelapse_rounded),
            const SizedBox(width: 8),
            _focusMetric('$priorities', 'prioritas', peach, Icons.flag_rounded),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: line)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.wb_sunny_outlined, color: Color(0xFFFFA43B)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ruang untuk satu hal',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(
                        'Matikan gangguan dan kerjakan satu tugas kecil sampai tuntas.',
                        style: TextStyle(
                            color: muted, fontSize: 12, height: 1.35)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _focusMetric(String value, String label, Color color, IconData icon) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: text),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              Text(label, style: TextStyle(color: muted, fontSize: 10)),
            ],
          ),
        ),
      );

  // ==================== INSIGHTS TAB ====================

  Widget _insights() {
    final total = tasks.length;
    final done = tasks.where((t) => t.done).length;
    final pending = total - done;
    final high = tasks.where((t) => t.high).length;
    final highDone = tasks.where((t) => t.high && t.done).length;
    final rate = total > 0 ? (done / total * 100).toInt() : 0;

    // Group by list
    final listGroups = <String, int>{};
    for (final task in tasks) {
      listGroups[task.list] = (listGroups[task.list] ?? 0) + 1;
    }

    return _page(
      'Analisis',
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4C43C8), Color(0xFF7569F2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 112,
                height: 112,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 104,
                      height: 104,
                      child: CircularProgressIndicator(
                        value: rate / 100,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        color: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: .2),
                      ),
                    ),
                    Text('$rate%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PROGRES KAMU',
                        style: TextStyle(
                            color: Color(0xFFDCD9FF),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1)),
                    const SizedBox(height: 7),
                    Text(
                      total == 0
                          ? 'Mulai catat progresmu'
                          : rate >= 70
                              ? 'Kamu sedang melaju!'
                              : 'Sedikit lagi, lanjutkan.',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          height: 1.15),
                    ),
                    const SizedBox(height: 8),
                    Text('$done dari $total tugas telah selesai',
                        style: const TextStyle(
                            color: Color(0xFFE6E4FF), fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _insightMetric(
                '$done', 'selesai', mint, Icons.check_circle_rounded),
            const SizedBox(width: 9),
            _insightMetric(
                '$pending', 'tertunda', sky, Icons.hourglass_bottom_rounded),
            const SizedBox(width: 9),
            _insightMetric('$high', 'prioritas', peach, Icons.flag_rounded),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 17, 18, 15),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bar_chart_rounded, color: accent, size: 20),
                  const SizedBox(width: 8),
                  const Text('Sebaran tugas',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('per daftar',
                      style: TextStyle(color: muted, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 18),
              if (tasks.isEmpty)
                SizedBox(
                  height: 118,
                  child: Center(
                    child: Text('Belum ada data untuk ditampilkan',
                        style: TextStyle(color: muted)),
                  ),
                )
              else
                SizedBox(
                  height: 136,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: _buildChartBars(listGroups),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: high > 0 ? peach : mint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .72),
                    borderRadius: BorderRadius.circular(13)),
                child: Icon(
                    high > 0 ? Icons.bolt_rounded : Icons.rocket_launch_rounded,
                    color: high > 0
                        ? const Color(0xFFE47A28)
                        : const Color(0xFF0A9D78)),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        high > 0
                            ? 'Prioritas butuh perhatian'
                            : 'Siap membangun momentum',
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(
                      tasks.isEmpty
                          ? 'Tambahkan tugas pertama agar insight kamu mulai terbentuk.'
                          : high > 0
                              ? '$highDone dari $high tugas prioritas sudah terselesaikan. Mulai dari satu yang paling penting.'
                              : 'Tidak ada prioritas tinggi saat ini. Pilih satu tugas kecil untuk diselesaikan hari ini.',
                      style:
                          TextStyle(color: muted, fontSize: 12, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _insightMetric(
          String value, String label, Color color, IconData icon) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Column(
            children: [
              Icon(icon, size: 18, color: text),
              const SizedBox(height: 5),
              Text(value,
                  style: const TextStyle(
                      fontSize: 19, fontWeight: FontWeight.w800)),
              Text(label, style: TextStyle(color: muted, fontSize: 10)),
            ],
          ),
        ),
      );

  List<Widget> _buildChartBars(Map<String, int> listGroups) {
    if (listGroups.isEmpty) {
      return [const Expanded(child: SizedBox())];
    }

    final maxCount = listGroups.values.reduce((a, b) => a > b ? a : b);

    const barColors = [
      accent,
      Color(0xFF18B792),
      Color(0xFFFFA144),
      Color(0xFFEF6D91)
    ];
    return listGroups.entries.toList().asMap().entries.map((indexedEntry) {
      final entry = indexedEntry.value;
      final height = maxCount > 0 ? (entry.value / maxCount * 100) : 0.0;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${entry.value}', style: const TextStyle(fontSize: 10)),
              const SizedBox(height: 4),
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: barColors[indexedEntry.key % barColors.length],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(7)),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entry.key.length > 8
                    ? '${entry.key.substring(0, 8)}...'
                    : entry.key,
                style: TextStyle(fontSize: 9, color: muted),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // ==================== QUICK ADD (CREATE) ====================

  Future<void> _quickAdd() async {
    final controller = TextEditingController();
    final listController = TextEditingController(text: 'Inbox');
    String selectedDue = 'Hari ini';
    bool isHigh = false;

    final added = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            18,
            20,
            MediaQuery.of(context).viewInsets.bottom + 22,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Tambah tugas', style: TextStyle(fontSize: 21)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => setModalState(() {}),
                decoration: InputDecoration(
                  hintText: 'Apa yang perlu dikerjakan?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFFBFCFF),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: listController,
                      decoration: InputDecoration(
                        labelText: 'Daftar',
                        prefixIcon: const Icon(Icons.folder_outlined, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFFBFCFF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: line),
                    ),
                    child: DropdownButton<String>(
                      value: selectedDue,
                      underline: const SizedBox(),
                      items: ['Hari ini', 'Besok', 'Minggu ini', 'Nanti']
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setModalState(() => selectedDue = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Prioritas tinggi'),
                    selected: isHigh,
                    onSelected: (v) => setModalState(() => isHigh = v),
                    selectedColor: accentDark,
                    avatar: Icon(
                      Icons.flag,
                      color: isHigh ? Colors.orange : muted,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: controller.text.trim().isNotEmpty
                      ? () => Navigator.pop(context, true)
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Tambah tugas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (added == true && controller.text.trim().isNotEmpty) {
      final task = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: controller.text.trim(),
        list: listController.text.trim().isEmpty
            ? 'Inbox'
            : listController.text.trim(),
        due: selectedDue,
        high: isHigh,
      );
      _addTask(task);
    }
  }

  // ==================== NAVIGATION ====================

  void _detail(Task task) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailPage(
          task: task,
          onUpdate: (t) {
            _updateTask(t);
            setState(() {});
          },
          onDelete: (t) {
            _deleteTask(t);
          },
          onToggle: (t) {
            _toggleTask(t);
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {});
    }
  }

  void _search() => showSearch(
        context: context,
        delegate: TaskSearchDelegate(
          tasks,
          onSelect: _detail,
          onToggle: _toggleTask,
        ),
      );

  void _settings() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SettingsPage(
            onLogout: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('onboarded', false);
              setState(() => onboarding = true);
            },
            onReset: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('tasks');
              setState(() => tasks.clear());
              _toast('Semua tugas dihapus');
            },
            onExport: () async {
              final data = tasks.map((t) => t.toJson()).toList();
              const encoder = JsonEncoder.withIndent('  ');
              return encoder.convert(data);
            },
          ),
        ),
      );
}

// ==================== TASK DETAIL PAGE (UPDATE/DELETE) ====================

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({
    super.key,
    required this.task,
    required this.onUpdate,
    required this.onDelete,
    required this.onToggle,
  });
  final Task task;
  final void Function(Task) onUpdate;
  final void Function(Task) onDelete;
  final void Function(Task) onToggle;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  Task get task => widget.task;
  late TextEditingController titleController;
  late TextEditingController listController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: task.title);
    listController = TextEditingController(text: task.list);
  }

  @override
  void dispose() {
    titleController.dispose();
    listController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (titleController.text.trim().isEmpty) return;
    task.title = titleController.text.trim();
    task.list = listController.text.trim().isEmpty
        ? 'Inbox'
        : listController.text.trim();
    widget.onUpdate(task);
    setState(() => isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tugas diperbarui'),
        backgroundColor: accentDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(
          backgroundColor: bg,
          title: const Text('Detail Tugas'),
          actions: [
            if (isEditing)
              IconButton(
                onPressed: _saveChanges,
                icon: const Icon(Icons.check, color: accent),
              )
            else
              IconButton(
                onPressed: () => setState(() => isEditing = true),
                icon: const Icon(Icons.edit_outlined),
              ),
            IconButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    backgroundColor: surface,
                    title: const Text('Hapus tugas?'),
                    content: Text('Yakin ingin menghapus "${task.title}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent),
                        child: const Text('Hapus'),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  widget.onDelete(task);
                  Navigator.pop(context, 'deleted');
                }
              },
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (isEditing)
              TextField(
                controller: titleController,
                style: const TextStyle(fontSize: 24),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Judul tugas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            else
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 28,
                  decoration: task.done ? TextDecoration.lineThrough : null,
                  color: task.done ? muted : text,
                ),
              ),
            const SizedBox(height: 22),
            if (isEditing) ...[
              TextField(
                controller: listController,
                decoration: InputDecoration(
                  labelText: 'Daftar',
                  prefixIcon: const Icon(Icons.folder_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            _row(Icons.calendar_today_outlined, 'Jatuh tempo', task.due),
            if (!isEditing) _row(Icons.folder_outlined, 'Daftar', task.list),
            _row(Icons.priority_high, 'Prioritas',
                task.high ? 'Tinggi' : 'Normal'),
            _row(
              Icons.repeat,
              'Ulangi',
              task.repeat == 'Never' ? 'Tidak pernah' : 'Hari kerja',
            ),
            _row(
              Icons.sell_outlined,
              'Tag',
              task.tags.isEmpty ? 'Tidak ada' : task.tags.join(', '),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _selectDue(),
                  icon: const Icon(Icons.schedule),
                  label: const Text('Jadwalkan'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() => task.high = !task.high);
                    widget.onUpdate(task);
                  },
                  icon: Icon(
                    Icons.flag,
                    color: task.high ? Colors.orange : null,
                  ),
                  label: Text(task.high ? 'Normal' : 'Prioritas'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(
                      () => task.repeat =
                          task.repeat == 'Never' ? 'Weekdays' : 'Never',
                    );
                    widget.onUpdate(task);
                  },
                  icon: const Icon(Icons.repeat),
                  label: const Text('Ulangi'),
                ),
                OutlinedButton.icon(
                  onPressed: _addSubtask,
                  icon: const Icon(Icons.add),
                  label: const Text('Subtugas'),
                ),
              ],
            ),
            if (task.subtasks.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Subtugas · ${task.subDone} dari ${task.subtasks.length}',
                style: const TextStyle(color: accent),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                task.subtasks.length,
                (i) => Dismissible(
                  key: Key('subtask_${task.id}_$i'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red.shade700,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() => task.subtasks.removeAt(i));
                    widget.onUpdate(task);
                  },
                  child: CheckboxListTile(
                    value: task.subtasks[i].done,
                    onChanged: (value) {
                      setState(() => task.subtasks[i].done = value ?? false);
                      widget.onUpdate(task);
                    },
                    title: Text(
                      task.subtasks[i].title,
                      style: TextStyle(
                        decoration: task.subtasks[i].done
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.subtasks[i].done ? muted : text,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                widget.onToggle(task);
                Navigator.pop(context, 'updated');
              },
              style: FilledButton.styleFrom(
                backgroundColor: task.done ? accentDark : accent,
                foregroundColor: task.done ? text : Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(task.done ? Icons.replay : Icons.check_circle),
                  const SizedBox(width: 8),
                  Text(task.done ? 'Buka lagi tugas' : 'Tandai selesai'),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _row(IconData i, String a, String b) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(i, color: muted, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(a, style: TextStyle(color: muted)),
            ),
            Text(b),
          ],
        ),
      );

  Future<void> _selectDue() async {
    final options = [
      'Hari ini',
      'Besok',
      'Minggu ini',
      'Minggu depan',
      'Nanti'
    ];
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Pilih tanggal', style: TextStyle(fontSize: 18)),
          ),
          ...options.map(
            (opt) => ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: Text(opt),
              trailing: task.due == opt
                  ? const Icon(Icons.check, color: accent)
                  : null,
              onTap: () => Navigator.pop(context, opt),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );

    if (selected != null) {
      setState(() => task.due = selected);
      widget.onUpdate(task);
    }
  }

  Future<void> _addSubtask() async {
    final controller = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: surface,
        title: const Text('Tambah subtugas'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Nama subtugas',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
    if (saved == true && controller.text.trim().isNotEmpty) {
      setState(() => task.subtasks.add(Subtask(controller.text.trim())));
      widget.onUpdate(task);
    }
  }
}

// ==================== SEARCH ====================

class TaskSearchDelegate extends SearchDelegate {
  TaskSearchDelegate(this.tasks,
      {required this.onSelect, required this.onToggle});
  final List<Task> tasks;
  final void Function(Task) onSelect;
  final void Function(Task) onToggle;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(backgroundColor: bg),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: muted),
      ),
    );
  }

  @override
  List<Widget>? buildActions(c) => [
        IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(c) => IconButton(
        onPressed: () => close(c, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(c) => _list(c);

  @override
  Widget buildSuggestions(c) => _list(c);

  Widget _list(BuildContext context) {
    final found = tasks
        .where(
          (t) =>
              t.title.toLowerCase().contains(query.toLowerCase()) ||
              t.list.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    if (found.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 64, color: muted.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              query.isEmpty
                  ? 'Ketik untuk mencari tugas'
                  : 'Tidak ada tugas ditemukan',
              style: TextStyle(color: muted),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: found.length,
      itemBuilder: (context, index) {
        final t = found[index];
        return ListTile(
          leading: IconButton(
            icon: Icon(
              t.done ? Icons.check_circle : Icons.circle_outlined,
              color: t.done ? accent : muted,
            ),
            onPressed: () {
              onToggle(t);
              // Trigger rebuild
              query = query;
            },
          ),
          title: Text(
            t.title,
            style: TextStyle(
              decoration: t.done ? TextDecoration.lineThrough : null,
              color: t.done ? muted : text,
            ),
          ),
          subtitle: Text('${t.due} · ${t.list}'),
          trailing: t.high
              ? const Icon(Icons.flag, color: Colors.orange, size: 18)
              : null,
          onTap: () {
            close(context, null);
            onSelect(t);
          },
        );
      },
    );
  }
}

// ==================== SETTINGS ====================

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.onLogout,
    required this.onReset,
    required this.onExport,
  });
  final VoidCallback onLogout;
  final VoidCallback onReset;
  final Future<String> Function() onExport;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool sync = true;
  bool reminders = true;
  bool badge = false;
  bool biometric = false;
  bool biometricAvailable = false;
  String language = 'id';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    appLocale.addListener(_onLocaleChange);
  }

  @override
  void dispose() {
    appLocale.removeListener(_onLocaleChange);
    super.dispose();
  }

  void _onLocaleChange() {
    setState(() => language = appLocale.lang);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final bioAvailable = await BiometricService.checkAvailability();
    setState(() {
      sync = prefs.getBool('syncOffline') ?? true;
      reminders = prefs.getBool('reminders') ?? true;
      badge = prefs.getBool('appBadge') ?? false;
      biometric = BiometricService.isEnabled;
      biometricAvailable = bioAvailable;
      language = appLocale.lang;
      isLoading = false;
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: appTheme.accentTint,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = appTheme.isDark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bg,
        title: Text(t.settings),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: accent))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Account section
                Text(t.account, style: TextStyle(color: accent)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: line),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: appTheme.accentTint,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.person_outline, color: accent),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.localAccount,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, color: text)),
                            const SizedBox(height: 2),
                            Text(t.dataSavedLocally,
                                style: TextStyle(color: muted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Color(0xFF10A57A)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Preferences section
                Text(t.preferences, style: TextStyle(color: accent)),
                const SizedBox(height: 8),
                _settingsTile(
                  icon: Icons.sync_rounded,
                  title: t.offlineSync,
                  subtitle: t.offlineSyncDesc,
                  trailing: Switch(
                    value: sync,
                    onChanged: (v) {
                      setState(() => sync = v);
                      _saveSetting('syncOffline', v);
                      _showSnackBar(t.isId
                          ? (v
                              ? 'Sinkron offline aktif'
                              : 'Sinkron offline mati')
                          : (v
                              ? 'Offline sync enabled'
                              : 'Offline sync disabled'));
                    },
                    activeTrackColor: accent,
                  ),
                ),
                _settingsTile(
                  icon: Icons.notifications_outlined,
                  title: t.reminders,
                  subtitle: t.remindersDesc,
                  trailing: Switch(
                    value: reminders,
                    onChanged: (v) {
                      setState(() => reminders = v);
                      _saveSetting('reminders', v);
                      _showSnackBar(t.isId
                          ? (v ? 'Pengingat aktif' : 'Pengingat dimatikan')
                          : (v ? 'Reminders enabled' : 'Reminders disabled'));
                    },
                    activeTrackColor: accent,
                  ),
                ),
                _settingsTile(
                  icon: Icons.circle_notifications_outlined,
                  title: t.appBadge,
                  subtitle: t.appBadgeDesc,
                  trailing: Switch(
                    value: badge,
                    onChanged: (v) {
                      setState(() => badge = v);
                      _saveSetting('appBadge', v);
                      _showSnackBar(t.isId
                          ? (v ? 'Lencana aplikasi aktif' : 'Lencana dimatikan')
                          : (v ? 'App badge enabled' : 'App badge disabled'));
                    },
                    activeTrackColor: accent,
                  ),
                ),
                // Biometric lock (only show if available)
                if (biometricAvailable)
                  _settingsTile(
                    icon: Icons.fingerprint_rounded,
                    title: t.biometricLock,
                    subtitle: t.biometricDesc,
                    trailing: Switch(
                      value: biometric,
                      onChanged: (v) async {
                        if (v) {
                          // Authenticate first before enabling
                          final authenticated =
                              await BiometricService.authenticate(
                                  t.biometricReason);
                          if (!authenticated) {
                            _showSnackBar(t.biometricFailed);
                            return;
                          }
                        }
                        setState(() => biometric = v);
                        await BiometricService.setEnabled(v);
                        _showSnackBar(
                            v ? t.biometricEnabled : t.biometricDisabled);
                      },
                      activeTrackColor: accent,
                    ),
                  ),
                if (!biometricAvailable && !kIsWeb)
                  _settingsTile(
                    icon: Icons.fingerprint_rounded,
                    title: t.biometricLock,
                    subtitle: t.biometricNotAvailable,
                    trailing: Icon(Icons.block_rounded, color: muted),
                  ),
                const SizedBox(height: 24),

                // Appearance section
                Text(t.appearance, style: TextStyle(color: accent)),
                const SizedBox(height: 8),
                _settingsTile(
                  icon: isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: isDark ? t.darkMode : t.lightMode,
                  subtitle: isDark ? t.darkModeDesc : t.lightModeDesc,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (v) async {
                      await appTheme.toggle();
                      setState(() {});
                      _showSnackBar(t.isId
                          ? (v ? 'Mode gelap aktif' : 'Mode terang aktif')
                          : (v ? 'Dark mode enabled' : 'Light mode enabled'));
                    },
                    activeTrackColor: accent,
                  ),
                ),
                _settingsTile(
                  icon: Icons.language_rounded,
                  title: t.language,
                  subtitle: language == 'id' ? t.indonesian : t.english,
                  onTap: () => _showLanguageDialog(),
                  trailing: Icon(Icons.chevron_right_rounded, color: muted),
                ),
                const SizedBox(height: 24),

                // Data section
                Text(t.data, style: TextStyle(color: accent)),
                const SizedBox(height: 8),
                _settingsTile(
                  icon: Icons.download_rounded,
                  title: t.exportTasks,
                  subtitle: t.exportDesc,
                  onTap: () async {
                    final data = await widget.onExport();
                    if (mounted) {
                      showDialog(
                        context: context,
                        builder: (c) => AlertDialog(
                          backgroundColor: surface,
                          title: Text(t.exportData),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.yourTaskData,
                                    style: TextStyle(color: muted)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: bg,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: SelectableText(
                                    data,
                                    style: TextStyle(fontSize: 11, color: text),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c),
                              child: Text(t.close),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  trailing: Icon(Icons.chevron_right_rounded, color: muted),
                ),
                _settingsTile(
                  icon: Icons.delete_outline_rounded,
                  iconColor: Colors.redAccent,
                  title: t.deleteAllTasks,
                  subtitle: t.deleteAllDesc,
                  titleColor: Colors.redAccent,
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (c) => AlertDialog(
                        backgroundColor: surface,
                        title: Text('${t.deleteAllTasks}?'),
                        content: Text(t.deleteAllConfirm),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(c, false),
                            child: Text(t.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(c, true),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.redAccent),
                            child: Text(t.deleteAll),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && mounted) {
                      widget.onReset();
                      Navigator.pop(context);
                    }
                  },
                  trailing: Icon(Icons.chevron_right_rounded, color: muted),
                ),
                const SizedBox(height: 24),

                // Logout
                OutlinedButton.icon(
                  onPressed: () {
                    widget.onLogout();
                    Navigator.pop(context);
                  },
                  icon:
                      const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  label: Text(t.logout,
                      style: const TextStyle(color: Colors.redAccent)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    side: const BorderSide(color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 32),

                // App info
                Center(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset('assets/logo-rengse.png',
                            width: 48, height: 48),
                      ),
                      const SizedBox(height: 8),
                      Text('RENGSÉ',
                          style: TextStyle(
                              color: text,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                      Text('${t.version} 1.0.0',
                          style: TextStyle(color: muted, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('Dibuat dengan Flutter',
                          style: TextStyle(color: muted, fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    Color? titleColor,
  }) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: line),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: appTheme.accentTint,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor ?? accent, size: 20),
          ),
          title: Text(title,
              style: TextStyle(
                  color: titleColor ?? text, fontWeight: FontWeight.w500)),
          subtitle:
              Text(subtitle, style: TextStyle(color: muted, fontSize: 12)),
          trailing: trailing,
        ),
      );

  Future<void> _showLanguageDialog() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: surface,
        title: Text(t.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇮🇩', style: TextStyle(fontSize: 24)),
              title: const Text('Bahasa Indonesia'),
              trailing: language == 'id'
                  ? const Icon(Icons.check, color: accent)
                  : null,
              onTap: () => Navigator.pop(c, 'id'),
            ),
            ListTile(
              leading: const Text('🇺🇸', style: TextStyle(fontSize: 24)),
              title: const Text('English'),
              trailing: language == 'en'
                  ? const Icon(Icons.check, color: accent)
                  : null,
              onTap: () => Navigator.pop(c, 'en'),
            ),
          ],
        ),
      ),
    );
    if (selected != null && selected != language) {
      setState(() => language = selected);
      // Update global locale
      await appLocale.setLanguage(selected);
      _showSnackBar(selected == 'id'
          ? 'Bahasa diubah ke Indonesia'
          : 'Language changed to English');
    }
  }
}
