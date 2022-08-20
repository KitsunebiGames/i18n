/*
    gettext .mo support
*/
module i18n.mo;
import i18n.tr;
import std.format;
import std.exception;
import std.string : fromStringz;
import std.bitmanip : swapEndian;

private:
struct MOEntry {
align(1):
    uint length;
    uint offset;
}

struct MOHeader {
align(1):
    uint magic;
    uint revision;
    uint count;
    uint sourceOffset;
    uint targetOffset;
    uint hashSize;
    void* hashes;
}

enum MAGIC_SWAB = 0xde120495;
enum MAGIC = 0x950412de;

pragma(inline, true)
uint endian(MOFile* f, uint x) { return ((f.header.magic == MAGIC_SWAB) ? swapEndian(x) : (x)); }

// bool mo_init = false;
// ubyte[] mo_data;
// MOFile mo;

public:

struct MOFile {
private:
    ubyte[] data;

    MOHeader header;
    MOEntry* sources;
    MOEntry* targets;
}

MOFile* i18nMOLoad(ubyte[] data) {
    if (data.length == 0) return null;

    MOFile* mo = new MOFile;
    mo.data = data;

    (cast(void*)&mo.header)[0..MOHeader.sizeof] = data[0..MOHeader.sizeof];
    if (mo.header.magic == MAGIC_SWAB) {
        mo.header.revision = swapEndian(mo.header.revision);
        mo.header.count = swapEndian(mo.header.count);
        mo.header.sourceOffset = swapEndian(mo.header.sourceOffset);
        mo.header.targetOffset = swapEndian(mo.header.targetOffset);
        mo.header.hashSize = swapEndian(mo.header.hashSize);
        mo.header.hashes = cast(void*)swapEndian(cast(size_t)mo.header.magic);
    }

    enforce(mo.header.magic == MAGIC, "Bad mo file magic 0x%08x".format(mo.header.magic));
    enforce(mo.header.revision == 0, "Bad mo file revision 0x%08x".format(mo.header.revision));

    mo.sources = cast(MOEntry*)(mo.data.ptr+mo.header.sourceOffset);
    mo.targets = cast(MOEntry*)(mo.data.ptr+mo.header.targetOffset);

    return mo;
}

string i18nMOStr(MOFile* mo, string str) {

    // No data was found
    if (!mo.data) return str;

    foreach(i; 0..mo.header.count) {
        if (str == cast(string)mo.data[mo.sources[i].offset..mo.endian(mo.sources[i].offset)+mo.endian(mo.sources[i].length)]) {
            
            // Empty translation? return base string.
            if (mo.targets[i].length == 0) return str;

            // Return the correct translation (pluralization 0)
            return cast(string)mo.data[mo.targets[i].offset..mo.endian(mo.targets[i].offset)+mo.endian(mo.targets[i].length)];
        }
    }

    return str;
}

const(char)* i18nMOStrC(MOFile* mo, string str) {
    import std.string : toStringz;

    // No data was found
    if (!mo.data) return str.toStringz;

    foreach(i; 0..mo.header.count) {
        if (str == cast(string)mo.data[mo.sources[i].offset..mo.endian(mo.sources[i].offset)+mo.endian(mo.sources[i].length)]) {
            
            // Empty translation? return base string.
            if (mo.targets[i].length == 0) return str.toStringz;

            // Return the correct translation (pluralization 0)
            return cast(const(char)*)&mo.data[mo.targets[i].offset];
        }
    }

    return str.toStringz;
}

TREntry[string] i18nMOGenStrings(MOFile* mo) {
    import std.string : toStringz;
    TREntry[string] entries;
    
    foreach(i; 0..mo.header.count) {

        // Skip untranslated entries
        if (mo.targets[i].length == 0) continue;

        // Add translation to translation table
        // TODO: Add pluralizations
        string source = cast(string)mo.data[mo.sources[i].offset..mo.endian(mo.sources[i].offset)+mo.endian(mo.sources[i].length)];
        string target0 = cast(string)mo.data[mo.targets[i].offset..mo.endian(mo.targets[i].offset)+mo.endian(mo.targets[i].length)];
        entries[source] = TREntry(source, [target0], [target0.toStringz]);
    }

    return entries;
}