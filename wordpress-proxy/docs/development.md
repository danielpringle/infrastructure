
# Development Workflow

This repository provides the local development infrastructure for WordPress projects.

The Docker environment is intentionally separate from the WordPress project itself.

## Development Plugins

The `config/dev-plugins.txt` file contains WordPress plugins that are useful across local development environments.

Example:

```text
# Debugging
query-monitor

# Additional development tooling
debug-bar
```

Plugins are installed automatically by:

```bash
make setup
```

The setup script reads the file and installs each plugin using WP-CLI.

### What belongs in dev-plugins.txt

Include plugins that are generally useful when developing WordPress:

Query Monitor
Debugging tools
Developer utilities
Accessibility/debugging tools
Other plugins commonly used during development

What should not be included

### Don't add project-specific dependencies such as:

WooCommerce
WPML
SEO plugins
Membership plugins
Client-specific plugins

Those belong to the individual WordPress project.

## WordPress Project Workflow

A typical project workflow is:

Clone this environment.
Configure .env.
Generate the local SSL certificate.
Start Docker.
Run make setup.
Add project-specific WordPress code.
Create a separate Git repository for the project.

The Docker environment provides the infrastructure; the project repository owns the application code and project-specific dependencies.