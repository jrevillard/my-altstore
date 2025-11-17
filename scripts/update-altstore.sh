#!/bin/bash

# AltStore PAL update script for flexible multi-applications architecture
# Usage: ./update-altstore.sh <app_name> <environment> <firebase_url> <version> <ipa_size>

set -e

# Parameters
APP_NAME=${1:-"edulift"}
ENVIRONMENT=${2:-"staging"}  # staging, production, internal, beta, etc.
FIREBASE_URL=${3:-"__FIREBASE_URL__"}
VERSION=${4:-"__VERSION__"}
IPA_SIZE=${5:-"__SIZE__"}

# Configuration
REPO_ROOT=$(pwd)
APPS_DIR="$REPO_ROOT/apps"
SOURCES_DIR="$REPO_ROOT/sources"

echo "🚀 Updating AltStore PAL for $APP_NAME-$ENVIRONMENT"
echo "   Version: $VERSION"
echo "   Size: $IPA_SIZE bytes"
echo "   Firebase URL: $FIREBASE_URL"

# Functions
update_app_json() {
    local app_file="$APPS_DIR/${APP_NAME}-${ENVIRONMENT}.json"

    echo "📝 Updating app file: $app_file"

    # Créer le JSON de l'application avec les placeholders
    cat > "$app_file" << EOF
{
  "name": "$(get_app_display_name $APP_NAME)",
  "bundleIdentifier": "$(get_bundle_id $APP_NAME $ENVIRONMENT)",
  "developerName": "EduLift Team",
  "version": "$VERSION",
  "versionDate": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "versionDescription": "$(get_changelog $APP_NAME $ENVIRONMENT $VERSION)",
  "downloadURL": "$FIREBASE_URL",
  "localizedDescription": "$(get_description $APP_NAME $ENVIRONMENT)",
  "iconURL": "https://jrevillard.github.io/my-altstore/icons/${APP_NAME}-${ENVIRONMENT}.png",
  "tintColor": "$(get_tint_color $ENVIRONMENT)",
  "size": $IPA_SIZE,
  "category": "education",
  "tags": $(get_tags $APP_NAME $ENVIRONMENT),
  "subtitle": "$(get_subtitle $ENVIRONMENT)"
}
EOF

    echo "✅ App file updated: $app_file"
}

get_app_display_name() {
    local app_name=$1
    case "$app_name" in
        "edulift") echo "EduLift" ;;
        *) echo "$app_name" ;;
    esac
}

get_bundle_id() {
    local app_name=$1
    local environment=$2

    if [[ "$environment" == "staging" ]] || [[ "$environment" == "beta" ]]; then
        echo "com.edulift.app.staging"
    elif [[ "$environment" == "internal" ]]; then
        echo "com.edulift.app.internal"
    else
        echo "com.edulift.app"
    fi
}

get_changelog() {
    local app_name=$1
    local environment=$2
    local version=$3

    case "$environment" in
        "staging"|"beta")
            echo "Beta version $version - Latest features in testing"
            ;;
        "production")
            echo "Version $version - Bug fixes and improvements"
            ;;
        "internal")
            echo "Internal version $version - For team testing"
            ;;
        *)
            echo "Version $version"
            ;;
    esac
}

get_description() {
    local app_name=$1
    local environment=$2

    case "$environment" in
        "staging"|"beta")
            echo "EduLift - School Transportation Management (beta version)"
            ;;
        "production")
            echo "EduLift - School Transportation Management"
            ;;
        "internal")
            echo "EduLift - Internal version for team"
            ;;
        *)
            echo "EduLift - School Transportation Management"
            ;;
    esac
}

get_tint_color() {
    local environment=$1

    case "$environment" in
        "staging"|"beta") echo "#FF9500" ;;
        "production") echo "#2E86C1" ;;
        "internal") echo "#34C759" ;;
        *) echo "#2E86C1" ;;
    esac
}

get_subtitle() {
    local environment=$1

    case "$environment" in
        "staging"|"beta") echo "Testing version" ;;
        "production") echo "Official version" ;;
        "internal") echo "Internal version" ;;
        *) echo "" ;;
    esac
}

get_tags() {
    local app_name=$1
    local environment=$2

    local tags="[\"transport\", \"education\""

    if [[ "$environment" == "staging" ]] || [[ "$environment" == "beta" ]]; then
        tags="$tags, \"beta\", \"testing\""
    elif [[ "$environment" == "internal" ]]; then
        tags="$tags, \"internal\", \"team\""
    else
        tags="$tags, \"production\", \"stable\""
    fi

    tags="$tags]"
    echo "$tags"
}

update_sources() {
    local app_pattern="${APP_NAME}-${ENVIRONMENT}"

    echo "🔄 Updating sources that include: $app_pattern"

    # Update relevant sources
    if [[ "$app_pattern" == *"staging"* ]] || [[ "$app_pattern" == *"beta"* ]]; then
        update_source_json "beta.json" "$app_pattern"
    fi

    if [[ "$app_pattern" == *"production"* ]]; then
        update_source_json "production.json" "$app_pattern"
    fi

    # Internal source always includes everything
    update_source_json "internal.json" "$app_pattern"
}

update_source_json() {
    local source_file="$SOURCES_DIR/$1"
    local app_pattern=$2

    echo "📋 Updating source: $source_file"

    # Read current source file
    if [[ ! -f "$source_file" ]]; then
        echo "⚠️ Source file not found: $source_file"
        return
    fi

    # Extract source name and identifier
    local source_name=$(jq -r '.name' "$source_file")
    local source_id=$(jq -r '.identifier' "$source_file")

    # Update news
    local news_update=$(cat << EOF
    {
      "title": "Update $APP_NAME ($ENVIRONMENT)",
      "identifier": "news-${APP_NAME}-${ENVIRONMENT}-$(date +%s)",
      "caption": "New version $VERSION available.",
      "date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    }
EOF
)

    # Update source file
    jq --argjson news "$news_update" \
       '.news = [$news] + .news' \
       "$source_file" > "$source_file.tmp" && mv "$source_file.tmp" "$source_file"

    echo "✅ Source updated: $source_file"
}

# Main execution
main() {
    # Check parameters
    if [[ -z "$APP_NAME" || -z "$ENVIRONMENT" || -z "$FIREBASE_URL" ]]; then
        echo "❌ Missing parameters"
        echo "Usage: $0 <app_name> <environment> <firebase_url> [version] [ipa_size]"
        exit 1
    fi

    # Update app JSON file
    update_app_json

    # Update sources
    update_sources

    echo "🎉 AltStore PAL update completed successfully!"

    # Display important URLs
    echo ""
    echo "📱 AltStore PAL source URLs:"
    echo "   Beta: https://jrevillard.github.io/my-altstore/sources/beta.json"
    echo "   Production: https://jrevillard.github.io/my-altstore/sources/production.json"
    echo "   Internal: https://jrevillard.github.io/my-altstore/sources/internal.json"
    echo ""
    echo "🏠 Catalog: https://jrevillard.github.io/my-altstore/"
}

# Run main function
main "$@"