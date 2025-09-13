#!/bin/bash

# Check if required commands are available
check_dependency() {
    if ! command -v $1 &> /dev/null; then
        echo "Error: $1 is not installed. Please install it with:"
        echo "sudo apt install $2"
        exit 1
    fi
}

check_dependency "node" "nodejs"
check_dependency "npm" "npm"
check_dependency "dpkg-buildpackage" "devscripts"

# Initialize package if needed
if [ ! -f "debian/changelog" ]; then
    echo "Creating initial Debian packaging files..."
    dh_make --createorig --yes --native -p drawing-app_1.0.0
    # Remove unnecessary template files
    rm -f debian/*.ex debian/*.EX debian/README.*
fi

# Clean previous builds
echo "Cleaning previous builds..."
npm run clean 2>/dev/null || true
rm -rf debian/drawing-app/
rm -f ../drawing-app_*.deb ../drawing-app_*.buildinfo ../drawing-app_*.changes

# Build the application
echo "Building application..."
npm run build

# Build the DEB package
echo "Building DEB package..."
dpkg-buildpackage -us -uc

# Move the built package
if ls ../drawing-app_*.deb 1> /dev/null 2>&1; then
    mv ../drawing-app_*.deb ./
    echo "Package built successfully: $(ls drawing-app_*.deb)"
else
    echo "Error: No DEB package was created"
    exit 1
fi
