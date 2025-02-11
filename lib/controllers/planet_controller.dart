import '../models/planet.dart';
import '../database/database_helper.dart';

class PlanetController {
  Future<void> addPlanet(Planet planet) async {
    print("🌍 Tentando adicionar planeta: ${planet.name}");

    try {
      await DatabaseHelper.instance.insertPlanet(planet);
      print("✅ Planeta ${planet.name} adicionado com sucesso!");
    } catch (e) {
      print("❌ Erro ao adicionar planeta: $e");
    }
  }

  Future<List<Planet>> getPlanets() async {
    return await DatabaseHelper.instance.getPlanets();
  }
}
