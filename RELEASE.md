# Publishing to RubyGems.org

Checklist for releasing the `payflow` gem. Do **not** publish until CI is green and you have reviewed the built package contents.

## Prerequisites

- RubyGems account with [MFA enabled](https://guides.rubygems.org/setting-up-multifactor-authentication/) (required by this gem's metadata)
- For automated releases: a GitHub Actions secret named `RUBYGEMS_API_KEY` (see below)
- For manual releases: `gem signin` completed locally (stores credentials in `~/.gem/credentials`)

## Automated release (GitHub Actions)

Pushing a version tag triggers the [Release workflow](.github/workflows/release.yml), which runs tests, builds the gem, and publishes to RubyGems.

### One-time setup

1. Create an API key at [rubygems.org/profile/api_keys](https://rubygems.org/profile/api_keys).
   - Enable the **push** scope.
   - Your RubyGems account must have MFA enabled (required by this gem).
2. In the GitHub repository, add a secret:
   - **Name:** `RUBYGEMS_API_KEY`
   - **Value:** the API key from RubyGems

### Release flow

1. Bump version in `lib/payflow/version.rb` and update `CHANGELOG.md`.
2. Commit and push to `main`.
3. Create and push a tag matching the version (with a `v` prefix):

   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```

GitHub Actions will run RuboCop and RSpec, verify the tag matches `Payflow::VERSION`, build the gem, and push it to RubyGems.

Monitor the run under **Actions → Release** in the repository.

## Manual release (fallback)

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
- Tag names must match `Payflow::VERSION` with a `v` prefix (e.g. version `0.1.0` → tag `v0.1.0`).
