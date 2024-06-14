import 'package:flutter/material.dart';

class AtividadesScreen extends StatelessWidget {
  final String categoryName;

  const AtividadesScreen({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Atividade ${index + 1}'),
                  onTap: () {
                    print('Atividade ${index + 1} clicada');
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                print('Novo Atividade clicado');
              },
              child: Text('Nova Atividade'),
            ),
          ),
        ],
      ),
    );
  }
}
