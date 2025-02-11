import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../database/database_helper.dart';

class PlanetDetailsPage extends StatefulWidget {
  final Planet planet;
  final VoidCallback onSave;
  final VoidCallback onUpdate; // ✅ Adicionado para atualizar a lista na HomePage

  PlanetDetailsPage({
    required this.planet,
    required this.onSave,
    required this.onUpdate, // ✅ Agora a função será usada corretamente
  });

  @override
  _PlanetDetailsPageState createState() => _PlanetDetailsPageState();
}

class _PlanetDetailsPageState extends State<PlanetDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _distanceController;
  late TextEditingController _sizeController;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.planet.name);
    _distanceController = TextEditingController(text: widget.planet.distance.toString());
    _sizeController = TextEditingController(text: widget.planet.size.toString());
    _nicknameController = TextEditingController(text: widget.planet.nickname);
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedPlanet = Planet(
        id: widget.planet.id,
        name: _nameController.text,
        distance: double.parse(_distanceController.text),
        size: double.parse(_sizeController.text),
        nickname: _nicknameController.text.isEmpty ? null : _nicknameController.text,
      );
      await DatabaseHelper.instance.updatePlanet(updatedPlanet);
      widget.onSave();
      widget.onUpdate(); // ✅ Atualiza a lista na HomePage
      Navigator.pop(context);
    }
  }

  Future<void> _deletePlanet() async {
    if (widget.planet.id != null) {
      await DatabaseHelper.instance.deletePlanet(widget.planet.id!);
      widget.onUpdate(); // ✅ Atualiza a HomePage após excluir
      Navigator.pop(context); // ✅ Fecha a tela de detalhes
    } else {
      print("🚨 Erro: ID do planeta é nulo!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes de ${widget.planet.name}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome do Planeta'),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _distanceController,
                decoration: InputDecoration(labelText: 'Distância do Sol (UA)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: 'Tamanho (Km)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'Apelido (Opcional)'),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _saveChanges,
                    icon: Icon(Icons.save),
                    label: Text('Salvar'),
                  ),
                  ElevatedButton.icon(
                    onPressed: _deletePlanet,
                    icon: Icon(Icons.delete, color: Colors.white),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    label: Text('Excluir'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
