---
phase: 1
slug: foundation-auth
status: approved
shadcn_initialized: false
preset: none
platform: flutter
created: 2026-06-07
approved: 2026-06-07
---

# Phase 1 — UI Design Contract

> Contrato visual e de interação para Foundation & Auth. Flutter Material 3, idioma pt-BR.

---

## Design System

| Property | Value |
|----------|-------|
| Tool | Flutter Material 3 |
| Preset | not applicable (mobile native) |
| Component library | Material 3 (`ThemeData`, `ColorScheme`, `TextTheme`) |
| Icon library | Material Icons (`Icons.*`) |
| Font | Inter via `google_fonts` (fallback: Roboto system) |
| State management UI | flutter_bloc (loading/error/success states on forms) |

**Theme mode:** Light only no MVP (dark mode → v2).

**Implementation path:** Centralizar tokens em `lib/core/theme/app_theme.dart` + `app_colors.dart` + `app_spacing.dart` + `app_typography.dart`.

---

## Spacing Scale

Valores declarados (múltiplos de 4):

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Gap entre ícone e label inline |
| sm | 8px | Espaço entre campos relacionados |
| md | 16px | Padding horizontal de tela, gap padrão |
| lg | 24px | Padding vertical de seções, margin entre blocos |
| xl | 32px | Espaço entre seções principais |
| 2xl | 48px | Topo de formulários, área abaixo do header |
| 3xl | 64px | Respiro em telas vazias (empty states) |

**Exceptions:**
- Touch target mínimo: **48×48px** (botões, ícones clicáveis, switches)
- Modal bottom sheet handle area: 8px top padding

---

## Typography

| Role | Size | Weight | Line Height | Usage |
|------|------|--------|-------------|-------|
| Label | 14px | 600 (semibold) | 1.4 | Labels de campo, chips, badges |
| Body | 16px | 400 (regular) | 1.5 | Texto corrido, inputs, list subtitles |
| Heading | 20px | 600 (semibold) | 1.2 | Títulos de tela, títulos de card |
| Display | 28px | 600 (semibold) | 1.2 | Título "praJa" na tela de login |

**Regra:** Máximo 4 tamanhos, 2 pesos — sem exceções nesta fase.

---

## Color

| Role | Value | Usage |
|------|-------|-------|
| Dominant (60%) | `#F1F5F9` | `scaffoldBackgroundColor`, fundo de telas |
| Secondary (30%) | `#FFFFFF` | Cards, inputs, modal sheet, AppBar surface |
| Accent (10%) | `#0F766E` | Ver seção "Accent reservado para" |
| Destructive | `#DC2626` | Erros de validação, snackbar de falha crítica |
| Text primary | `#0F172A` | Títulos e corpo principal |
| Text secondary | `#64748B` | Hints, subtítulos, placeholders |
| Border | `#E2E8F0` | Outlines de inputs, divisores de lista |

**Accent reservado para:**
- Botão primário preenchido (CTA principal de cada tela)
- Link "Criar conta" / "Já tenho conta" na tela oposta
- Switch/toggle de "Sou prestador de serviço" quando ativo
- Indicador de foco em campo ativo (focus border)
- FAB (se usado) — **não usar** accent em botões secundários/outlined

**Não usar accent em:** ícones decorativos, texto de parágrafo, backgrounds de card, todos os botões indiscriminadamente.

---

## Copywriting Contract

| Element | Copy |
|---------|------|
| App name display | **praJa** |
| Login — heading | Entrar no praJa |
| Login — primary CTA | **Entrar na conta** |
| Login — secondary link | Não tem conta? **Criar conta** |
| Register — heading | Criar sua conta |
| Register — primary CTA | **Criar conta** |
| Register — secondary link | Já tem conta? **Entrar na conta** |
| Register — provider toggle label | Sou prestador de serviço |
| Provider modal — title | Dados profissionais |
| Provider modal — primary CTA | **Salvar perfil profissional** |
| Provider modal — secondary | **Continuar depois** (fecha modal; cadastro salva tipo prestador, perfil incompleto bloqueia login de prestador com banner) |
| Client home — title | Prestadores disponíveis |
| Provider home — title | Minhas solicitações |
| Client empty state heading | Nenhum prestador disponível |
| Client empty state body | Ainda não há profissionais cadastrados. Volte em breve ou cadastre-se como prestador. |
| Provider empty state heading | Nenhuma solicitação ainda |
| Provider empty state body | Quando um cliente enviar um pedido para você, ele aparecerá aqui. |
| Login error | Email ou senha incorretos. Verifique os dados e tente novamente. |
| Register — email inválido | Informe um email válido (exemplo@email.com). |
| Register — CPF inválido | CPF inválido. Verifique os 11 dígitos. |
| Register — senha curta | A senha deve ter no mínimo 6 caracteres. |
| Register — campos obrigatórios | Preencha todos os campos obrigatórios para continuar. |
| Loading — login | Entrando… |
| Loading — register | Criando conta… |

