# pylinter

Copyright (c) 2021, [programmingwithalex](https://github.com/programmingwithalex)

Enforce python linting on commits and pull requests.

## Linting Packages Used

* [`flake8`](https://pypi.org/project/flake8/)

* [`mypy`](https://pypi.org/project/mypy/)

* [`isort`](https://pypi.org/project/isort/)

## Optional Inputs

* `python-root`
  * directory to run linters on

  * by default `mypy` does not run recursively, but will here

* `flake8-flags`
  * flags to run with `flake8` command

* `mypy-flags`
  * flags to run with `mypy` command

* `fail-on-isort`
  * whether to fail job if `isort` changes needed

  * if set to `false`, isort will run and modify necessary files (auto-commit, shown below, can then be run to push changes)

* `skip-flake8`
  * whether to skip `flake8` checks

  * if set to `true`, job will not fail on `flake8` errors

* `skip-mypy`
  * whether to skip `mypy` checks

  * if set to `true`, job will not fail on `mypy` errors

* `skip-isort`
  * whether to skip `isort` checks

  * if set to `true`, job will not fail on `isort` errors

* `mypy-ignore-dirs-files`
  * list of directories and/or files to ignore for mypy. separate with spaces

  * default value is an emtpy string, meaning no directories and/or files are ignored

* `requirements-file`
  * requirements filepath needed to prevent `mypy` errors `Library stubs are missing for package ...`

  * **ONLY** need to include the missing library stubs (example: `types-pyyaml`)

  * it is recommended to create a seprate `requirements_stubs.txt` to use as input to prevent unnecessarily long execution time

  * default value is an emtpy string, meaning nothing is installed

## Outputs

Print associated errors with failed job. The order of linters are `flake8`, `mypy`, `isort`. If any linter fails, the job will fail and no subsequent linters will run.

## Quick Start

### Default (no flags)

```yaml
on: [push, pull_request]

jobs:
  python-lint:
    runs-on: ubuntu-latest
    name: CI workflow
    steps:
    - name: checkout source repo
      uses: actions/checkout@main

    - name: linting
      uses: programmingwithalex/pylinter@main
```

### Optional flags

```yaml
on: [push, pull_request]

jobs:
  python-lint:
    runs-on: ubuntu-latest
    name: CI workflow
    steps:
    - name: checkout source repo
      uses: actions/checkout@main

    - name: linting
      uses: programmingwithalex/pylinter@main
      with:
        python-root: '.'
        flake8-flags: '--count --show-source --statistics'
        mypy-flags: '--ignore-missing-imports'
        fail-on-isort: true
        mypy-ignore-dirs-files: 'folder1 folder2/main.py'
```

### Auto-commit/push `isort` changes

```yaml
on: [push, pull_request]

jobs:
  python-lint:
    runs-on: ubuntu-latest
    name: CI workflow
    steps:
    - name: checkout source repo
      uses: actions/checkout@main

    - name: linting
      uses: programmingwithalex/pylinter@main
      with:
        python-root: '.'
        flake8-flags: '--count --show-source --statistics'
        mypy-flags: '--ignore-missing-imports'
        fail-on-isort: false

    - name: commit isort changes
      run: |
        git config --local user.email "action@github.com"
        git config --local user.name "GitHub Action"
        git add -A && git diff-index --cached --quiet HEAD || git commit -m 'isort'

    - name: push isort changes
      uses: ad-m/github-push-action@master
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        branch: ${{ github.ref }}
```

## License

[BSD 3-Clause License](https://github.com/programmingwithalex/pylinter/blob/main/LICENSE)
