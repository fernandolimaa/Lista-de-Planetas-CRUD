import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/planet.dart';

class PlanetFormPage extends StatefulWidget {
  final Planet? planet;

  const PlanetFormPage({Key? key, this.planet}) : super(key: key);

  @override
  _PlanetFormPageState createState() => _PlanetFormPageState();
}

class _PlanetFormPageState extends State<PlanetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.planet != null) {
      _nameController.text = widget.planet!.name;
      _distanceController.text = widget.planet!.distance.toString();
      _sizeController.text = widget.planet!.size.toString();
      _nicknameController.text = widget.planet!.nickname ?? '';
    }
  }

  void _savePlanet() async {
    if (_formKey.currentState!.validate()) {
      final newPlanet = Planet(
        id: widget.planet?.id,
        name: _nameController.text,
        distance: double.tryParse(_distanceController.text) ?? 0.0,
        size: double.tryParse(_sizeController.text) ?? 0.0,
        nickname: _nicknameController.text.isNotEmpty ? _nicknameController.text : null,
      );

      if (widget.planet == null) {
        await DatabaseHelper.instance.insertPlanet(newPlanet);
      } else {
        await DatabaseHelper.instance.updatePlanet(newPlanet);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.planet == null ? 'Adicionar Planeta' : 'Editar Planeta')),
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
                decoration: InputDecoration(labelText: 'Distância do Sol (AU)'),
                keyboardType: TextInputType.number,
                validator: (value) => (double.tryParse(value ?? '') ?? 0) > 0 ? null : 'Insira um número válido',
              ),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: TextInputType.number,
                validator: (value) => (double.tryParse(value ?? '') ?? 0) > 0 ? null : 'Insira um número válido',
              ),
              TextFormField(
                controller: _nicknameController,
                decoration: InputDecoration(labelText: 'Apelido (Opcional)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePlanet,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
