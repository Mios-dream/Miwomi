import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Card List Example'),
        ),
        body: CardList(),
      ),
    );
  }
}

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  final List<String> _cards = [
    'Card 1',
    'Card 2',
    'Card 3',
    'Card 4',
    'Card 5',
  ];

  void _deleteCard(String cardToDelete) {
    setState(() {
      _cards.remove(cardToDelete);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _cards.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(_cards[index]),
          onDismissed: (direction) {
            final cardToDelete = _cards[index];
            _deleteCard(cardToDelete);
          },
          background: Container(
            color: Colors.red,
            child: const Center(
              child: Text(
                'Swipe to delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          child: Card(
            child: ListTile(
              title: Text(_cards[index]),
            ),
          ),
        );
      },
    );
  }
}
