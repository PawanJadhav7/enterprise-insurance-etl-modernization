# CI/CD Strategy

## Overview

This document defines the CI/CD strategy for the Enterprise Insurance ETL Modernization Platform.

The project uses GitHub Actions for portfolio implementation and documents Azure DevOps as an enterprise alternative for Manulife / John Hancock–style production environments.

## CI/CD Objectives

The CI/CD process should ensure:

- Code is version controlled.
- SQL and Python files are validated before merge.
- Documentation is checked for completeness.
- Required project folders and files exist.
- Databricks notebooks can be deployed consistently.
- Environment-specific values are parameterized.
- Production deployments can follow approval-based release gates.

## Source Control Strategy

The project uses GitHub as the source control platform.

Recommended branch strategy:

| Branch | Purpose |
|---|---|
| main | Stable portfolio-ready branch |
| develop | Integration branch for active development |
| feature/* | Feature-specific changes |
| hotfix/* | Urgent production fixes |

## Pull Request Workflow

Recommended workflow:

```text
Developer creates feature branch
   -> Makes code or documentation changes
   -> Opens pull request
   -> GitHub Actions validation runs
   -> Review and approval
   -> Merge into main
```
