# Contributing

## Development environment

Install the required development tools:

```sh
mise bootstrap --only task --yes
```

Select a task interactively with `mise run`, or list tasks with `mise tasks ls`.

## Validate changes

Run all repository checks with [lefthook][lefthook-link]:

```sh
mise run test
```

Format supported files:

```sh
mise run fmt
```

| Target type     | Formatter / Linter / Testing framework                                                |
| :-------------- | :------------------------------------------------------------------------------------ |
| all files       | [editorconfig-checker][ec-link] / [typos][typos-link] / [ls-lint][ls-lint-link]       |
| JSON files      | [prettier][prettier-link]                                                             |
| YAML files      | [yamlfmt][yamlfmt-link] / [yamllint][yamllint-link]                                   |
| TOML files      | [taplo][taplo-link]                                                                   |
| Markdown files  | [rumdl][rumdl-link] / [lychee][lychee-link]                                           |
| shell scripts   | [shfmt][shfmt-link] / [shellharden][shellharden-link] / [shellcheck][shellcheck-link] |
| lua files       | [selene][selene-link] / [stylua][stylua-link]                                         |
| etc files       | [bats][bats-link]                                                                     |
| CI/CD           | [actionlint][actionlint-link] / [zizmor][zizmor-link]                                 |
| commit messages | [commitlint][commitlint-link]                                                         |

[lefthook-link]: https://github.com/evilmartians/lefthook
[ec-link]: https://github.com/editorconfig-checker/editorconfig-checker
[typos-link]: https://github.com/crate-ci/typos
[ls-lint-link]: https://github.com/loeffel-io/ls-lint
[prettier-link]: https://github.com/prettier/prettier
[yamlfmt-link]: https://github.com/google/yamlfmt
[yamllint-link]: https://github.com/adrienverge/yamllint
[taplo-link]: https://github.com/tamasfe/taplo
[rumdl-link]: https://github.com/rvben/rumdl
[lychee-link]: https://github.com/lycheeverse/lychee
[shfmt-link]: https://github.com/mvdan/sh
[shellharden-link]: https://github.com/anordal/shellharden
[shellcheck-link]: https://github.com/koalaman/shellcheck
[selene-link]: https://github.com/Kampfkarren/selene
[stylua-link]: https://github.com/JohnnyMorganz/StyLua
[bats-link]: https://github.com/bats-core/bats-core
[actionlint-link]: https://github.com/rhysd/actionlint
[zizmor-link]: https://github.com/zizmorcore/zizmor
[commitlint-link]: https://github.com/conventional-changelog/commitlint

## Documentation

Preview the documentation locally:

```sh
mise run docs
```

## Screenshots

Save screenshots to `docs/assets/screenshots/` with the following tasks.

Capture the login screen with `fbgrab` (requires `sudo`):

```sh
mise run screenshot:login-screen
```

Generate the bootsplash image with ImageMagick using
`/usr/share/systemd/bootctl/splash-arch-custom.bmp`:

```sh
mise run screenshot:bootsplash
```

<!-- rumdl-configure-file
{
    "MD013": { "tables": false }
}
-->
