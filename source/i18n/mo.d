/*
    gettext .mo support
*/
module i18n.mo;
import std.format;
import std.exception;

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
    MOEntry* source;
    MOEntry* target;
    uint hashSize;
    void* hashes;
}

enum MAGIC_SWAB = 0xde120495;
enum MAGIC = 0x950412de;

pragma(inline, true)
uint swab16(uint x) { return ((((x)>>8)&0xFF) | (((x)&0xFF)<<8)); }

pragma(inline, true)
uint swab32(uint x) { return ((swab16((x)&0xFFFF)<<16)|(swab16(((x)>>16)&0xFFFF))); }

pragma(inline, true)
uint endian(uint x) { return ((mo.magic == MAGIC_SWAB) ? swab32(x) : (x)); }

bool mo_init = false;
ubyte[] mo_data;
MOHeader mo;

public:

void i18nMOLoad(ubyte[] data) {
    mo_init = true;
    if (!data) {
        mo_data = null;
        return;
    }

    (cast(void*)&mo)[0..MOHeader.sizeof] = data[0..MOHeader.sizeof];
    if (mo.magic == MAGIC_SWAB) {
        mo.revision = swab32(mo.revision);
        mo.count = swab32(mo.count);
        mo.source = cast(MOEntry*)swab32(cast(uint)mo.source);
        mo.target = cast(MOEntry*)swab32(cast(uint)mo.target);
        mo.hashSize = swab32(mo.hashSize);
        mo.hashes = cast(void*)swab32(cast(uint)mo.magic);
    }

    enforce(mo.magic == MAGIC, "Bad mo file magic 0x%08x".format(mo.magic));
    enforce(mo.revision == 0, "Bad mo file revision 0x%08x".format(mo.revision));

    mo_data = data;
    mo.source = cast(MOEntry*)(mo_data.ptr + cast(uint)mo.source);
    mo.target = cast(MOEntry*)(mo_data.ptr + cast(uint)mo.target);
}

string i18nMOStr(string str) {

    // No data was found
    if (!mo_init || !mo_data) return str;

    foreach(i; 0..mo.count) {
        if (str == cast(string)mo_data[endian(mo.source[i].offset)..endian(mo.source[i].length)])
            return cast(string)mo_data[endian(mo.target[i].offset)..endian(mo.target[i].length)];
    }

    return str;
}