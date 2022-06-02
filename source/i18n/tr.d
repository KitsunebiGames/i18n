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
    enum TLFormats {
        none,
        gettext
    }

    TLFormats currentFormat = TLFormats.none;
    TREntry[string] lookuptable;
}

/**
    Clears currently loaded language
*/
void i18nClearLanguage() {
    lookuptable.clear();
    i18nMOLoad(null);
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
                i18nMOLoad(cast(ubyte[])read(file));

                lookuptable = i18nMOGenStrings();
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
            return i18nMOStr(iText);
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
            return i18nMOStrC(iText);
        default:
            return iText.toStringz;
    }
}