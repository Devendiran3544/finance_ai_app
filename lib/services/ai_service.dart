abstract class AiService {
  Future<String> getFinancialInsight(List<dynamic> transactions);
  Future<String> categorizeTransaction(String description);
}

class MockAiService implements AiService {
  @override
  Future<String> getFinancialInsight(List<dynamic> transactions) async {
    await Future.delayed(const Duration(seconds: 1));
    return "Based on your recent activity, you've spent 15% more on Dining than last week. Consider cooking at home to save ~\$50.";
  }

  @override
  Future<String> categorizeTransaction(String description) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lower = description.toLowerCase();
    if (lower.contains('uber') || lower.contains('bus') || lower.contains('fuel')) {
      return 'Transport';
    } else if (lower.contains('food') || lower.contains('restaurant') || lower.contains('burger')) {
      return 'Dining';
    } else if (lower.contains('netflix') || lower.contains('movie')) {
      return 'Entertainment';
    }
    return 'General';
  }
}
