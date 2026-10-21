# DPUK Infrastructure

Reusable local development environments and Docker infrastructure for DPUK projects.

This repository contains environment templates rather than application code. Individual projects can be created by copying the appropriate environment and adapting it for the project.

## Structure

```text
infra/
├── local-dev-proxy/
├── wordpress/
├── wordpress-proxy/
├── wordpress-multisite/
├── headless-wp-next/
└── wp-laravel-next/
```

### Environments

| Environment           | Purpose                                                       |
| --------------------- | ------------------------------------------------------------- |
| `local-dev-proxy`     | Shared local HTTPS reverse proxy                              |
| `wordpress`           | Standalone WordPress development environment                  |
| `wordpress-proxy`     | WordPress environment designed to run behind the shared proxy |
| `wordpress-multisite` | WordPress multisite environment                               |
| `headless-wp-next`    | Headless WordPress + Next.js                                  |
| `wp-laravel-next`     | WordPress + Laravel API + Next.js                             |

Not all environments need to exist immediately. Add templates as requirements develop.

## Usage

Create a new project by copying the appropriate environment:

```bash
cp -R wordpress-proxy ../projects/my-project
```

Then configure the project's `.env`, domain, container names and other project-specific settings.

The copied project should have its **own Git repository**. This repository remains the source for the reusable infrastructure templates.

## Design Principles

* Keep infrastructure separate from application code.
* Prefer reusable Docker environments over project-specific Docker configuration.
* Keep individual projects independently manageable.
* Use a shared reverse proxy where multiple local projects need to run simultaneously.
* Avoid unnecessary host port conflicts.
* Keep project services isolated unless communication between projects is explicitly required.
* Keep secrets, certificates and runtime data out of Git.

## Local Development

The shared proxy provides HTTPS entry points for projects running locally.

For example:

```text
https://my-project.local
https://db.my-project.local
https://mail.my-project.local
```

Individual projects can therefore run independently while sharing the same local proxy.

## Status

This is a personal infrastructure repository and evolves alongside the projects that use it.
