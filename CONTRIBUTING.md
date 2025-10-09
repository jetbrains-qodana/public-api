# Contributing guide

## Introduction

Thank you for your interest in contributing to the `public-api` repository!  
This repository contains `openapi.yaml` which defines our **public API specification**.

To maintain a consistent and stable API contract, we manage all contributions **through GitHub issues**.  
Direct pull requests to the `openapi.yaml` file are **not accepted** - please start by opening an issue instead.

## How to contribute

All contributions begin with an **issue**.  
Choose the type that best matches your intention when opening a new issue:

### Bug Report

**Use this type when:**  
You have found a bug, mistake, or inconsistency in the API specification.

**Examples:**
- Incorrect schema or data type
- Typo or wrong description in a field
- Example that doesn’t match the schema or actual API behavior

**Please include:**
- The affected endpoint(s)
- Expected vs. actual result
- Example request/response (if available)

Select **“Bug Report”** when creating your issue.

### Feature Request: New API

**Use this type when:**  
You propose adding a **new API endpoint** or expanding the existing functionality in a **backward-compatible** way.

**Examples:**
- New endpoint for an existing resource
- New optional field or query parameter
- Support for a new operation or action

**Please include:**
- The motivation behind the request
- A short description of the proposed API (endpoint, parameters, examples)
- Who would benefit and why

Select **“Feature Request: New API”** when creating your issue.

### Question

**Use this type when:**  
You want to ask about the API behavior, schema details, or contribution process.

**Examples:**
- Clarifying how an endpoint works
- Asking why a field exists or is required
- Questions about versioning or backward compatibility

Select **“Question”** when creating your issue.

### Task

**Use this type when:**  
You propose a **non-functional improvement** or **maintenance task** for this repository.

**Examples:**
- Improving documentation, examples, or descriptions
- Refactoring parts of the OpenAPI structure (without semantic changes)
- Updating metadata or CI configuration

Select **“Task”** when creating your issue.

## Issue review process

1. A maintainer will triage your issue and confirm its type.
2. Discussion may follow to clarify details or validate the proposal.
3. Once approved, the requested changes will be planned and implemented in the Qodana Cloud codebase.
4. After the changes are implemented and included in the next published release, the `openapi.yaml` file will be updated to reflect the current API state of Qodana Cloud.

## Guidelines

- One topic per issue — please don’t mix bugs, questions, and proposals.
- Keep descriptions clear and concise.
- Use **English** when possible to make discussions accessible to everyone.
- Be respectful and follow our Сode of Сonduct.

Thank you for helping us make the public API better and more reliable for everyone!