**Destructive actions:** Nenhuma ação destrutiva nesta fase (sem logout ainda). Sem diálogo de confirmação necessário.

---

## Screen Inventory (Phase 1)

### 1. Login Screen
**Focal point:** Campo de email + botão "Entrar na conta"

| Element | Spec |
|---------|------|
| Layout | Coluna centralizada, scrollável, padding horizontal `md` (16px) |
| Logo/título | Display "praJa" no topo, margin bottom `2xl` |
| Fields | Email, Senha (obscure) — `TextFormField` outlined |
| CTA | `FilledButton` full-width, accent, height 48px |
| Link | TextButton abaixo do CTA → navega para Register |
| Error | Texto vermelho abaixo do form OU SnackBar destructive |

### 2. Register Screen
**Focal point:** Formulário de cadastro + toggle prestador

| Element | Spec |
|---------|------|
| Layout | Scroll vertical, padding `md`, AppBar com back |
| Fields | Nome, Email, Senha, CPF (máscara), Data nascimento (date picker), Telefone (máscara BR) |
| Toggle | `SwitchListTile` "Sou prestador de serviço" — abre modal ao ativar |
| CTA | `FilledButton` "Criar conta" fixo no bottom ou após form |
| Validation | Inline por campo, cor destructive, ícone `Icons.error_outline` 16px |

### 3. Provider Profile Modal (Bottom Sheet)
**Focal point:** Campos profissionais + CTA salvar

| Element | Spec |
|---------|------|
| Type | `showModalBottomSheet`, `isScrollControlled: true`, max height 90% |
| Handle | Drag handle 4×32px, cor `#CBD5E1`, radius 2px |
| Fields | Profissão, Especialidade, Endereço, Descrição (multiline, min 3 lines) |
| CTA row | Primary "Salvar perfil profissional" + TextButton "Continuar depois" |
| Dismiss | Tap outside não salva dados parciais sem confirmação |

### 4. Client Home (Placeholder — Phase 1 shell)
**Focal point:** Lista de prestadores (dados mock)

| Element | Spec |
|---------|------|
| AppBar | Título "Prestadores disponíveis", sem ações nesta fase |
| Body | `ListView` de cards — avatar inicial, nome, especialidade (placeholder Phase 2) |
| Empty | Ilustração/icon `Icons.person_search` 48px + copy empty state |
| Item height | Mínimo 72px, padding `md` |

### 5. Provider Home (Placeholder — Phase 1 shell)
**Focal point:** Lista vazia de solicitações

| Element | Spec |
|---------|------|
| AppBar | Título "Minhas solicitações" |
| Body | Empty state centralizado (solicitações chegam Phase 2+) |
| Empty | Icon `Icons.assignment_outlined` 48px + copy empty state |

---

## Interaction Patterns

| Pattern | Spec |
|---------|------|
| Form submit | Desabilitar CTA + mostrar loading indicator no botão durante async |
| Keyboard | `TextInputAction.next` entre campos; `done` no último |
| Date picker | `showDatePicker` locale `pt_BR`, tema accent |
| CPF/Telefone | Máscaras visuais; validação no submit |
| Navigation pós-login | Cliente → Client Home; Prestador → Provider Home |
| Session | Sem tela de splash animada no MVP — rota inicial decide login vs home |

---

## Visual Hierarchy

1. **Login/Register:** Título Display → campos → CTA accent (maior contraste visual)
2. **Modal prestador:** Título Heading → campos → CTA (sticky bottom dentro do sheet)
3. **Home lists:** AppBar Heading → conteúdo lista ou empty state centralizado

---

## Accessibility

- Contraste mínimo WCAG AA para texto sobre surfaces
- `Semantics` label em todos os CTAs e campos
- Touch targets ≥ 48px
- Mensagens de erro associadas ao campo via `Semantics` / `errorText`

---

## Registry Safety

| Registry | Blocks Used | Safety Gate |
|----------|-------------|-------------|
| N/A — Flutter Material 3 | Built-in widgets only | not required |

Sem registries third-party de UI nesta fase. Pacotes: `google_fonts`, `flutter_bloc`, `mask_text_input_formatter` (ou equivalente) — bibliotecas pub.dev padrão, não registries shadcn.

---

## Checker Sign-Off

- [x] Dimension 1 Copywriting: PASS
- [x] Dimension 2 Visuals: PASS
- [x] Dimension 3 Color: PASS
- [x] Dimension 4 Typography: PASS
- [x] Dimension 5 Spacing: PASS
- [x] Dimension 6 Registry Safety: PASS

**Approval:** approved 2026-06-07

**Defaults note:** Decisões visuais inferidas de PROJECT.md (pt-BR, marketplace de serviços, Flutter clean architecture). Sem CONTEXT.md — revisar paleta antes de Phase 2 se desejar rebranding.
