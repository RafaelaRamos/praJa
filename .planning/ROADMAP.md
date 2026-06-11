# Roadmap: praJa

## Overview

Entregar o MVP offline do praJa em 4 fases verticais: fundação com autenticação e dados mockados, fluxo completo do cliente (busca e solicitação), gestão de solicitações pelo prestador, e chat local entre as partes. Cada fase entrega capacidade utilizável de ponta a ponta.

## Phases

- [x] **Phase 1: Foundation & Auth** — Scaffold Flutter, SQLite, seed de prestadores mockados, cadastro e login com navegação por perfil
- [x] **Phase 2: Client Discovery & Requests** — Cliente busca prestadores por especialidade e envia solicitações
- [x] **Phase 3: Provider Request Management** — Prestador gerencia solicitações com status Aguardando → Trabalhando → Concluído
- [ ] **Phase 4: Chat** — Chat completo com histórico local acessível pelas listas

## Phase Details

### Phase 1: Foundation & Auth
**Goal:** Usuário pode se cadastrar, fazer login e acessar a tela inicial correta com dados mockados disponíveis no SQLite
**Mode:** mvp
**Depends on:** Nothing (first phase)
**Requirements:** AUTH-01, AUTH-02, AUTH-03, AUTH-04, AUTH-05, DATA-01, DATA-02, NAV-01, NAV-02
**UI hint:** yes
**Success Criteria** (what must be TRUE):
  1. Usuário consegue se cadastrar como cliente ou prestador (com modal profissional)
  2. Usuário consegue fazer login com email e senha e permanecer logado
  3. Prestadores mockados existem no banco após o primeiro launch
  4. Cliente é direcionado para lista de prestadores; prestador para lista de solicitações
**Plans:** 2 plans

Plans:
- [x] 01-01: Scaffold Flutter clean architecture, SQLite, DI e seed de prestadores mockados
- [x] 01-02: Cadastro, login, modal de prestador e navegação por perfil

### Phase 2: Client Discovery & Requests
**Goal:** Cliente encontra prestador por especialidade e envia solicitação de serviço
**Mode:** mvp
**Depends on:** Phase 1
**Requirements:** DISC-01, DISC-02, REQ-01
**UI hint:** yes
**Success Criteria** (what must be TRUE):
  1. Cliente vê todos os prestadores cadastrados (mock + reais)
  2. Cliente filtra prestadores por especialidade na barra de busca
  3. Cliente envia solicitação com título, endereço, detalhes e data desejada para um prestador específico
**Plans:** 2 plans

Plans:
- [x] 02-01: Lista de prestadores com busca por especialidade
- [x] 02-02: Formulário e envio de solicitação de serviço

### Phase 3: Provider Request Management
**Goal:** Prestador visualiza e gerencia o ciclo de status das solicitações recebidas
**Mode:** mvp
**Depends on:** Phase 2
**Requirements:** REQ-02, REQ-03
**UI hint:** yes
**Success Criteria** (what must be TRUE):
  1. Prestador vê apenas solicitações enviadas para ele
  2. Prestador altera status: Aguardando → Trabalhando → Concluído
  3. Lista reflete o status atualizado imediatamente após mudança
**Plans:** 1 plan

Plans:
- [x] 03-01: Lista de solicitações do prestador com workflow de status

### Phase 4: Chat
**Goal:** Cliente e prestador conversam por chat com histórico local a partir das listas
**Mode:** mvp
**Depends on:** Phase 3
**Requirements:** DISC-03, REQ-04, CHAT-01, CHAT-02, CHAT-03
**UI hint:** yes
**Success Criteria** (what must be TRUE):
  1. Ícone de mensagem nas listas abre conversa com a contraparte correta
  2. Usuário envia e recebe mensagens em tempo real (local)
  3. Histórico de mensagens persiste ao fechar e reabrir o chat
**Plans:** 2 plans

Plans:
- [ ] 04-01: Modelo de chat, persistência SQLite e tela de conversa
- [ ] 04-02: Integração do ícone de mensagem nas listas de prestadores e solicitações

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation & Auth | 2/2 | Complete | 2026-06-07 |
| 2. Client Discovery & Requests | 2/2 | Complete | 2026-06-07 |
| 3. Provider Request Management | 1/1 | Complete | 2026-06-08 |
| 4. Chat | 0/2 | Not started | - |
