---
phase: 03-provider-request-management
plan: 01
subsystem: provider-home
tags: [flutter, bloc, sqlite, service-requests]

requires:
  - phase: 02-client-discovery-requests
    provides: service_requests table and request creation
provides:
  - Provider request list filtered by provider_id
  - Status workflow Aguardando -> Trabalhando -> Concluído
  - Immediate list refresh after status changes
affects: [04 chat list integration]

requirements-completed: [REQ-02, REQ-03]

completed: 2026-06-08
---

# Phase 3 Plan 01 Summary

**Gestão de solicitações pelo prestador com ciclo de status**

## Accomplishments

- Home do prestador agora carrega solicitações reais do SQLite para o `providerId` logado.
- `RequestRepository` ganhou consultas por prestador e atualização de status.
- Workflow de status implementado: `Aguardando` → `Trabalhando` → `Concluído`.
- Lista do prestador atualiza após cada avanço de status.
- Cards exibem título, endereço, detalhes, data desejada e chip de status.

## Verification

- `flutter analyze` — pass
- `flutter test` — pass (20 tests)

## Key Files

- `lib/features/home/presentation/pages/provider_home_page.dart`
- `lib/features/home/presentation/bloc/provider_home_bloc.dart`
- `lib/features/requests/data/datasources/request_local_datasource.dart`
- `lib/features/requests/data/repositories/request_repository_impl.dart`
- `lib/features/requests/domain/usecases/get_provider_requests.dart`
- `lib/features/requests/domain/usecases/update_request_status.dart`
- `test/features/home/presentation/bloc/provider_home_bloc_test.dart`
