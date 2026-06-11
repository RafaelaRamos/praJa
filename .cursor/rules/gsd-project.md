<!-- gsd-project-start source:PROJECT.md -->

## Project

**praJa**

Aplicativo mobile Flutter para contratação de serviços entre clientes e prestadores. O MVP é 100% offline, com persistência local em SQLite e prestadores mockados pré-carregados. Dois perfis de usuário: **cliente** (busca prestadores, envia solicitações e conversa por chat) e **prestador** (recebe solicitações, atualiza status e conversa por chat).

**Core Value:** O cliente encontra um prestador por especialidade, envia uma solicitação de serviço com os detalhes necessários e consegue se comunicar por chat — tudo funcionando localmente, sem depender de backend.

### Constraints

- **Tech stack**: Flutter + clean architecture + SQLite local
- **Persistência**: 100% offline — sem Firebase, sem API neste MVP
- **Arquitetura**: Separação domain/data/presentation com padrões do projeto (repository pattern)
- **Dados iniciais**: Seed com prestadores mockados para demonstrar o fluxo sem cadastros manuais
- **Idioma**: Interface em português (Brasil)

<!-- gsd-project-end -->

<!-- gsd-stack-start source:STACK.md -->

## Technology Stack

Technology stack not yet documented. Will populate after codebase mapping or first phase.
<!-- gsd-stack-end -->

<!-- gsd-conventions-start source:CONVENTIONS.md -->

## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- gsd-conventions-end -->

<!-- gsd-architecture-start source:ARCHITECTURE.md -->

## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- gsd-architecture-end -->

<!-- gsd-skills-start source:skills/ -->

## Project Skills

| Skill | Description | Path |
|-------|-------------|------|
| clean-architecture | Guidelines for implementing Clean Architecture patterns in Flutter and Go applications, with emphasis on separation of concerns, dependency rules, and testability. | `.cursor/skills/clean-architecture/SKILL.md` |
| flutter | Expert in Flutter and Dart development with clean architecture and state management | `.cursor/skills/flutter/SKILL.md` |
<!-- gsd-skills-end -->

<!-- gsd-workflow-start source:GSD defaults -->

## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:

- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- gsd-workflow-end -->

<!-- gsd-profile-start -->

## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- gsd-profile-end -->
