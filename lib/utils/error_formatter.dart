/// Utility function to convert technical error messages to user-friendly messages
String getUserFriendlyErrorMessage(String errorMessage) {
  final lowerMessage = errorMessage.toLowerCase();

  // Network-related errors
  if (lowerMessage.contains('socket') ||
      lowerMessage.contains('network') ||
      lowerMessage.contains('connection refused')) {
    return 'Tidak dapat terhubung ke jaringan. Periksa koneksi internet Anda.';
  }

  // Timeout errors
  if (lowerMessage.contains('timeout') || lowerMessage.contains('timed out')) {
    return 'Permintaan memakan waktu terlalu lama. Silakan coba lagi.';
  }

  // Failed to load errors
  if (lowerMessage.contains('failed to load') ||
      lowerMessage.contains('failed to search')) {
    return 'Tidak dapat memuat data. Silakan coba lagi.';
  }

  // Server errors
  if (lowerMessage.contains('500') || lowerMessage.contains('server error')) {
    return 'Server sedang mengalami masalah. Silakan coba lagi nanti.';
  }

  // Not found errors
  if (lowerMessage.contains('404') || lowerMessage.contains('not found')) {
    return 'Data yang Anda cari tidak ditemukan.';
  }

  // Default user-friendly message
  return 'Terjadi kesalahan. Silakan coba lagi.';
}
