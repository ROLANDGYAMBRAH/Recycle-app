#!/bin/bash

# Flutter Button Style Updater
# This script updates ElevatedButton styles across all Dart files in your Flutter project

# Colors from your design
PRIMARY_GREEN="#45B200"
TEXT_COLOR="Colors.white"
BORDER_RADIUS="30"
BUTTON_HEIGHT="52"

# Function to update button styles
update_button_styles() {
    local file="$1"
    
    echo "Processing: $file"
    
    # Create backup
    cp "$file" "${file}.backup"
    
    # Use sed to replace ElevatedButton.styleFrom patterns
    # This handles various formatting styles
    sed -i.tmp '
    # Pattern 1: Single line styleFrom
    s/ElevatedButton\.styleFrom([^)]*)/ElevatedButton.styleFrom(\
                    backgroundColor: const Color(0xFF45B200),\
                    shape: RoundedRectangleBorder(\
                      borderRadius: BorderRadius.circular(30),\
                    ),\
                  )/g
    
    # Pattern 2: Multi-line styleFrom - start
    /ElevatedButton\.styleFrom(/,/)/ {
        # If this is the opening line
        /ElevatedButton\.styleFrom(/ {
            # Replace with our standard style
            c\
                  style: ElevatedButton.styleFrom(\
                    backgroundColor: const Color(0xFF45B200),\
                    shape: RoundedRectangleBorder(\
                      borderRadius: BorderRadius.circular(30),\
                    ),\
                  ),
            # Skip to end of this replacement
            b
        }
        # Delete all lines until the closing parenthesis
        /)/! d
    }
    ' "$file"
    
    # Clean up temporary file
    rm -f "${file}.tmp"
    
    echo "✓ Updated: $file"
}

# Function to wrap buttons in SizedBox if needed
wrap_buttons_with_sized_box() {
    local file="$1"
    
    # Add SizedBox wrapper for consistent button sizing
    sed -i.tmp '
    # Look for ElevatedButton that is not already wrapped in SizedBox
    /SizedBox(/!{
        /ElevatedButton(/ {
            i\
                SizedBox(\
                  width: double.infinity,\
                  height: 52,\
                  child: 
            a\
                ),
        }
    }
    ' "$file"
    
    rm -f "${file}.tmp"
}

# Function to ensure proper imports
add_material_import() {
    local file="$1"
    
    # Check if material.dart import exists
    if ! grep -q "import 'package:flutter/material.dart';" "$file"; then
        # Add import at the top
        sed -i.tmp "1i\\
import 'package:flutter/material.dart';" "$file"
        rm -f "${file}.tmp"
        echo "✓ Added material.dart import to: $file"
    fi
}

# Main execution
main() {
    echo "🔄 Starting Flutter Button Style Update..."
    echo "================================================"
    
    # Check if we're in a Flutter project
    if [ ! -f "pubspec.yaml" ]; then
        echo "❌ Error: pubspec.yaml not found. Please run this script from your Flutter project root."
        exit 1
    fi
    
    # Find all Dart files in lib directory
    dart_files=$(find lib -name "*.dart" -type f)
    
    if [ -z "$dart_files" ]; then
        echo "❌ No Dart files found in lib directory."
        exit 1
    fi
    
    echo "Found $(echo "$dart_files" | wc -l) Dart files to process..."
    echo ""
    
    # Process each file
    for file in $dart_files; do
        # Skip if file doesn't contain ElevatedButton
        if grep -q "ElevatedButton" "$file"; then
            add_material_import "$file"
            update_button_styles "$file"
            wrap_buttons_with_sized_box "$file"
        else
            echo "⏭️  Skipped: $file (no ElevatedButton found)"
        fi
    done
    
    echo ""
    echo "================================================"
    echo "✅ Button style update complete!"
    echo ""
    echo "📝 Notes:"
    echo "   • Backup files created with .backup extension"
    echo "   • Standard button style applied:"
    echo "     - Background: #45B200 (green)"
    echo "     - Border radius: 30px"
    echo "     - Height: 52px"
    echo "     - Full width"
    echo ""
    echo "🔧 To customize further, edit the variables at the top of this script."
    echo ""
    echo "⚠️  Remember to test your app after running this script!"
}

# Help function
show_help() {
    echo "Flutter Button Style Updater"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -d, --dry-run  Show what would be changed without making changes"
    echo ""
    echo "This script updates all ElevatedButton styles in your Flutter project"
    echo "to match your onboarding screen design."
}

# Dry run function
dry_run() {
    echo "🔍 DRY RUN MODE - No changes will be made"
    echo "================================================"
    
    dart_files=$(find lib -name "*.dart" -type f)
    
    for file in $dart_files; do
        if grep -q "ElevatedButton" "$file"; then
            echo "Would update: $file"
            echo "  Button occurrences: $(grep -c "ElevatedButton" "$file")"
        fi
    done
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
        ;;
    -d|--dry-run)
        dry_run
        exit 0
        ;;
    "")
        main
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
esac
