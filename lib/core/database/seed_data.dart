import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../utils/password_hasher.dart';

const _uuid = Uuid();

const kMockProviderCount = 5;

Future<void> seedMockProviders(Database db) async {
  final now = DateTime.now().toUtc().toIso8601String();

  final mocks = [
    (
      name: 'Carlos Silva',
      email: 'mock1@praja.local',
      cpf: '11111111111',
      phone: '11999990001',
      profession: 'Eletricista',
      specialty: 'Eletricista',
      address: 'Rua das Flores, 100 - São Paulo, SP',
      description: 'Instalações elétricas residenciais e comerciais.',
    ),
    (
      name: 'Ana Souza',
      email: 'mock2@praja.local',
      cpf: '22222222222',
      phone: '11999990002',
      profession: 'Encanador',
      specialty: 'Encanador',
      address: 'Av. Central, 250 - São Paulo, SP',
      description: 'Reparos hidráulicos e manutenção preventiva.',
    ),
    (
      name: 'Roberto Lima',
      email: 'mock3@praja.local',
      cpf: '33333333333',
      phone: '11999990003',
      profession: 'Pintor',
      specialty: 'Pintor',
      address: 'Rua Nova, 45 - São Paulo, SP',
      description: 'Pintura interna e externa com acabamento premium.',
    ),
    (
      name: 'Fernanda Costa',
      email: 'mock4@praja.local',
      cpf: '44444444444',
      phone: '11999990004',
      profession: 'Diarista',
      specialty: 'Diarista',
      address: 'Rua Verde, 12 - São Paulo, SP',
      description: 'Limpeza residencial e organização de ambientes.',
    ),
    (
      name: 'Marcos Oliveira',
      email: 'mock5@praja.local',
      cpf: '55555555555',
      phone: '11999990005',
      profession: 'Técnico de informática',
      specialty: 'Técnico de informática',
      address: 'Av. Tech, 500 - São Paulo, SP',
      description: 'Suporte técnico, redes e manutenção de computadores.',
    ),
  ];

  for (final mock in mocks) {
    final userId = _uuid.v4();
    await db.insert('users', {
      'id': userId,
      'email': mock.email,
      'password_hash': hashPassword('mock123'),
      'name': mock.name,
      'cpf': mock.cpf,
      'birth_date': '1990-01-15',
      'phone': mock.phone,
      'user_type': 'provider',
      'created_at': now,
    });

    await db.insert('provider_profiles', {
      'user_id': userId,
      'profession': mock.profession,
      'specialty': mock.specialty,
      'address': mock.address,
      'description': mock.description,
      'is_complete': 1,
    });
  }
}
