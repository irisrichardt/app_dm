import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:app_dm/utils/constants.dart';

class CriarAtividadeScreen extends StatefulWidget {
  @override
  _CriarAtividadeScreenState createState() => _CriarAtividadeScreenState();
}

class _CriarAtividadeScreenState extends State<CriarAtividadeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  String? _status;
  String? _prioridade;
  int? _storyPoints;
  String? _equipeResponsavel;
  List<File>? _anexos = [];

  Future<void> _selecionarAnexos() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    // ignore: unnecessary_null_comparison
    if (pickedFiles != null) {
      setState(() {
        _anexos =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Criar nova atividade',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customBlue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Título',
                    hintText: 'Digite o título da atividade',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite um título';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descrição',
                    hintText: 'Digite a descrição da atividade',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, digite uma descrição';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Status',
                  ),
                  value: _status,
                  items:
                      ['Pendentes', 'Em andamento', 'Em revisão', 'Concluída']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione um status';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Prioridade',
                  ),
                  value: _prioridade,
                  items: ['Baixa', 'Média', 'Alta']
                      .map((prioridade) => DropdownMenuItem(
                            value: prioridade,
                            child: Text(prioridade),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _prioridade = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione uma prioridade';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Story Points',
                  ),
                  value: _storyPoints,
                  items: List.generate(10, (index) => index + 1)
                      .map((points) => DropdownMenuItem(
                            value: points,
                            child: Text(points.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _storyPoints = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione os story points';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Equipe Responsável',
                  ),
                  value: _equipeResponsavel,
                  items: ['Frontend', 'Backend', 'Infra']
                      .map((equipe) => DropdownMenuItem(
                            value: equipe,
                            child: Text(equipe),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _equipeResponsavel = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione uma equipe responsável';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: _selecionarAnexos,
                  child: Text(
                    'Selecionar Anexos',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                if (_anexos != null)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: _anexos!
                        .map((anexo) => Image.file(
                              anexo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ))
                        .toList(),
                  ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Atividade novaAtividade = Atividade(
                      //   titulo: _tituloController.text,
                      //   descricao: _descricaoController.text,
                      //   status: _status!,
                      //   prioridade: _prioridade!,
                      //   storyPoints: _storyPoints!,
                      //   equipeResponsavel: _equipeResponsavel!,
                      //   anexos: _anexos,
                      // );
                      // // Handle save activity logic here
                      // print('Atividade criada: ${novaAtividade.titulo}');
                      // Navigator.pop(context); // Voltar para a tela anterior
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customBlue, // Cor de fundo roxa
                    foregroundColor: Colors.white, // Cor do texto branca
                  ),
                  child: Text('Salvar Atividade'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
