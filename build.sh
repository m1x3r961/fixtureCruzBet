#!/bin/bash

echo "Clonando Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Instalando dependencias..."
flutter/bin/flutter pub get

echo "Construyendo Flutter Web..."
flutter/bin/flutter build web --release

echo "Construcción completada."
