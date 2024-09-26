import 'package:flutter/material.dart';
import '../services/books_service.dart';

class BookProvider with ChangeNotifier {
  List<dynamic> _books = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get books => _books;

  bool get isLoading => _isLoading;

  String? get error => _error;

  final BookService _bookService = BookService();

  Future<void> loadBooks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _books = await _bookService.fetchBooks();
    } catch (e) {
      _error = e.toString();
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sortBooks(int Function(dynamic a, dynamic b) compare) {
    _books.sort(compare);
    notifyListeners();
  }
}
