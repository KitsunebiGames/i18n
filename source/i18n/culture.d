module i18n.culture;

private {
    string[] _countryCodes;
    string[string] _countryNames;

    string[] _languageCodes;
    string[string] _languageNames;
    string[string] _languageNativeNames;

    string _getLangCode(string code) {
        import std.uni : toLower;
        import std.algorithm.searching : canFind;

        // Impossible case
        if (code.length < 2) return null;
        
        // C = no language set
        if (code == "C") return code;

        // Lang codes are always first, so check the 2 first code digits
        string codecv = code[0..2].toLower();
        if (_languageCodes.canFind(codecv)) return codecv;
        return null;
    }

    string _getCountryCode(string code) {
        import std.string : indexOf;
        import std.uni : toUpper;
        import std.algorithm.searching : canFind;

        // Maybe it's just a country code?
        if (code.length == 2) {
            if (_countryCodes.canFind(code.toUpper)) return null;

            return code;
        }
        
        // Check for the 2 types of seperators
        ptrdiff_t sep = code.indexOf("_");
        if (sep == -1) sep = code.indexOf("-");
        if (sep == -1 && code.length == 2) return code;

        // No seperators, no single-country code
        return null;
    }
}

/*
    Initialize internal culture info
*/
static this() {
    _countryCodes = [
        "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT",
        "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI",
        "BJ", "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY",
        "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN",
        "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DO",
        "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", "FJ", "FK", "FM",
        "FO", "FR", "GA", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM",
        "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", "HM", "HN",
        "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS",
        "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", "KP",
        "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT",
        "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML",
        "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX",
        "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR",
        "NU", "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN",
        "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA",
        "SB", "SC", "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN",
        "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG",
        "TG", "TH", "TJ", "TK", "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW",
        "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI",
        "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW"
    ];

    _countryNames = [
        "AD": "Andorra",
        "AE": "United Arab Emirates",
        "AF": "Afghanistan",
        "AG": "Antigua and Barbuda",
        "AI": "Anguilla",
        "AL": "Albania",
        "AM": "Armenia",
        "AO": "Angola",
        "AQ": "Antarctica",
        "AR": "Argentina",
        "AS": "American Samoa",
        "AT": "Austria",
        "AU": "Australia",
        "AW": "Aruba",
        "AX": "Aaland Islands",
        "AZ": "Azerbaijan",
        "BA": "Bosnia & Herzegovina",
        "BB": "Barbados",
        "BD": "Bangladesh",
        "BE": "Belgium",
        "BF": "Burkina Faso",
        "BG": "Bulgaria",
        "BH": "Bahrain",
        "BI": "Burundi",
        "BJ": "Benin",
        "BL": "Saint Barthelemy",
        "BM": "Bermuda",
        "BN": "Brunei Darussalam",
        "BO": "Bolivia",
        "BQ": "Bonaire, Sint Eustatius & Saba",
        "BR": "Brazil",
        "BS": "Bahamas",
        "BT": "Bhutan",
        "BV": "Bouvet Island",
        "BW": "Botswana",
        "BY": "Belarus",
        "BZ": "Belize",
        "CA": "Canada",
        "CC": "Cocos Islands",
        "CD": "Democratic Republic of Congo",
        "CF": "Central African Republic",
        "CG": "Congo",
        "CH": "Switzerland",
        "CI": "Côte d'Ivoire",
        "CK": "Cook Islands",
        "CL": "Chile",
        "CM": "Cameroon",
        "CN": "China",
        "CO": "Colombia",
        "CR": "Costa Rica",
        "CU": "Cuba",
        "CV": "Cape Verde",
        "CW": "Curaçao",
        "CX": "Christmas Island",
        "CY": "Cyprus",
        "CZ": "Czech Republic",
        "DE": "Germany",
        "DJ": "Djibouti",
        "DK": "Denmark",
        "DM": "Dominica",
        "DO": "Dominican Republic",
        "DZ": "Algeria",
        "EC": "Ecuador",
        "EE": "Estonia",
        "EG": "Egypt",
        "EH": "Sahrawi Arab Democratic Republic",
        "ER": "Eritrea",
        "ES": "Spain",
        "ET": "Ethiopia",
        "FI": "Finland",
        "FJ": "Fiji",
        "FK": "Falkland Islands (Malvinas)",
        "FM": "Federated States of Micronesia",
        "FO": "Faroe Islands",
        "FR": "France",
        "GA": "Gabon",
        "GB": "United Kingdom",
        "GD": "Grenada",
        "GE": "Georgia",
        "GF": "French Guiana",
        "GG": "Guernsey",
        "GH": "Ghana",
        "GI": "Gibraltar",
        "GL": "Greenland",
        "GM": "Gambia",
        "GN": "Guinea",
        "GP": "Guadaloupe",
        "GQ": "Equatorial Guinea",
        "GR": "Greece",
        "GS": "South Georgia & South Sandwich Islands",
        "GT": "Guatemala",
        "GU": "Guam",
        "GW": "Guinea-Bissau",
        "GY": "Guyana",
        "HK": "Hong Kong",
        "HM": "Heard Island & McDonald Islands",
        "HN": "Honduras",
        "HR": "Croatia",
        "HT": "Haiti",
        "HU": "Hungary",
        "ID": "Indonesia",
        "IE": "Ireland",
        "IL": "Israel",
        "IM": "Isle of Man",
        "IN": "India",
        "IO": "British Indian Ocean Territory",
        "IQ": "Iraq",
        "IR": "Islamic Republic of Iran",
        "IS": "Iceland",
        "IT": "Italy",
        "JE": "Jersey",
        "JM": "Jamaica",
        "JO": "Jordan",
        "JP": "Japan",
        "KE": "Kenya",
        "KG": "Kyrgyzstan",
        "KH": "Cambodia",
        "KI": "Kiribati",
        "KM": "Comoros",
        "KN": "Saint Kitts & Nevis",
        "KP": "Democratic People's Republic of Korea",
        "KR": "Republic of Korea",
        "KW": "Kuwait",
        "KY": "Cayman Islands",
        "KZ": "Kazakhstan",
        "LA": "Lao People's Democratic Republic",
        "LB": "Lebalon",
        "LC": "Saint Lucia",
        "LI": "Lichtenstein",
        "LK": "Sri Lanka",
        "LR": "Liberia",
        "LS": "Lesotho",
        "LT": "Lithuania",
        "LU": "Luxembourg",
        "LV": "Latvia",
        "LY": "Libya",
        "MA": "Morocco",
        "MC": "Monaco",
        "MD": "Republic of Moldova",
        "ME": "Montenegro",
        "MF": "Saint Martin (French part)",
        "MG": "Madagascar",
        "MH": "Marshall Islands",
        "MK": "North Macedonia",
        "ML": "Mali",
        "MM": "Myanmar",
        "MN": "Mongolia",
        "MO": "Macao",
        "MP": "Northen Marina Islands",
        "MQ": "Martinique",
        "MR": "Mauritania",
        "MS": "Montserrat",
        "MT": "Malta",
        "MU": "Mauritius",
        "MV": "Maldives",
        "MW": "Malawi",
        "MX": "Mexico",
        "MY": "Malaysia",
        "MZ": "Mozambique",
        "NA": "Namibia",
        "NC": "New Caledonia",
        "NE": "Niger",
        "NF": "Norfolk Island",
        "NG": "Nigeria",
        "NI": "Nicaragua",
        "NL": "Netherlands",
        "NO": "Norway",
        "NP": "Nepal",
        "NR": "Nauru",
        "NU": "Niue",
        "NZ": "New Zealand",
        "OM": "Oman",
        "PA": "Panama",
        "PE": "Peru",
        "PF": "French Polynesia",
        "PG": "Papua New Guinea",
        "PH": "Phillipines",
        "PK": "Pakistan",
        "PL": "Poland",
        "PM": "Saint Pierre & Miquelon",
        "PN": "Pitcairn",
        "PR": "Puerto Rico",
        "PS": "Palestine",
        "PT": "Portugal",
        "PW": "Palau",
        "PY": "Paraguay",
        "QA": "Qatar",
        "RE": "Reunion",
        "RO": "Romania",
        "RS": "Serbia",
        "RU": "Russian Federation",
        "RW": "Rwanda",
        "SA": "Saudi Arabia",
        "SB": "Solomon Islands",
        "SC": "Seychelles",
        "SD": "Sudan",
        "SE": "Sweden",
        "SG": "Singapore",
        "SH": "Saint Helena, Ascension & Tristan da Cunha",
        "SI": "Slovenia",
        "SJ": "Svalbard & Jan Mayen",
        "SK": "Slovakia",
        "SL": "Sierra Leone",
        "SM": "San Marino",
        "SN": "Senegal",
        "SO": "Somalia",
        "SR": "Suriname",
        "SS": "South Sudan",
        "ST": "Sao Tome & Principe",
        "SV": "El Salvador",
        "SX": "Sint Maarten (Dutch part)",
        "SY": "Syrian Arab Republic",
        "SZ": "Swaziland",
        "TC": "Turks & Caicos Islands",
        "TD": "Chad",
        "TF": "French Southern Territories",
        "TG": "Togo",
        "TH": "Thailand",
        "TJ": "Tajikistan",
        "TK": "Tokelau",
        "TL": "Timor-Leste",
        "TM": "Turkmenistan",
        "TN": "Tunisia",
        "TO": "Tonga",
        "TR": "Turkey",
        "TT": "Trinidad & Tobago",
        "TV": "Tuvalu",
        "TW": "Taiwan",
        "TZ": "United Republic of Tanzania",
        "UA": "Ukraine",
        "UG": "Uganda",
        "UM": "United States Minor Outlying Islands",
        "US": "United States",
        "UY": "Uruguay",
        "UZ": "Uzbekistan",
        "VA": "Holy See (Vatican City State)",
        "VC": "Saint Vincent & Grenadines",
        "VE": "Bolivarian Republic of Venezuela",
        "VG": "British Virgin Islands",
        "VI": "US Virgin Islands",
        "VN": "Vietnam",
        "VU": "Vanuatu",
        "WF": "Wallis & Futuna",
        "WS": "Samoa",
        "YE": "Yemen",
        "YT": "Mayotte",
        "ZA": "South Africa",
        "ZM": "Zambia",
        "ZW": "Zimbabwe"
    ];

    _languageCodes = [
        "aa", "ab", "ae", "af", "ak", "am", "an", "ar", "as", "av", "ay", "az",
        "ba", "be", "bg", "bh", "bi", "bm", "bn", "bo", "br", "bs", "ca", "ce",
        "ch", "co", "cr", "cs", "cu", "cv", "cy", "da", "de", "dv", "dz", "ee",
        "el", "en", "eo", "es", "et", "eu", "fa", "ff", "fi", "fj", "fo", "fr",
        "fy", "ga", "gd", "gl", "gn", "gu", "gv", "ha", "he", "hi", "ho", "hr",
        "ht", "hu", "hy", "hz", "ia", "id", "ie", "ig", "ii", "ik", "io", "is",
        "it", "iu", "ja", "jv", "ka", "kg", "ki", "kj", "kk", "kl", "km", "kn",
        "ko", "kr", "ks", "ku", "kv", "kw", "ky", "la", "lb", "lg", "li", "ln",
        "lo", "lt", "lu", "lv", "mg", "mh", "mi", "mk", "ml", "mn", "mr", "ms",
        "mt", "my", "na", "nb", "nd", "ne", "ng", "nl", "nn", "no", "nr", "nv",
        "ny", "oc", "oj", "om", "or", "os", "pa", "pi", "pl", "ps", "pt", "qu",
        "rm", "rn", "ro", "ru", "rw", "sa", "sc", "sd", "se", "sg", "si", "sk",
        "sl", "sm", "sn", "so", "sq", "sr", "ss", "st", "su", "sv", "sw", "ta",
        "te", "tg", "th", "ti", "tk", "tl", "tn", "to", "tr", "ts", "tt", "tw",
        "ty", "ug", "uk", "ur", "uz", "ve", "vi", "vo", "wa", "wo", "xh", "yi",
        "yo", "za", "zh", "zu"
    ];

    _languageNames = [
        "aa": "Afar",
        "ab": "Abkahzian",
        "ae": "Avestan",
        "af": "Afrikaans",
        "ak": "Akan",
        "am": "Amharic",
        "an": "Aragonese",
        "ar": "Arabic",
        "as": "Assamese",
        "av": "Avaric",
        "ay": "Aymara",
        "az": "Azerbaijani",
        "ba": "Bashkir",
        "be": "Belarusian",
        "bg": "Bulgarian",
        "bh": "Bihari",
        "bi": "Bislama",
        "bm": "Bambara",
        "bn": "Bengali",
        "bo": "Tibetan",
        "br": "Breton",
        "bs": "Bosnian",
        "ca": "Catlan",
        "ce": "Chechen",
        "ch": "Chamorro",
        "co": "Corsican",
        "cr": "Cree",
        "cs": "Czech",
        "cu": "Church Slavic",
        "cv": "Chuvash",
        "cy": "Welsh",
        "da": "Danish",
        "de": "German",
        "dv": "Divehi",
        "dz": "Dzongkha",
        "ee": "Ewe",
        "el": "Greek",
        "en": "English",
        "eo": "Esperanto",
        "es": "Spanish",
        "et": "Estonian",
        "eu": "Basque",
        "fa": "Persian",
        "ff": "Fulah",
        "fi": "Finnish",
        "fj": "Fijian",
        "fo": "Faroese",
        "fr": "French",
        "fy": "Western Frisian",
        "ga": "Irish",
        "gd": "Gaelic",
        "gl": "Galacian",
        "gn": "Guarani",
        "gu": "Gujarati",
        "gv": "Manx",
        "ha": "Hausa",
        "he": "Hebrew",
        "hi": "Hindi",
        "ho": "Hiri Motu",
        "hr": "Croatian",
        "ht": "Haitian",
        "hu": "Hungarian",
        "hy": "Armenian",
        "hz": "Herero",
        "ia": "Interlingua",
        "id": "Indonesian",
        "ie": "Interlingue",
        "ig": "Igbo",
        "ii": "Sichuan Yi",
        "ik": "Inupiak",
        "io": "Ido",
        "is": "Icelandic",
        "it": "Italian",
        "iu": "Inuktitut",
        "ja": "Japanese",
        "jv": "Javanese",
        "ka": "Georgian",
        "kg": "Kongo",
        "ki": "Kikuyu",
        "kj": "Kuanyama",
        "kk": "Kazakh",
        "kl": "Greenlandic",
        "km": "Central Khmer",
        "kn": "Kannada",
        "ko": "Korean",
        "kr": "Kanuri",
        "ks": "Kashmiri",
        "ku": "Kurdish",
        "kv": "Komi",
        "kw": "Cornish",
        "ky": "Kirghiz",
        "la": "Latin",
        "lb": "Luxembourgish",
        "lg": "Ganda",
        "li": "Limburgish",
        "ln": "Lingala",
        "lo": "Lao",
        "lt": "Lithuanian",
        "lu": "Luba-Katanga",
        "lv": "Latvian",
        "mg": "Malagasy",
        "mh": "Marshallese",
        "mi": "Maori",
        "mk": "Macedonian",
        "ml": "Malayalam",
        "mn": "Mongolian",
        "mr": "Marathi",
        "ms": "Malay",
        "mt": "Maltese",
        "my": "Burmese",
        "na": "Nauru",
        "nb": "Norwegian Bokmål",
        "nd": "North Ndebele",
        "ne": "Nepali",
        "ng": "Ndonga",
        "nl": "Dutch",
        "nn": "Norwegian Nynorsk",
        "no": "Norwegian",
        "nr": "South Ndebele",
        "nv": "Navajo",
        "ny": "Chichewa",
        "oc": "Occitan",
        "oj": "Ojibwa",
        "om": "Omoro",
        "or": "Oriya",
        "os": "Ossetian",
        "pa": "Panjabi",
        "pi": "Pali",
        "pl": "Polish",
        "ps": "Pushto",
        "pt": "Portugese",
        "qu": "Quechua",
        "rm": "Romansh",
        "rn": "Rundi",
        "ro": "Romanian",
        "ru": "Russian",
        "rw": "Kinyarwanda",
        "sa": "Sanskrit",
        "sc": "Sardinian",
        "sd": "Sindhi",
        "se": "Northen Sami",
        "sg": "Sango",
        "si": "Sinhala",
        "sk": "Slovak",
        "sl": "Slovenian",
        "sm": "Samoan",
        "sn": "Shona",
        "so": "Somali",
        "sq": "Albanian",
        "sr": "Serbian",
        "ss": "Swati",
        "st": "Southern Sotho",
        "su": "Sundanese",
        "sv": "Swedish",
        "sw": "Swahili",
        "ta": "Tamil",
        "te": "Tegulu",
        "tg": "Tajik",
        "th": "Thai",
        "ti": "Tigrinya",
        "tk": "Turkmen",
        "tl": "Tagalog",
        "tn": "Tswana",
        "to": "Tonga",
        "tr": "Turkish",
        "ts": "Tsonga",
        "tt": "Tatar",
        "tw": "Twi",
        "ty": "Tahitian",
        "ug": "Ughur",
        "uk": "Ukranian",
        "ur": "Urdu",
        "uz": "Uzbek",
        "ve": "Venda",
        "vi": "Vietnamese",
        "vo": "Volapük",
        "wa": "Walloon",
        "wo": "Wolof",
        "xh": "Xhosa",
        "yi": "Yiddish",
        "yo": "Yoruba",
        "za": "Zhuang",
        "zh": "Chinese",
        "zu": "Zulu"
    ];

    /*
        Estimated language names for fallback
        This list is inaccurate and incomplete.
    */
    _languageNativeNames = [
        "aa": "Qafaraf",
        "ab": "Аҧсуа бызшәа",
        "ae": "𐬛𐬍𐬥 𐬛𐬀𐬠𐬌𐬫𐬭𐬵",
        "af": "Afrikaans", // No spelling found
        "ak": "Akan", // No spelling found
        "am": "ኣማርኛ",
        "an": "Aragonés",
        "ar": "عربية يهودية",
        "as": "অসমীয়া",
        "av": "Avaric",
        "ay": "Aymar aru",
        "az": "Azərbaycan dili",
        "ba": "Башҡортса",
        "be": "Беларуская мова",
        "bg": "Български",
        "bh": "Bihari",
        "bi": "Bislama",
        "bm": "Bamanankan",
        "bn": "বাংলা",
        "bo": "ཁམས་སྐད",
        "br": "Brezhoneg",
        "bs": "Bosanski",
        "ca": "Catlan",
        "ce": "Нохчийн мотт",
        "ch": "Finuʼ Chamoru",
        "co": "Corsu",
        "cr": "Cree", // There's 4 versions of Cree, need to add a way to differentate between versions
        "cs": "Čeština",
        "cu": "Church Slavic",
        "cv": "Чӑвашла",
        "cy": "Cymraeg",
        "da": "Dansk",
        "de": "Deutsch",
        "dv": "Divehi", // No spelling found
        "dz": "རྫོང་ཁ་",
        "ee": "Eʋegbe",
        "el": "ελληνικά",
        "en": "English",
        "eo": "Esperanto",
        "es": "Español",
        "et": "Eesti keel",
        "eu": "Euskara",
        "fa": "فارسی",
        "ff": "Fulah", // No spelling found
        "fi": "Suomi",
        "fj": "Na vosa vaka-Viti",
        "fo": "Føroyskt mál",
        "fr": "Français",
        "fy": "Frysk",
        "ga": "Gaeilge",
        "gd": "Gàidhlig",
        "gl": "Galacian", // No spelling found
        "gn": "Avañeʼẽ",
        "gu": "ગુજરાતી",
        "gv": "Gaelg",
        "ha": "هَرْشَن هَوْسَ",
        "he": "עברית",
        "hi": "हिन्दी ",
        "ho": "Hiri Motu", // Is spelled same?
        "hr": "Hrvatski",
        "ht": "Kreyòl ayisyen",
        "hu": "Magyar",
        "hy": "Հայերէն",
        "hz": "Otjiherero",
        "ia": "Interlingua",
        "id": "Bahasa Indonesia",
        "ie": "Interlingue",
        "ig": "Ásụ̀sụ̀ Ìgbò",
        "ii": "ꆈꌠ꒿", // Not sure whether Nuosuhxop is correct.
        "ik": "Inupiak",
        "io": "Ido",
        "is": "Íslenska",
        "it": "Italiano",
        "iu": "ᐃᓄᒃᑎᑐᑦ",
        "ja": "日本語",
        "jv": "Basa Jawa",
        "ka": "ქართული ენა",
        "kg": "Kikongo",
        "ki": "Gĩkũyũ",
        "kj": "Kuanyama",
        "kk": "Қазақ тілі",
        "kl": "Kalaallisut",
        "km": "ភាសាខ្មែរ ",
        "kn": "ಕನ್ನಡ",
        "ko": "한국어",
        "kr": "Kànùrí",
        "ks": "कॉशुर", // Used first option, is this correct?
        "ku": "کوردی", // کوردی is one spelling of 3 depending on region, need way to differentiate
        "kv": "Коми кыв",
        "kw": "Kernewek",
        "ky": "Kirghiz",
        "la": "Lingua Latina",
        "lb": "Lëtzebuergesch",
        "lg": "Oluganda",
        "li": "Limburgs",
        "ln": "Lingala",
        "lo": "ພາສາລາວ",
        "lt": "Lietuvių kalba",
        "lu": "Luba-Katanga", // No spelling found
        "lv": "Latviešu valoda",
        "mg": "Malagasy",
        "mh": "Kajin M̧ajeļ", // One option of 2 was chosen
        "mi": "Māori",
        "mk": "македонски",
        "ml": "മലയാളം",
        "mn": "монгол",
        "mr": "मराठी",
        "ms": "Bahasa Melayu",
        "mt": "Malti",
        "my": "မြန်မာဘာသာ",
        "na": "Nauru",
        "nb": "Bokmål",
        "nd": "isiNdebele", // one of multiple options based on where in africa, chose one which seems to have the most speakers.
        "ne": "नेपाली",
        "ng": "Ndonga",
        "nl": "Nederlands",
        "nn": "Nynorsk",
        "no": "Norsk",
        "nr": "isiNdebele",
        "nv": "Diné Bizaad",
        "ny": "Chicheŵa",
        "oc": "Occitan", // There's multiple options, sticking with the base one
        "oj": "Ojibwa", // No spelling found
        "om": "Omoro", // No spelling found
        "or": "Oriya", // No spelling found
        "os": "ирон ӕвзаг",
        "pa": "ਪੰਜਾਬੀ",
        "pi": "पालि",
        "pl": "Polski",
        "ps": "Pushto", // No spelling found
        "pt": "Português",
        "qu": "Kechua",
        "rm": "Rumantsch",
        "rn": "íkiRǔndi",
        "ro": "Vlășéște ",
        "ru": "Русский язык",
        "rw": "Ikinyarwanda",
        "sa": "संस्कृत", // Multiple options, chose first one
        "sc": "Sardu",
        "sd": "سنڌي", // Spoken in multiple places with their own local spelling.
        "se": "Davvisámegiella",
        "sg": "Yângâ tî sängö",
        "si": "සිංහල",
        "sk": "Slovenčina",
        "sl": "Slovenščina",
        "sm": "Gagana fa‘a Sāmoa",
        "sn": "chiShona",
        "so": "af Soomaali",
        "sq": "Shqip",
        "sr": "српски",
        "ss": "siSwati",
        "st": "seSotho",
        "su": "Basa Sunda",
        "sv": "Svenska",
        "sw": "Kiswahili ",
        "ta": "தமிழ்",
        "te": "Tegulu", // No spelling found
        "tg": "тоҷикӣ",
        "th": "ภาษาไทย",
        "ti": "ትግርኛ",
        "tk": "Türkmen dili",
        "tl": "Tagalog", // Is same
        "tn": "Setswana",
        "to": "Chitonga",
        "tr": "Türkçe",
        "ts": "Xitsonga",
        "tt": "Tatarça",
        "tw": "Twi", // Is same
        "ty": "Reo Tahiti",
        "ug": "ئۇيغۇر", // Found via Wikipedia
        "uk": "украї́нська мо́ва",
        "ur": "اُردُو",
        "uz": "Ўзбек тили",
        "ve": "Tshivenḓa", // 2 options, chose first one
        "vi": "Tiếng Việt",
        "vo": "Volapük",
        "wa": "Walon",
        "wo": "Wolof", // Is same ?
        "xh": "isiXhosa",
        "yi": "ייִדיש",
        "yo": "Èdè Yorùbá",
        "za": "Vahcuengh",
        "zh": "中文", // There's incredibly many forms of chinese, this doesn't cover them all
        "zu": "isiZulu"
    ];

    // Set to user preferred locale
    i18nResetLocale();
}

