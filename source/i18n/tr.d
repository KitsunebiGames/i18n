module i18n.tr;
import i18n.mo;
import i18n.culture;
import std.path;
import std.file : read;
import std.uni : toLower;
import std.format : format;

private {
    enum TLFormats {
        none,
        gettext
    }

    TLFormats currentFormat = TLFormats.none;
}

bool i18nLoadLanguage(string file) {
    switch(file.extension.toLower) {
        case ".mo":
            try {
                i18nMOLoad(cast(ubyte[])read(file));
                currentFormat = TLFormats.gettext;
            } catch (Exception ex) {
                return false;
            }
            return true;
        default: 
            throw new Exception("i18n: Invalid file format %s".format(file.extension));
    }
}

string _(string iText) {
    switch(currentFormat) {
        case TLFormats.gettext:
            return i18nMOStr(iText);
        default:
            return iText;
    }
}