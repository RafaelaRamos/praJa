# praJa

## What This Is

Aplicativo mobile Flutter para contratação de serviços entre clientes e prestadores. O MVP é 100% offline, com persistência local em SQLite e prestadores mockados pré-carregados. Dois perfis de usuário: **cliente** (busca prestadores, envia solicitações e conversa por chat) e **prestador** (recebe solicitações, atualiza status e conversa por chat).

## Core Value

O cliente encontra um prestador por especialidade, envia uma solicitação de serviço com os detalhes necessários e consegue se comunicar por chat — tudo funcionando localmente, sem depender de backend.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Cadastro com email, nome, CPF, data de nascimento, telefone e tipo de usuário (cliente ou prestador)
- [ ] Cadastro profissional do prestador (profissão, especialidade, endereço, descrição) via modal
- [ ] Login com email e senha
- [ ] Lista de prestadores para cliente com busca por especialidade
- [ ] Solicitação de serviço: título, endereço, detalhes e data desejada, enviada a um prestador específico
- [ ] Lista de solicitações recebidas para prestador
- [ ] Status da solicitação: Aguardando → Trabalhando → Concluído
- [ ] Chat completo (enviar/receber mensagens com histórico local)
- [ ] Ícone de mensagem em cada item das listas para iniciar chat
- [ ] Dados mockados de prestadores seedados no app

### Out of Scope

- Backend/API ou sincronização em nuvem — MVP é local por design
- Pagamentos in-app — fora do escopo inicial
- Notificações push — requer infraestrutura externa
- Verificação de email ou recuperação de senha por email — sem servidor no MVP
- Geolocalização ou filtro por proximidade — busca apenas por especialidade
- Avaliações/reviews de prestadores — deferido para versão futura

## Context

- Repositório greenfield com skills de Flutter e clean architecture já configuradas
- Público-alvo: mercado brasileiro (CPF, campos em português)
- Prestadores aparecem na lista do cliente se estiverem cadastrados no app (mock + cadastros reais)
- Fluxo de solicitação: cliente escolhe prestador → preenche formulário → prestador vê na sua lista
- Ciclo de status do prestador: Aguardando → Trabalhando → Concluído

## Constraints

- **Tech stack**: Flutter + clean architecture + SQLite local
- **Persistência**: 100% offline — sem Firebase, sem API neste MVP
- **Arquitetura**: Separação domain/data/presentation com padrões do projeto (repository pattern)
- **Dados iniciais**: Seed com prestadores mockados para demonstrar o fluxo sem cadastros manuais
- **Idioma**: Interface em português (Brasil)

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| SQLite local, sem backend | MVP rápido, validar UX e fluxos antes de infra | — Pending |
| Cliente envia solicitação direta ao prestador escolhido | Fluxo simples e claro para MVP | — Pending |
| Chat completo com histórico local | Comunicação essencial entre cliente e prestador | — Pending |
| Busca por especialidade | Critério principal de descoberta de prestadores | — Pending |
| Status: Aguardando / Trabalhando / Concluído | Ciclo mínimo de gestão de solicitações | — Pending |
| Prestadores mockados no seed | Permite testar fluxo cliente sem múltiplos cadastros | — Pending |
| Login email + senha | Autenticação clássica, armazenada localmente | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-06-07 after initialization*