/**
    Validates a country code

    Returns true if the code is a valid culture code
    Returns false if the code is not a valid culture code

    TODO: Validate whether encoding spec is correct
*/
bool i18nValidateCultureCode(bool caseSensitive = true)(string code) {
        
    // Special case, C = no language set.
    if (code == "C") return true;

    // Make sure we don't crash when handling lang/country get
    // by escaping early if we have too few characters to work with
    if (code.length < 2) return false;

    import std.uni : toUpper, toLower;
    import std.algorithm.searching : canFind;
    string lang = code[0..2];
    string country = code.length >= 5 ? code[3..5] : "";

    if (code.length == 2) {
        // Language code only

        // The main validity test
        static if (!caseSensitive) return _languageCodes.canFind(lang.toLower);
        else return _languageCodes.canFind(lang);

    } else if (code.length >= 5) {
        // Country AND language code
        
        // Make sure we either use a MS or gettext seperator
        if (!(code[2] == '-' || code[2] == '_')) return false;
        
        // The main validity test
        static if (!caseSensitive) return _languageCodes.canFind(lang.toLower) && _countryCodes.canFind(country.toUpper);
        else return _languageCodes.canFind(lang) && _countryCodes.canFind(country);

    }
    return false;
}

@("i18nValidateCultureCode Case Sensitive")
unittest {
    assert(i18nValidateCultureCode("da")); // Should succeed
    assert(i18nValidateCultureCode("da_DK")); // Should succeed
    assert(i18nValidateCultureCode("de-DE")); // Should succeed

    assert(!i18nValidateCultureCode("daDK")); // Should fail
    assert(!i18nValidateCultureCode("daaaaaDK")); // Should fail
    assert(!i18nValidateCultureCode("da/DK")); // Should fail
    assert(!i18nValidateCultureCode("zz_CH")); // Should fail
    assert(!i18nValidateCultureCode("ch_ZZ")); // Should fail
}

