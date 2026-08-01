# Security Policy

## Supported versions

This is a personal research project. Only the latest commit on `main` is
supported.

## Reporting a vulnerability

Please do **not** open a public issue for a security problem.

Report it privately through
[GitHub Security Advisories](https://github.com/KyleFe/gs-dipi/security/advisories/new),
or by email to kyle.fe0212@gmail.com. Expect an acknowledgement within seven days.

## Scope

The most likely issues in a repository of this kind are:

- Credentials, connection strings or API keys committed by mistake
- Absolute local filesystem paths leaking machine layout
- Licensed or proprietary data committed by mistake

If you spot any of these, please report them — a leaked secret is treated as a
security issue even though this project has no runtime service attached.

## Out of scope

Disagreements about the econometric specification, the data sample or the
conclusions are not security issues. Please raise those as normal issues.
