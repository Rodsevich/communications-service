#!/bin/bash
dart pub get
dart lib/tool/database_fixture.dart $1
npx prisma db pull
npx prisma generate
dart run build_runner build --delete-conflicting-outputs
npx prisma db push