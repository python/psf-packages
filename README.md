# psf-packages

Packages built for the PSF infrastructure.

## Getting Started

### Pre-requisites

Mac Users:
- [`dpkg`](https://formulae.brew.sh/formula/dpkg) (install via Homebrew)

Linux (Debian or derivatives):
- `build-essential` (install via `apt-get`/`apt`)

### Helper script

The build helper script has a usage message:

```bash
➜ ./tools/build_deb.sh -h
Usage: build_deb.sh [-l] [-n <package-name>] [-v <version>] [-a <architecture>] [-K]

Options:
  -l                 List available packages
  -n <package-name>  Package name (consul, consul-template, or all)
  -v <version>       Package version (optional, fetches latest if not provided)
  -a <architecture>  Package architecture (amd64, arm64, or all; default: all)
  -K                 Keep current version (do not fetch latest version)
  -N                 Keep build directory (after building)
  -h                 Display this help message
```

To build a package, run the script with the package name:

```bash
➜ ./tools/build_deb.sh -n consul-template
```

### Docker

To build everything via a container:

```
docker build -t psf-package-builder .
docker run --rm -v "$(pwd):/build" psf-package-builder
```

## Publishing

### Automated

This repository comes with a GitHub action that will automatically build and publish packages to the PSF infrastructure
on-demand, triggered by a push to the `main` branch, or on the schedule defined in `.github/workflows/build.yml`.

### Manually 

#### CLI

[//]: # (TODO)

#### UI

Once your artifacts are built, they need to be published and made available to the PSF infrastructure.

1. Visit https://packagecloud.io/psf/infra
2. Log in using your PSF credentials
3. Click on the repository you want to upload to
4. Click on the "Upload Package" button
5. Select the package you want to upload
6. Click on the "Upload" button
7. Repeat steps 4–6 for each package

[//]: # (TODO: retrieve api key/login details for manual uploads)