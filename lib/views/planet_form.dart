import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../database/database_helper.dart';

class PlanetForm extends StatefulWidget {
  final Planet? planet;

  const PlanetForm({Key? key, this.planet}) : super(key: key);

  @override
  _PlanetFormState createState() => _PlanetFormState();
}

class _PlanetFormState extends State<PlanetForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _distanceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _nicknameController = TextEditingController();

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

  Future<void> _savePlanet() async {
    if (_formKey.currentState!.validate()) {
      final planet = Planet(
        id: widget.planet?.id,
        name: _nameController.text,
        distance: double.parse(_distanceController.text),
        size: double.parse(_sizeController.text),
        nickname: _nicknameController.text.isEmpty ? null : _nicknameController.text,
      );

      if (widget.planet == null) {
        await DatabaseHelper.instance.insertPlanet(planet);
      } else {
        await DatabaseHelper.instance.updatePlanet(planet);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.planet == null ? 'Novo Planeta' : 'Editar Planeta')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) => value!.isEmpty ? 'Preencha o nome' : null,
              ),
              TextFormField(
                controller: _distanceController,
                decoration: InputDecoration(labelText: 'Distância do Sol (UA)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || double.tryParse(value) == null
                    ? 'Insira um número válido'
                    : null,
              ),
              TextFormField(
                controller: _sizeController,
                decoration: InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || double.tryParse(value) == null
                    ? 'Insira um número válido'
                    : null,
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
