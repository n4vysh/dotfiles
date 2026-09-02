# dotfiles

Chezmoi-managed dotfiles for Arch Linux.

## Commands

- `chezmoi add <path>`: Add an existing file to the source state.
- `chezmoi re-add <path>`: Update a managed source file from deployment.
- `chezmoi diff`: Show pending deployment changes.
- `chezmoi apply`: Deploy managed files and run chezmoi scripts.
- `lefthook run pre-commit --all-files`: Validate all files.

## Project Structure

- `boot/`: Boot loader configuration.
- `docs/`: Installation guides and screenshots.
- `etc/`: System-wide configuration.
- `home/`: Managed user dotfiles.
- `misc/`: Manual setup files.
- `scripts/`: Bootstrap and maintenance scripts.
- `test/`: System-wide tests.

## Safety

Do not run without explicit approval:

- `chezmoi apply`
- `./scripts/bootstrap.bash`
