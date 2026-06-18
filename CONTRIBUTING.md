# Guia de Contribuição

Obrigado por considerar contribuir com o Payflow! Este projeto é open-source e depende da comunidade para evoluir.

## Código de conduta

Este projeto adota o [Contributor Covenant](CODE_OF_CONDUCT.md). Ao participar, você concorda em seguir essas diretrizes.

## Escopo do MVP

Antes de abrir um PR, confirme que sua mudança respeita o escopo da versão **0.1.0**. Consulte [ROADMAP.md](ROADMAP.md) para detalhes.

**Não adicione ao MVP:** dashboard, UI, marketplace, mais de 2 provedores, dunning, trials, cupons ou proration.

## Regras de arquitetura

### 1. Não quebre a interface de Provider

Todo provedor deve implementar o contrato definido em `Payflow::Providers::Base` (ou `Payflow::Providers::*::Client`).

- Novos métodos públicos exigem discussão em issue antes da implementação
- Use `Payflow::Provider.register` para registrar provedores em plugins/extensions
- Apenas **Asaas** e **Stripe** fazem parte do MVP

### 2. Testes obrigatórios

- Toda mudança de comportamento deve incluir specs RSpec
- Cubra casos de sucesso e falha (erros de provedor, webhooks inválidos, etc.)
- Execute a suíte localmente antes de abrir o PR

### 3. Padrão Service Objects

Lógica de negócio fica em `Payflow::Services::*`, não em controllers ou models host.

```ruby
# Correto
Payflow::Services::SubscriptionService.new.create(billable: account, plan_id: "basic")

# Evitar lógica de billing em controllers da app host
```

### 4. Idempotência em webhooks

Webhooks **devem** ser idempotentes:

- Use `idempotency_key` única por evento
- Trate `ActiveRecord::RecordNotUnique` como evento já processado
- Nunca dispare efeitos colaterais duplicados (cobrança, cancelamento, etc.)

## Ambiente de desenvolvimento

### Pré-requisitos

- Ruby >= 3.1
- Bundler

### Instalação

```bash
cd payflow
bundle install
```

### Executar testes

```bash
bundle exec rspec
```

A app dummy de testes fica em `spec/dummy/`.

### RuboCop

```bash
bundle exec rubocop
```

Configuração em `.rubocop.yml`. O CI falha se houver ofensas.

### Appraisal (matriz de versões Rails)

```bash
bundle exec appraisal install
bundle exec appraisal rails-7 rspec
```

## Branches

Use o padrão:

```
tipo/descricao-curta
```

Exemplos:

- `feat/asaas-pix-webhook`
- `fix/stripe-signature-verification`
- `docs/roadmap-phase-2`

Tipos comuns: `feat`, `fix`, `docs`, `test`, `chore`, `refactor`.

## Processo de Pull Request

1. Abra uma **issue** para features não triviais (discuta escopo e fase do roadmap)
2. Faça fork e crie uma branch a partir de `main`
3. Escreva commits claros em português ou inglês
4. Adicione ou atualize testes
5. Rode `bundle exec rspec` e `bundle exec rubocop`
6. Abra o PR com:
   - Resumo do que mudou e por quê
   - Issue relacionada (`Closes #123`)
   - Plano de teste manual, se aplicável
7. Aguarde review — pelo menos um maintainer deve aprovar

## Labels do GitHub

O repositório usa labels para triagem. O arquivo [`.github/labels.yml`](.github/labels.yml) pode ser sincronizado com a action `micnncim/action-gh-label-sync` ou equivalente.

| Label | Uso |
|-------|-----|
| `good first issue` | Boas primeiras contribuições para novatos |
| `provider:asaas` | Issues/PRs relacionados ao Asaas |
| `provider:stripe` | Issues/PRs relacionados ao Stripe |
| `webhook` | Receptor, verificação, dispatch e idempotência |
| `core` | Engine, models, services e API pública |
| `documentation` | README, roadmap, guias e comentários de API |

## Reportar bugs

Use o template [Bug Report](.github/ISSUE_TEMPLATE/bug_report.md).

Inclua: versão do Payflow, provedor, passos para reproduzir, comportamento esperado vs. atual e logs (sem secrets).

## Sugerir features

Use o template [Feature Request](.github/ISSUE_TEMPLATE/feature_request.md).

Indique em qual **fase do roadmap** a feature se encaixa. Features fora do MVP serão marcadas para fases futuras.

## Novos provedores

Use o template [Provider Support Request](.github/ISSUE_TEMPLATE/provider_support_request.md).

Novos provedores estão planejados para a **Fase 2** (Mercado Pago, Pagar.me). No MVP, apenas Asaas e Stripe são aceitos.

## Dúvidas

Abra uma issue com a label `documentation` ou entre em contato via [dev@conexus-systems.com.br](mailto:dev@conexus-systems.com.br).
