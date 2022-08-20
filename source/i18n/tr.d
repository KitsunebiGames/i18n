module i18n.tr;
import i18n.mo;
import i18n.culture;
import std.path;
import std.file : read;
import std.uni : toLower;
import std.format : format;

package(i18n) {
    struct TREntry {
        string source;
        string[] targets;
        const(char)*[] cTargets;
    }
}

private {
    MOFile* loadedLanguage;

    enum TLFormats {
        none,
        gettext
    }

    TLFormats currentFormat = TLFormats.none;
    TREntry[string] lookuptable;
}

/**
    Gets the name of the language
*/
string i18nGetLanguageName(string file) {
    import std.path : baseName, stripExtension;

    // Load language file
    auto f = i18nMOLoad(cast(ubyte[])read(file));

    // Try to read language from LANG_NAME strid
    string langName = f.i18nMOStr("LANG_NAME").dup;
    destroy!false(f);

    // Not found? Then get (inaccurate) fallback name from internal list
    if (langName == "LANG_NAME") langName = i18nGetCultureNativeLanguageEstimate(file.baseName.stripExtension);

    // Not found? Then get fallback from english name list
    if (langName == "LANG_NAME") langName = i18nGetCultureLanguage(file.baseName.stripExtension);

    // Not found? Okay we give up, throw some text to know we don't know what the heck to do
    if (!langName) return "<UNKNOWN LANGUAGE>";

    // Return whatever we got
    return langName;
}

/**
    Clears currently loaded language
*/
void i18nClearLanguage() {
    lookuptable.clear();
    loadedLanguage = null;
}

/**
    Loads a language
*/
bool i18nLoadLanguage(string file) {

    // Empty path/null = unload
    if (file.length == 0) {
        i18nClearLanguage();
        return true;
    }

    // Actually load
    lookuptable.clear();
    switch(file.extension.toLower) {
        case ".mo":
            try {
                loadedLanguage = i18nMOLoad(cast(ubyte[])read(file));

                lookuptable = i18nMOGenStrings(loadedLanguage);
                currentFormat = TLFormats.gettext;
            } catch (Exception ex) {
                return false;
            }
            return true;
        default: 
            throw new Exception("i18n: Invalid file format %s".format(file.extension));
    }
}

/**
    Returns D string translation of iText
*/
string _(string iText) {
    
    // If in lookup table, return from lookup table
    if (iText in lookuptable) 
        return lookuptable[iText].targets[0];

    // Otherwise try just in case from file.
    switch(currentFormat) {
        case TLFormats.gettext:
            if (loadedLanguage) return loadedLanguage.i18nMOStr(iText);
            return iText;
        default:
            return iText;
    }
}

/**
    Returns C string translation of iText
*/
const(char)* __(string iText) {
    import std.string : toStringz;
    
    // If in lookup table, return from lookup table
    if (iText in lookuptable) 
        return lookuptable[iText].cTargets[0];

    // Otherwise try just in case from file.
    switch(currentFormat) {
        case TLFormats.gettext:
            if (loadedLanguage) return loadedLanguage.i18nMOStrC(iText);
            return iText.toStringz;
        default:
            return iText.toStringz;
    }
}