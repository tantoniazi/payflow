# Roadmap Payflow

Payflow é a camada de billing brasileira para Rails — inspirada no [Pay](https://github.com/pay-rails/pay), com suporte nativo a Pix, boleto e provedores locais.

Este documento descreve as fases de evolução do projeto. A versão **0.1.0** é o MVP com escopo estrito.

---

## Escopo do MVP (0.1.0) — o que entra e o que fica de fora

### Incluído no MVP

- Provedores **Asaas** e **Stripe** (básico)
- Assinaturas (`subscriptions`)
- Faturas (`invoices`)
- Receptor de webhooks com verificação de assinatura
- Concern `Payflow::Billable` / `Payflow::Concerns::Billable`
- Constantes de eventos (`Payflow::Events`) — stub mínimo para normalização

### Explicitamente fora do MVP

- Dashboard ou qualquer UI administrativa
- Marketplace de provedores
- Mais de 2 provedores (Mercado Pago, Pagar.me, etc.)
- Dunning (recuperação de pagamentos)
- Períodos de trial
- Cupons e descontos
- Proration (rateio proporcional)
- Retry avançado de webhooks
- Geradores Rails e engine mountável completa (infraestrutura mínima pode existir, mas não é o foco)

---

## Fase 1 — MVP (0.1.0) 🟢

**Status:** em desenvolvimento

| Recurso | Descrição |
|---------|-----------|
| Provedor Asaas | Cliente HTTP, clientes, assinaturas, webhooks |
| Provedor Stripe | Integração básica (assinaturas e webhooks) |
| Assinaturas | CRUD via service objects e concern billable |
| Faturas | Modelo e sincronização básica com o provedor |
| Webhooks | `POST /payflow/webhooks/:provider`, verificação e dispatch |
| Billable | Concern para modelos host com assinatura |

**Objetivo:** permitir que apps Rails brasileiros integrem billing com Asaas ou Stripe sem acoplar o domínio ao provedor.

---

## Fase 2 — Estabilidade (0.2.x) 🟡

**Status:** planejado

| Recurso | Descrição |
|---------|-----------|
| Mercado Pago | Novo provedor |
| Pagar.me | Novo provedor |
| Retry de webhooks | Reprocessamento com backoff |
| Idempotência forte | Chaves únicas e deduplicação garantida |
| Logs estruturados | Observabilidade para produção |
| Melhorias de segurança | Hardening de tokens, assinaturas e secrets |

**Objetivo:** tornar o Payflow confiável para produção em escala.

---

## Fase 3 — Maturidade (0.3.x) 🔵

**Status:** planejado

| Recurso | Descrição |
|---------|-----------|
| Sistema de eventos (`Payflow::Events`) | Pub/sub interno, handlers plugáveis |
| Dunning | Recuperação automática de pagamentos falhos |
| Trial | Períodos de avaliação |
| Cupons | Descontos e códigos promocionais |
| Proration | Rateio em upgrades/downgrades |

**Objetivo:** paridade funcional com billing avançado (estilo Stripe Billing).

---

## Fase 4 — Ecossistema (0.4.x) 🟣

**Status:** planejado

| Recurso | Descrição |
|---------|-----------|
| Geradores Rails | `rails generate payflow:install` |
| Engine mountável | Instalação plug-and-play em apps host |
| Dashboard admin (opcional) | UI para debug e operações |
| ActionCable | Atualizações em tempo real de assinaturas/faturas |

**Objetivo:** reduzir fricção de adoção e oferecer ferramentas para times sem billing dedicado.

---

## Fase 5 — Stripe-like (1.0) 🔴

**Status:** visão de longo prazo

| Recurso | Descrição |
|---------|-----------|
| API estável | Contratos públicos congelados |
| Compatibilidade retroativa | Garantida entre minor releases |
| Documentação completa | Guias, referência de API, exemplos |
| Suite de testes robusta | Cobertura de provedores e edge cases |
| Pronto para adoção | Publicação RubyGems, comunidade ativa |

**Objetivo:** ser a referência open-source de billing para SaaS brasileiro.

---

## Posicionamento estratégico

Payflow busca ser o **equivalente brasileiro do Pay gem / Stripe Billing abstraction**, com:

- Suporte nativo a **Pix** e **boleto** via provedores locais
- Interface unificada para múltiplos gateways
- Foco em **Rails** e convenções da comunidade Ruby
- Código aberto, extensível e testável

Para contribuir, veja [CONTRIBUTING.md](CONTRIBUTING.md).
