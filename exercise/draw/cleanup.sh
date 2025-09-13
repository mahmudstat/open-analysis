#!/bin/bash

echo "Starting complete cleanup..."

# Remove installed package
echo "Removing installed package..."
sudo apt remove -y drawing-app 2>/dev/null
sudo apt autoremove -y

# Remove all files
echo "Removing application files..."
sudo rm -rf /usr/share/drawing-app/
sudo rm -rf /usr/lib/drawing-app/
sudo rm -f /usr/share/applications/drawing-app.desktop
sudo rm -f /usr/share/icons/hicolor/48x48/apps/drawing-app.png
sudo rm -f /usr/bin/drawing-app

# Clean development directory
echo "Cleaning development directory..."
rm -rf build/
rm -rf debian/drawing-app/
rm -rf drawing-app-pkg/
rm -rf dist/
rm -rf node_modules/
rm -f drawing-app_*.deb
rm -f ../drawing-app_*
rm -f package-lock.json

# Remove global npm packages
echo "Removing global npm packages..."
sudo npm uninstall -g electron electron-builder 2>/dev/null

echo "Cleanup complete!"
echo "Verifying removal:"
dpkg -l | grep drawing-app || echo "✓ Package not installed"
ls -la /usr/share/drawing-app/ 2>/dev/null || echo "✓ No application files found"
which drawing-app 2>/dev/null || echo "✓ No binary found"
