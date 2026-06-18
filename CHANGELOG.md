# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-06-17

### Added

- Rails engine with Asaas and Stripe provider support
- `Payflow::Billable` concern for host models
- Subscription lifecycle (subscribe, cancel, status checks)
- Webhook handling for Asaas with signature verification
- Database migrations for subscriptions, invoices, and webhook events
- Sidekiq jobs for webhook processing and overdue checks

[0.1.0]: https://github.com/tantoniazi/payflow/releases/tag/v0.1.0
