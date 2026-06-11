#!/bin/bash

echo "Clonando Flutter SDK (shallow clone)..."
git clone -b 3.27.0 --depth 1 https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"

echo "Limpiando y preparando..."
flutter/bin/flutter clean
flutter/bin/flutter pub get

echo "Construyendo Flutter Web (optimizando memoria)..."
# Usamos html renderer y desactivamos tree-shake para ahorrar RAM en los servidores de Vercel
flutter/bin/flutter build web --release --web-renderer html --tree-shake-icons=false

echo "Construcción completada."
