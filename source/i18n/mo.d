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

struct MOFile {
    MOHeader header;
    MOEntry* sources;
    MOEntry* targets;
}

enum MAGIC_SWAB = 0xde120495;
enum MAGIC = 0x950412de;

pragma(inline, true)
uint endian(uint x) { return ((mo.header.magic == MAGIC_SWAB) ? swapEndian(x) : (x)); }

bool mo_init = false;
ubyte[] mo_data;
MOFile mo;

public:

void i18nMOLoad(ubyte[] data) {
    mo_init = true;
    if (!data) {
        mo_data = null;
        return;
    }

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

    mo_data = data;
    mo.sources = cast(MOEntry*)(mo_data.ptr+mo.header.sourceOffset);
    mo.targets = cast(MOEntry*)(mo_data.ptr+mo.header.targetOffset);
}

string i18nMOStr(string str) {

    // No data was found
    if (!mo_init || !mo_data) return str;

    foreach(i; 0..mo.header.count) {
        if (str == cast(string)mo_data[mo.sources[i].offset..endian(mo.sources[i].offset)+endian(mo.sources[i].length)]) {
            return cast(string)mo_data[mo.targets[i].offset..endian(mo.targets[i].offset)+endian(mo.targets[i].length)];
        }
    }

    return str;
}

const(char)* i18nMOStrC(string str) {
    import std.string : toStringz;

    // No data was found
    if (!mo_init || !mo_data) return str.toStringz;

    foreach(i; 0..mo.header.count) {
        if (str == cast(string)mo_data[mo.sources[i].offset..endian(mo.sources[i].offset)+endian(mo.sources[i].length)]) {
            return cast(const(char)*)&mo_data[mo.targets[i].offset];
        }
    }

    return str.toStringz;
}

TREntry[string] i18nMOGenStrings() {
    import std.string : toStringz;
    TREntry[string] entries;
    // TODO: implement pluralization
    foreach(i; 0..mo.header.count) {
        string source = cast(string)mo_data[mo.sources[i].offset..endian(mo.sources[i].offset)+endian(mo.sources[i].length)];
        string target0 = cast(string)mo_data[mo.targets[i].offset..endian(mo.targets[i].offset)+endian(mo.targets[i].length)];
        entries[source] = TREntry(source, [target0], [target0.toStringz]);
    }

    return entries;
}