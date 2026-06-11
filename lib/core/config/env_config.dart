import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centraliza el acceso a las variables de entorno.
/// Lanza un error descriptivo si faltan variables críticas.
class EnvConfig {
  EnvConfig._();

  static String get supabaseUrl =>
      dotenv.env['SUPABASE_URL'] ??
      (throw StateError('SUPABASE_URL no está definido en .env'));

  static String get supabaseAnonKey =>
      dotenv.env['SUPABASE_ANON_KEY'] ??
      (throw StateError('SUPABASE_ANON_KEY no está definido en .env'));

  static String get apiFootballKey =>
      dotenv.env['API_FOOTBALL_KEY'] ??
      (throw StateError('API_FOOTBALL_KEY no está definido en .env'));

  static String get apiFootballBaseUrl =>
      dotenv.env['API_FOOTBALL_BASE_URL'] ??
      'https://v3.football.api-sports.io';

  static int get worldCupLeagueId =>
      int.tryParse(dotenv.env['WORLD_CUP_LEAGUE_ID'] ?? '1') ?? 1;

  static int get worldCupSeason =>
      int.tryParse(dotenv.env['WORLD_CUP_SEASON'] ?? '2026') ?? 2026;
}
