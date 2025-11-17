// Internationalization data for AltStore PAL catalogue
const i18n = {
    fr: {
        title: "Catalogue d'Applications - AltStore PAL",
        subtitle: "Applications Mobiles Multi-Platforms",
        tagline: "Gérez vos applications mobiles avec AltStore PAL",

        // Section header
        chooseSource: "Choisissez votre source d'applications",
        chooseSourceDesc: "Différentes sources pour différents besoins d'utilisation",

        // Priorities
        priority: "Priorité",
        recommended: "Recommandé",

        // Sections
        productionApps: {
            title: "Applications Officielles",
            subtitle: "Versions stables et approuvées",
            description: "Applications testées et validées pour usage en production. Versions stables et fiables.",
            features: ["Versions stables", "Support officiel", "Testées et validées", "Mises à jour contrôlées"],
            button: "Ajouter cette source"
        },
        betaApps: {
            title: "Applications Bêta",
            subtitle: "Dernières fonctionnalités en test",
            description: "Versions expérimentales avec les dernières fonctionnalités. Instables mais innovantes.",
            features: ["Dernières fonctionnalités", "Versions expérimentales", "Feedback bienvenu", "Mises à jour fréquentes"],
            button: "Ajouter cette source"
        },
        internalApps: {
            title: "Applications Internes",
            subtitle: "Accès complet à toutes les versions",
            description: "Ensemble complet pour l'équipe interne. Accès à toutes les versions et environnements de développement.",
            features: ["Accès complet", "Versions de développement", "Environnements de test", "Builds expérimentaux"],
            button: "Ajouter cette source (restreint)"
        },

        // Instructions
        instructions: {
            title: "🔧 Comment installer",
            steps: [
                "Ouvrez AltStore PAL sur votre iPhone",
                "Copiez l'URL de la source souhaitée ci-dessous",
                "Ajoutez la source dans AltStore PAL (onglet 'Sources')",
                "Installez les applications depuis la source"
            ],
            note: "Les applications nécessitent AltStore PAL (disponible sur l'App Store dans l'UE)"
        },

        // Footer
        footer: {
            powered: "Propulsé par",
            altStore: "AltStore PAL"
        },

        // SEO
        meta: {
            title: "Catalogue d'Applications - AltStore PAL",
            description: "Catalogue d'applications mobiles pour AltStore PAL. Installez facilement EduLift et d'autres applications multi-plateformes.",
            keywords: "AltStore PAL, applications mobiles, iOS, EduLift, catalogue apps"
        }
    },

    en: {
        title: "Applications Catalog - AltStore PAL",
        subtitle: "Multi-Platform Mobile Applications",
        tagline: "Manage your mobile applications with AltStore PAL",

        // Section header
        chooseSource: "Choose your application source",
        chooseSourceDesc: "Different sources for different use cases",

        // Priorities
        priority: "Priority",
        recommended: "Recommended",

        // Sections
        productionApps: {
            title: "Official Applications",
            subtitle: "Stable and approved versions",
            description: "Tested and validated applications for production use. Stable and reliable versions.",
            features: ["Stable versions", "Official support", "Tested and validated", "Controlled updates"],
            button: "Add this source"
        },
        betaApps: {
            title: "Beta Applications",
            subtitle: "Latest features in testing",
            description: "Experimental versions with the latest features. Unstable but innovative.",
            features: ["Latest features", "Experimental versions", "Feedback welcome", "Frequent updates"],
            button: "Add this source"
        },
        internalApps: {
            title: "Internal Applications",
            subtitle: "Complete access to all versions",
            description: "Complete collection for the internal team. Access to all versions and development environments.",
            features: ["Complete access", "Development versions", "Test environments", "Experimental builds"],
            button: "Add this source (restricted)"
        },

        // Instructions
        instructions: {
            title: "🔧 How to Install",
            steps: [
                "Open AltStore PAL on your iPhone",
                "Copy the URL of the desired source below",
                "Add the source in AltStore PAL (Sources tab)",
                "Install applications from the source"
            ],
            note: "Applications require AltStore PAL (available on App Store in EU)"
        },

        // Footer
        footer: {
            powered: "Powered by",
            altStore: "AltStore PAL"
        },

        // SEO
        meta: {
            title: "Applications Catalog - AltStore PAL",
            description: "Mobile applications catalog for AltStore PAL. Easily install EduLift and other multi-platform applications.",
            keywords: "AltStore PAL, mobile applications, iOS, EduLift, apps catalog"
        }
    }
};

// Detect browser language
function getBrowserLanguage() {
    const browserLang = navigator.language || navigator.userLanguage || 'en';

    // Extract primary language code (fr, en, es, etc.)
    const primaryLang = browserLang.split('-')[0];

    // Return supported language or default to English
    if (i18n[primaryLang]) {
        return primaryLang;
    }

    return 'en';
}

// Get translations for current language
function t(key) {
    const lang = getBrowserLanguage();

    // Navigate through nested keys (e.g., "productionApps.title")
    const keys = key.split('.');
    let translation = i18n[lang];

    for (const k of keys) {
        translation = translation?.[k];
    }

    return translation || key; // Fallback to key if translation not found
}

// Export for use in HTML
window.i18n = i18n;
window.t = t;
window.getBrowserLanguage = getBrowserLanguage;