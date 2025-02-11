import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../database/database_helper.dart';
import 'planet_details_page.dart';
import '../controllers/planet_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Planet> _planets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlanets();
  }

  Future<void> _loadPlanets() async {
    final planets = await DatabaseHelper.instance.getPlanets();
    print("Planetas carregados: ${planets.length}");

    setState(() {
      _planets = planets;
      _isLoading = false;
    });
  }
  final PlanetController _controller = PlanetController();

  void _addPlanet() async {
    print("🛠️ Botão pressionado!");

    Planet novoPlaneta = Planet(
      name: "Novo Planeta",
      distance: 3.0,
      size: 5000,
      nickname: "Desconhecido",
    );

    await _controller.addPlanet(novoPlaneta);
    _refreshPlanets();
  }

  void _refreshPlanets() async {
    List<Planet> updatedPlanets = await _controller.getPlanets();
    print("📊 Lista atualizada de planetas: ${updatedPlanets.length}");
    setState(() {
      _planets = updatedPlanets;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Planetas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _planets.isEmpty
          ? const Center(child: Text('Nenhum planeta cadastrado.'))
          : ListView.builder(
        itemCount: _planets.length,
        itemBuilder: (context, index) {
          final planet = _planets[index];
          return Card(
            child: ListTile(
              title: Text(planet.name),
              subtitle: Text(planet.nickname ?? "Sem apelido"),
              trailing: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanetDetailsPage(
                      planet: planet,
                      onSave: () {}, // Pode ser uma função vazia se não precisar atualizar na tela de detalhes
                      onUpdate: _loadPlanets, // ✅ Atualiza a lista na HomePage
                    ),
                  ),
                ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/addPlanet');
          if (result == true) _loadPlanets();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