@("i18nValidateCultureCode Case Insensitive")
unittest {
    assert(i18nValidateCultureCode!false("da")); // Should succeed
    assert(i18nValidateCultureCode!false("da_dk")); // Should succeed
    assert(i18nValidateCultureCode!false("da_DK")); // Should succeed
    assert(i18nValidateCultureCode!false("en-US")); // Should succeed
    assert(i18nValidateCultureCode!false("en-us")); // Should succeed

    assert(!i18nValidateCultureCode!false("daDK")); // Should fail
    assert(!i18nValidateCultureCode!false("daaaaaDK")); // Should fail
    assert(!i18nValidateCultureCode!false("da/DK")); // Should fail
    assert(!i18nValidateCultureCode!false("zz_CH")); // Should fail
    assert(!i18nValidateCultureCode!false("ch_ZZ")); // Should fail
}

/**
    Gets the (english) name of the language associated with a culture code

    Returns null if code is invalid
*/
string i18nGetCultureLanguage(string code) {
    if (!i18nValidateCultureCode(code)) return null;
    if (code[0..2] !in _languageNames) return null;
    return _languageNames[code[0..2]];
}

@("i18nGetCultureLanguage")
unittest {
    assert(i18nGetCultureLanguage("da") == "Danish");
    assert(i18nGetCultureLanguage("de") == "German");
    assert(i18nGetCultureLanguage("en") == "English");
    assert(i18nGetCultureLanguage("ja") == "Japanese");
}

