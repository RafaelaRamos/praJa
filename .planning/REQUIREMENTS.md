# Requirements: praJa

**Defined:** 2026-06-07
**Core Value:** Cliente encontra prestador por especialidade, envia solicitação e se comunica por chat — tudo localmente.

## v1 Requirements

### Authentication & Onboarding

- [ ] **AUTH-01**: Usuário pode se cadastrar com email, senha, nome, CPF, data de nascimento e telefone
- [ ] **AUTH-02**: Usuário pode escolher tipo de conta (cliente ou prestador) no cadastro
- [ ] **AUTH-03**: Cadastro de prestador exibe modal para profissão, especialidade, endereço e descrição
- [ ] **AUTH-04**: Usuário pode fazer login com email e senha
- [ ] **AUTH-05**: Sessão do usuário persiste localmente após login

### Provider Discovery (Cliente)

- [x] **DISC-01**: Cliente vê lista de todos os prestadores cadastrados no app
- [x] **DISC-02**: Cliente pode buscar prestadores por especialidade
- [ ] **DISC-03**: Cada item da lista de prestadores exibe ícone de mensagem para iniciar chat

### Service Requests

- [x] **REQ-01**: Cliente pode enviar solicitação a um prestador com título, endereço, detalhes e data desejada
- [x] **REQ-02**: Prestador vê lista de solicitações enviadas para ele
- [x] **REQ-03**: Prestador pode atualizar status da solicitação: Aguardando → Trabalhando → Concluído
- [ ] **REQ-04**: Cada item da lista de solicitações exibe ícone de mensagem para iniciar chat

### Chat

- [ ] **CHAT-01**: Usuário pode abrir chat a partir do ícone de mensagem em qualquer lista
- [ ] **CHAT-02**: Usuário pode enviar e receber mensagens no chat
- [ ] **CHAT-03**: Histórico de chat persiste localmente por conversa

### Data & Persistence

- [ ] **DATA-01**: App persiste dados localmente com SQLite
- [ ] **DATA-02**: App carrega prestadores mockados no primeiro launch (seed)

### Navigation

- [ ] **NAV-01**: Após login, cliente é direcionado para lista de prestadores
- [ ] **NAV-02**: Após login, prestador é direcionado para lista de solicitações

## v2 Requirements

### Authentication

- **AUTH-06**: Verificação de email após cadastro
- **AUTH-07**: Recuperação de senha por email

### Platform

- **SYNC-01**: Sincronização com backend/API
- **SYNC-02**: Notificações push para novas solicitações e mensagens

### Business

- **PAY-01**: Pagamentos in-app
- **REV-01**: Avaliações e reviews de prestadores
- **GEO-01**: Filtro de prestadores por proximidade/geolocalização

## Out of Scope

| Feature | Reason |
|---------|--------|
| Backend/API | MVP 100% local — validar UX antes de infra |
| Pagamentos | Complexidade fora do escopo inicial |
| Push notifications | Requer servidor externo |
| Verificação/recuperação de email | Requer servidor de email |
| Geolocalização | Busca apenas por especialidade no MVP |
| Reviews | Deferido para v2 |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTH-01 | Phase 1 | Pending |
| AUTH-02 | Phase 1 | Pending |
| AUTH-03 | Phase 1 | Pending |
| AUTH-04 | Phase 1 | Pending |
| AUTH-05 | Phase 1 | Pending |
| DATA-01 | Phase 1 | Pending |
| DATA-02 | Phase 1 | Pending |
| NAV-01 | Phase 1 | Pending |
| NAV-02 | Phase 1 | Pending |
| DISC-01 | Phase 2 | Complete |
| DISC-02 | Phase 2 | Complete |
| REQ-01 | Phase 2 | Complete |
| REQ-02 | Phase 3 | Complete |
| REQ-03 | Phase 3 | Complete |
| DISC-03 | Phase 4 | Pending |
| REQ-04 | Phase 4 | Pending |
| CHAT-01 | Phase 4 | Pending |
| CHAT-02 | Phase 4 | Pending |
| CHAT-03 | Phase 4 | Pending |

**Coverage:**
- v1 requirements: 17 total
- Mapped to phases: 17
- Unmapped: 0 ✓

---
*Requirements defined: 2026-06-07*
*Last updated: 2026-06-07 after roadmap creation*
