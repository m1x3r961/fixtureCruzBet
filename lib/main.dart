import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Punto de entrada principal de la aplicación.
/// Orden de inicialización:
/// 1. flutter_dotenv — carga .env desde los assets
/// 2. Supabase.initialize — inicializa el cliente con las credenciales del .env
/// 3. ProviderScope — envuelve toda la app para Riverpod
/// 4. MaterialApp.router — configura la navegación con GoRouter
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Cargar variables de entorno e inicializar locale
  await dotenv.load(fileName: '.env');
  await initializeDateFormatting('es', null);

  // 2. Inicializar Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
  );

  runApp(
    // 3. ProviderScope es el widget raíz de Riverpod
    const ProviderScope(
      child: FixtureCruzbetApp(),
    ),
  );
}

class FixtureCruzbetApp extends ConsumerWidget {
  const FixtureCruzbetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'CruzBet Mundial 2026',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