/**
    Attempts to get the name of the language associated with a culture code.
    This may be inaccurate due to things such as multiple versions of a language existing.

    ONLY USE THIS AS A FALLBACK.

    Returns null if code is invalid
*/
string i18nGetCultureNativeLanguageEstimate(string code) {
    if (!i18nValidateCultureCode(code)) return null;
    if (code[0..2] !in _languageNativeNames) return null;
    return _languageNativeNames[code[0..2]];
}

@("i18nGetCultureNativeLanguageEstimate")
unittest {
    assert(i18nGetCultureLanguage("da") == "Dansk");
    assert(i18nGetCultureLanguage("de") == "Deutsch");
    assert(i18nGetCultureLanguage("en") == "English");
    assert(i18nGetCultureLanguage("ja") == "日本語");
}

/**
    Gets the country associated with a culture code
*/
string i18nGetCultureCountry(string code) {
    if (!i18nValidateCultureCode(code)) return null;
    if (code.length < 5) return null;
    if (code[$-2..5] !in _countryNames) return null;
    return _countryNames[code[5-2..5]];
}

@("i18nGetCultureCountry")
unittest {
    assert(i18nGetCultureCountry("da_DK") == "Denmark");
    assert(i18nGetCultureCountry("en_US") == "United States");
    assert(i18nGetCultureCountry("en_GB") == "United Kingdom");
    assert(i18nGetCultureCountry("de_DE") == "Germany");
    assert(i18nGetCultureCountry("ja_JP") == "Japan");
}

