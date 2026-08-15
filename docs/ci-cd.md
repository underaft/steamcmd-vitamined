# CI/CD and releases

## Branch model

```text
feature branch -> next -> main -> X.Y.Z tag
                   |                 |
                   +--> latest       +--> semver image
```

- Feature pull requests target `next`.
- `next` publishes `latest` for integration testing.
- Stable releases are plain semver tags created from `main`.
- Hotfixes target `main`, then are merged back into `next`.

## Local-first release

```bash
./release.sh check
./release.sh release 1.2.3
git push github next
git push github main 1.2.3
```

The release helper never pushes. The final two commands are separate so the operator can review the tag and remote before publishing.

## GitHub workflows

- `ci.yml`: pull-request and branch validation.
- `publish.yml`: publishes `latest` from `next` and semver tags from `main`.
- `release.yml`: manual, validated tag creation for maintainers or GitHub agents.

Images use `ghcr.io/underaft/steamcmd-vitamined`. Workflows use the repository `GITHUB_TOKEN` with package-write permission and Docker BuildKit's GitHub Actions cache.

## Repository settings checklist

- Keep the repository and GHCR package private during rollout.
- Set `main` as the default branch and protect `main` and `next`.
- Require the CI check on pull requests.
- Enable pull requests and Actions; keep the wiki disabled because repository docs are canonical.
- Before public launch, make the package public, confirm anonymous pulls, and review package-to-repository association.
