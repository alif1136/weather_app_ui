import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final void Function(String) onSearch;
  final String initialCity;

  const SearchInput({
    super.key,
    required this.onSearch,
    this.initialCity = 'Dhaka',
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCity);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _doSearch() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) widget.onSearch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.23),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white70),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search city...",
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    onSubmitted: (_) => _doSearch(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _doSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          child: const Text("Go",
          style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),
          ),

        )
      ],
    );
  }
}
