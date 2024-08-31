// presentation/widgets/pagination_control.dart

import 'package:flutter/material.dart';

class PaginationControl extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onFirstPage;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onLastPage;

  const PaginationControl({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.onFirstPage,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onLastPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.first_page),
          onPressed: currentPage > 1 ? onFirstPage : null,
        ),
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: currentPage > 1 ? onPreviousPage : null,
        ),
        Text(
          '$currentPage / $totalPages',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: currentPage < totalPages ? onNextPage : null,
        ),
        IconButton(
          icon: Icon(Icons.last_page),
          onPressed: currentPage < totalPages ? onLastPage : null,
        ),
      ],
    );
  }
}
