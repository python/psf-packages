#!/bin/bash

set -eo pipefail

# --
function usage() {
  cat << EOF
Usage: $script [-l] [-n <package-name>] [-v <version>] [-a <architecture>] [-K]

Options:
  -l                 List available packages
  -n <package-name>  Package name (consul, consul-template, or all)
  -v <version>       Package version (optional, fetches latest if not provided)
  -a <architecture>  Package architecture (amd64, arm64, or all; default: all)
  -K                 Keep current version (do not fetch latest version)
  -N                 Keep build directory after building package
  -h                 Display this help message
EOF
  exit 1
}

# -- List available packages
function list_packages() {
  echo "Available packages: consul, consul-template, all"
}

# -- Get the latest version of the package from Hashicorp if version is not provided
function get_latest_version() {
  local package=$1
  local url="https://releases.hashicorp.com/${package}/"
  local latest_version=$(curl -sSL "$url" | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n1)

  if [[ -z $latest_version ]]; then
    echo "Error: Failed to fetch latest version for $package" >&2
    exit 1
  fi
  echo "$latest_version"
}

# -- Grab the binary from Hashicorp and extract it from the .zip
function download_and_extract_binary() {
  local package=$1
  local version=$2
  local arch=$3
  local package_dir="./builds/${package}_${version}_${arch}"
  local tmp_dir=$(mktemp -d)
  local url="https://releases.hashicorp.com/${package}/${version}/${package}_${version}_linux_${arch}.zip"
  local zip_file="${tmp_dir}/${package}_${version}_linux_${arch}.zip"

  echo "Downloading ${url}..."
  curl -sSL "$url" -o "$zip_file"

  echo "Extracting binary..."
  unzip -qo "$zip_file" -d "$tmp_dir"

  # Move the binary to the package directory, replacing if it exists
  mv -f "${tmp_dir}/${package}" "${package_dir}/usr/bin/"
  rm -rf "$tmp_dir"
}

# -- Checks
function preflight() {
  if [[ $list_packages == true ]]; then
    list_packages
    exit 0
  fi

  # You can either choose to build consul & consul-template or both at once
  if [[ -z $package_name || $package_name == "all" ]]; then
    package_name="all"
  elif [[ $package_name != "consul" && $package_name != "consul-template" ]]; then
    echo "Error: Invalid package name. Choose 'consul', 'consul-template', or 'all'" >&2
    exit 1
  fi

  # Same as above, build for ARM or x86
  if [[ -z $arch ]]; then
    arch="all"
  elif [[ $arch != "amd64" && $arch != "arm64" && $arch != "all" ]]; then
    echo "Error: Invalid architecture. Choose 'amd64', 'arm64', or 'all'" >&2
    exit 1
  fi

  # Get latest version if not provided AND if keep_version is false
  # If keep_version, then we just use the version provided and don't fetch the latest
  if [[ -z $version && $keep_version == false ]]; then
    if [[ $package_name == "all" ]]; then
      consul_version=$(get_latest_version "consul")
      consul_template_version=$(get_latest_version "consul-template")
      echo "Using latest versions: consul ${consul_version}, consul-template ${consul_template_version}"
    else
      version=$(get_latest_version "$package_name")
      echo "Using latest version for $package_name: $version"
    fi
  elif [[ -z $version && $keep_version == true ]]; then
    echo "Error: Version must be specified when using -K option" >&2
    exit 1
  fi
}

# -- Builds the package for the specified architecture
# -- We use the current package dirs as a 'template' and copy them to a new temp directory
# -- (which you can keep with -N) and then build the package from there
function build_for_arch() {
  local package_name=$1
  local version=$2
  local build_arch=$3
  local builds_dir="./builds"
  local package_dir="${builds_dir}/${package_name}_${version}_${build_arch}"

  # Create package structure
  echo "Creating package structure for $build_arch..."
  mkdir -p "${package_dir}/DEBIAN"
  mkdir -p "${package_dir}/usr/bin"

  # Copy all files from the package directory
  echo "Copying package files..."
  cp -R "${package_name}"/* "${package_dir}/"

  update_control_file "$package_name" "$version" "$build_arch"
  download_and_extract_binary "$package_name" "$version" "$build_arch"

  echo "Building package for $build_arch..."
  dpkg-deb --build "$package_dir" "${builds_dir}/${package_name}_${version}_${build_arch}.deb"
  echo "Package built: ${builds_dir}/${package_name}_${version}_${build_arch}.deb"

  # Clean up
  if [[ $keep_build_dir != true ]]; then
    rm -rf "${package_dir}"
  else
    echo "Build directory kept: ${package_dir}"
  fi
}

# -- Update the package control file with the version and architecture
function update_control_file() {
  local package_name=$1
  local version=$2
  local build_arch=$3
  local control_template="${package_name}/DEBIAN/control"
  local package_dir="./builds/${package_name}_${version}_${build_arch}"

  [[ -f $control_template ]] || { echo "Error: Control file template not found: $control_template" >&2; exit 1; }

  mkdir -p "${package_dir}/DEBIAN"

  awk -v keep="$keep_version" -v ver="$version" -v arch="$build_arch" '
    /^Version:/ { print (keep == "true" ? $0 : "Version: " ver); next }
    /^Architecture:/ { print "Architecture: " arch; next }
    { print }
  ' "$control_template" > "${package_dir}/DEBIAN/control"

  # Update version in the control_template
  sed -i'' -e "s/^Version:.*/Version: ${version}/" "$control_template"
}

# -- Build the requested package:arch
function build_package() {
  local package_name=$1
  local version=$2
  local build_arch=$3

  if [[ $build_arch == "all" ]]; then
    build_for_arch "$package_name" "$version" "amd64"
    build_for_arch "$package_name" "$version" "arm64"
  else
    build_for_arch "$package_name" "$version" "$build_arch"
  fi
}

# -- Main function
function main() {
  local opt
  arch="all"
  script=$(basename "$0")
  keep_version=false
  list_packages=false

  while getopts "ln:v:a:KNh" opt; do
    case ${opt} in
      l) list_packages=true ;;
      n) package_name=$OPTARG ;;
      v) version=$OPTARG ;;
      a) arch=$OPTARG ;;
      K) keep_version=true ;;
      N) keep_build_dir=true ;;
      h) usage ;;
      *) usage ;;
    esac
  done

  preflight

  if [[ $package_name == "all" ]]; then
    build_package "consul" "$consul_version" "$arch"
    build_package "consul-template" "$consul_template_version" "$arch"
  else
    build_package "$package_name" "$version" "$arch"
  fi
}

main "$@"