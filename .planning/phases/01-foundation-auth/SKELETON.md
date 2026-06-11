# Walking Skeleton — praJa

**Phase:** 1
**Generated:** 2026-06-07

## Capability Proven End-to-End

Um usuário consegue criar conta (cliente ou prestador), fazer login com email/senha, e ser direcionado para a tela inicial correta — com prestadores mockados já persistidos no SQLite local.

## Architectural Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Framework | Flutter 3.x (Material 3) | Stack definido no PROJECT.md; mobile MVP offline |
| State management | flutter_bloc + freezed | Conforme skills do projeto |
| DI | get_it service locator | Padrão clean architecture do repo |
| Error handling | dartz Either<Failure, T> | Conforme clean-architecture skill |
| Data layer | sqflite (SQLite local) | MVP 100% offline |
| Navigation | go_router | Rotas declarativas + redirect por sessão |
| Auth storage | shared_preferences (session user id) + password hash (bcrypt/crypto) | Sessão local sem backend |
| Directory layout | feature-first: `lib/core/`, `lib/features/{auth,home}/` | Clean architecture skill |

## Stack Touched in Phase 1

- [x] Project scaffold (Flutter, analysis_options, pubspec deps)
- [x] Routing — login, register, client home, provider home
- [x] Database — SQLite open + seed write + user read/write on register/login
- [x] UI — login/register forms wired to use cases; home shells com lista mock
- [x] Deployment — `flutter run` local (sem backend)

## Out of Scope (Deferred to Later Slices)

- Busca por especialidade e envio de solicitação (Phase 2)
- Gestão de status de solicitações (Phase 3)
- Chat completo (Phase 4)
- Logout, recuperação de senha, verificação de email
- Dark mode

## Subsequent Slice Plan

- Phase 2: Cliente busca prestadores e envia solicitação
- Phase 3: Prestador gerencia solicitações (Aguardando → Trabalhando → Concluído)
- Phase 4: Chat local entre cliente e prestador