/**
    Gets the current locale.
*/
string i18nGetLocale() {
    import core.stdc.locale : setlocale, LC_ALL;
    import std.string : fromStringz;
    string locale = cast(string)setlocale(LC_ALL, null).fromStringz.idup;
    
    // TODO: Implement
    return locale;
}

@("i18nGetLocale")
unittest {
    assert(i18nValidateCultureCode(i18nGetLocale()));
}

/**
    Sets the locale for the app.
*/
void i18nSetLocale(string locale) {
    import core.stdc.locale : setlocale, LC_ALL;
    import core.stdc.string : memcpy;
    import core.stdc.stdlib : malloc;
    import std.string : toStringz, fromStringz;

    if (locale == "C") {
        setlocale(LC_ALL, "C");
    } else if (locale == "") {
        setlocale(LC_ALL, "");
    } else setlocale(LC_ALL, (locale).toStringz);
}

void i18nResetLocale() {
    import core.stdc.locale : setlocale, LC_ALL;
    setlocale(LC_ALL, "");
}

struct LocaleConv {
    string decimalPoint;
    string thousandSep;
    string grouping;
    string intCurrSymbol;
    string currencySymbol;
    string monDecimalPoint;
    string monThousandsSep;
    string monGrouping;
    string positiveSign;
    string negativeSign;
    byte intFracDigits;
    byte fracDigits;
    byte pCSPrecedes;
    byte pSepBySpace;
    byte nCSPrecedes;
    byte nSepBySpace;
    byte pSignPosN;
    byte nSignPosN;
    byte intPCSPrecedes;
    byte intP_sep_by_space;
    byte intNCSPrecedes;
    byte intNSepBySpace;
    byte intPSignPosN;
    byte intNSignPosN;
}

