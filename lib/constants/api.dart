class ApiConstants {
  // For Android Emulator — 10.0.2.2 maps to your PC's localhost
  // For physical device — replace with your PC's local IP (currently 10.71.223.23)
  // For production — replace with your deployed URL
  
  static const String baseUrl = 'http://10.71.223.23:5000/api';
  static const String socketUrl = 'http://10.71.223.23:5000';
  
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';
  
  // Machines
  static const String machines = '/machines';
  
  // Jobs / Service Requests
  static const String broadcast = '/jobs/broadcast';
  static const String myJobs = '/jobs/my';
  static const String radar = '/jobs/radar';
  
  // Quotes
  static String quotes(String jobId) => '/jobs/$jobId/quotes';
  static String approveQuote(String jobId, String quoteId) => '/jobs/$jobId/quotes/$quoteId/approve';
  static String cancelJob(String jobId) => '/jobs/$jobId/cancel';
  static String confirmComplete(String jobId) => '/jobs/$jobId/confirm-complete';
  static String followUp(String jobId) => '/jobs/$jobId/follow-up';
  
  // Chat
  static const String chats = '/chat/list';
  static String chatMessages(String requestId) => '/chat/$requestId';
  
  // Payments
  static const String createOrder = '/payments/create-order';
  static const String verifyPayment = '/payments/verify';
  
  // Notifications
  static const String notifications = '/notifications';
  static const String markAllRead = '/notifications/read-all';
  
  // Profile
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
}
