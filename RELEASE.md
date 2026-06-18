# Publishing to RubyGems.org

Checklist for releasing the `payflow` gem. Do **not** publish until CI is green and you have reviewed the built package contents.

## Prerequisites

- RubyGems account with [MFA enabled](https://guides.rubygems.org/setting-up-multifactor-authentication/) (required by this gem's metadata)
- `gem signin` completed locally (stores credentials in `~/.gem/credentials`)

## Release steps

1. **Sign in** (once per machine):
   ```bash
   gem signin
   ```

2. **Bump version** in `lib/payflow/version.rb` and update `CHANGELOG.md`.

3. **Run checks**:
   ```bash
   bundle exec rspec
   bundle exec rubocop
   ```

4. **Build the gem**:
   ```bash
   rake build
   # or: gem build payflow.gemspec
   ```
   Output: `pkg/payflow-<version>.gem`

5. **Smoke test locally** (optional):
   ```bash
   gem install ./pkg/payflow-*.gem --local
   ```

6. **Push to RubyGems**:
   ```bash
   gem push pkg/payflow-<version>.gem
   # or: rake release  # builds, tags, pushes gem, pushes git (requires clean git state)
   ```

7. **Verify** at https://rubygems.org/gems/payflow

## Notes

- `rake release` runs `git push` and creates a version tag; ensure commits are pushed to GitHub first.
- Never commit `pkg/` or `*.gem` files (listed in `.gitignore`).
