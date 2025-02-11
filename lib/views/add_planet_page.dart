import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../database/database_helper.dart';

class AddPlanetPage extends StatefulWidget {
  @override
  _AddPlanetPageState createState() => _AddPlanetPageState();
}

class _AddPlanetPageState extends State<AddPlanetPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _distanceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _nicknameController = TextEditingController();

  void _savePlanet() async {
    if (_formKey.currentState!.validate()) {
      Planet newPlanet = Planet(
        name: _nameController.text,
        distance: double.parse(_distanceController.text),
        size: double.parse(_sizeController.text),
        nickname: _nicknameController.text.isEmpty ? null : _nicknameController.text,
      );

      await DatabaseHelper.instance.insertPlanet(newPlanet);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Planeta")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nome"),
                validator: (value) => value!.isEmpty ? "Digite um nome" : null,
              ),
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(labelText: "Distância (UA)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Digite a distância" : null,
              ),
              TextFormField(
                controller: _sizeController,
                decoration: const InputDecoration(labelText: "Tamanho (km)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Digite o tamanho" : null,
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: "Apelido (opcional)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePlanet,
                child: const Text("Salvar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