/**
    Returns the locale's conversion units.
*/
LocaleConv i18nGetLocaleConversions() {
    import core.stdc.locale : localeconv, lconv;
    import std.string : fromStringz;
    lconv* conv = localeconv();
    return LocaleConv(
        cast(string)conv.decimal_point.fromStringz,
        cast(string)conv.thousands_sep.fromStringz,
        cast(string)conv.grouping.fromStringz,
        cast(string)conv.int_curr_symbol.fromStringz,
        cast(string)conv.currency_symbol.fromStringz,
        cast(string)conv.mon_decimal_point.fromStringz,
        cast(string)conv.mon_thousands_sep.fromStringz,
        cast(string)conv.mon_grouping.fromStringz,
        cast(string)conv.positive_sign.fromStringz,
        cast(string)conv.negative_sign.fromStringz,
        conv.int_frac_digits,
        conv.frac_digits,
        conv.p_cs_precedes,
        conv.p_sep_by_space,
        conv.n_cs_precedes,
        conv.n_sep_by_space,
        conv.p_sign_posn,
        conv.n_sign_posn,
        conv.int_p_cs_precedes,
        conv.int_p_sep_by_space,
        conv.int_n_cs_precedes,
        conv.int_n_sep_by_space,
        conv.int_p_sign_posn,
        conv.int_n_sign_posn
    );
}