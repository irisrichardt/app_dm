import 'package:flutter/material.dart';

import 'AtividadesScreen.dart';

class Home extends StatefulWidget {
  final String userName;

  const Home({required this.userName, Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedButton = 0;
  String _selectedText = 'Minhas Atividades';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atividades',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Suas atividades recentes',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Ação ao clicar no ícone de menu
            print('Menu icon clicked');
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/300'),
              radius: 18,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Bem-vindo, ${widget.userName}!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 220,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildOptionCard('Atividades Frontend'),
                    _buildOptionCard('Atividades Backend'),
                    _buildOptionCard('Gerenciar equipes'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildButton(0, 'Minhas Atividades'),
                  SizedBox(width: 10),
                  _buildButton(1, 'Em andamento'),
                  SizedBox(width: 10),
                  _buildButton(2, 'Em revisão'),
                  SizedBox(width: 10),
                  _buildButton(3, 'Concluídas'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _selectedText,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildActivityItem('Frontend Task 1'),
                  _buildActivityItem('Frontend Task 2'),
                  _buildActivityItem('Backend Task 1'),
                  _buildActivityItem('Backend Task 2'),
                  _buildActivityItem('Manage Team Task 1'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AtividadesScreen(categoryName: title),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildButton(int index, String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedButton = index;
          _selectedText = text;
        });
        print('$text clicado');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedButton == index ? Colors.white : Colors.grey,
        side: _selectedButton == index
            ? BorderSide(color: Colors.grey, width: 2)
            : BorderSide.none,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: _selectedButton == index ? Colors.grey : Colors.white,
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(activity),
        onTap: () {
          print('$activity foi clicado');
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Home(userName: 'Usuário'),
  ));
}
