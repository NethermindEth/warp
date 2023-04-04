Start =
    __  type: Type __ { return type; }

// Terminals
PrimitiveWhiteSpace "whitespace" =
    "\t"
    / "\v"
    / "\f"
    / " "
    / "\u00A0"
    / "\uFEFF"
    / Zs

WhiteSpace "whitespace" =
    PrimitiveWhiteSpace

// Separator, Space
Zs =
    [\u0020\u00A0\u1680\u2000-\u200A\u202F\u205F\u3000]

LineTerminator =
    [\n\r\u2028\u2029]

LineTerminatorSequence "end of line" =
    "\n"
    / "\r\n"
    / "\r"
    / "\u2028"
    / "\u2029"

__ =
    (WhiteSpace / LineTerminator)*

TRUE = "true"
FALSE = "false"
OLD = "old"
LET = "let"
IN = "in"
BOOL = "bool"
ADDRESS = "address"
PAYABLE = "payable"
BYTES = "bytes"
STRING = "string"
BYTE = "byte"
MEMORY = "memory"
STORAGE = "storage"
CALLDATA = "calldata"
MAPPING = "mapping"
FUNCTION = "function"
RETURNS = "returns"
PUBLIC = "public"
EXTERNAL = "external"
INTERNAL = "internal"
PRIVATE = "private"
PURE = "pure"
VIEW = "view"
NONPAYABLE = "nonpayable"
INT_CONST = "int_const"
RATIONAL_CONST = "rational_const"
POINTER = "pointer"
REF = "ref"
TUPLE = "tuple"
TYPE = "type"
LITERAL_STRING = "literal_string"
MODIFIER = "modifier"
CONTRACT = "contract"
SUPER = "super"
LIBRARY = "library"
STRUCT = "struct"
ENUM = "enum"
MSG = "msg"
ABI = "abi"
BLOCK = "block"
TX = "tx"
SLICE = "slice"
CONSTANT = "constant"
HEX = "hex"
MODULE = "module"

Keyword =
    TRUE
    / FALSE
    / OLD
    / LET
    / IN
    / BOOL
    / ADDRESS
    / PAYABLE
    / BYTES
    / BYTE
    / MEMORY
    / STORAGE
    / CALLDATA
    / STRING
    / MAPPING
    / FUNCTION
    / RETURNS
    / EXTERNAL
    / INTERNAL
    / PURE
    / VIEW
    / NONPAYABLE
    / INT_CONST
    / RATIONAL_CONST
    / TUPLE
    / TYPE
    / LITERAL_STRING
    / MODIFIER
    / CONTRACT
    / SUPER
    / LIBRARY
    / STRUCT
    / ENUM
    / MSG
    / ABI
    / BLOCK
    / SLICE
    / TX
    / CONSTANT

StringLiteral =
    "'" chars: SingleStringChar* "'" {
        return [chars.join(""), "string"];
    }
    / '"' chars: DoubleStringChar* '"' {
        return [chars.join(""), "string"];
    }

HexLiteral =
    HEX '"' val: HexDigit* '"' {
        return [val.join(""), "hexString"];
    }
    / HEX "'" val: HexDigit* "'" {
        return [val.join(""), "hexString"];
    }

AnyChar =
    .

DoubleStringChar =
    !('"' / "\\" / LineTerminator) AnyChar { return text(); }
    / "\\" sequence: EscapeSequence { return sequence; }
    / LineContinuation

SingleStringChar =
    !("'" / "\\" / LineTerminator) AnyChar { return text(); }
    / "\\" sequence: EscapeSequence { return sequence; }
    / LineContinuation

LineContinuation =
    "\\" LineTerminatorSequence { return ""; }

EscapeSequence =
    CharEscapeSequence
    / "0" !DecDigit { return "\0"; }
    / HexEscapeSequence
    / UnicodeEscapeSequence

CharEscapeSequence =
    SingleEscapeChar
    / NonEscapeChar

SingleEscapeChar =
    "'"
    / '"'
    / "\\"
    / "b"  { return "\b"; }
    / "f"  { return "\f"; }
    / "n"  { return "\n"; }
    / "r"  { return "\r"; }
    / "t"  { return "\t"; }
    / "v"  { return "\v"; }

NonEscapeChar =
    !(EscapeChar / LineTerminator) AnyChar { return text(); }

HexDigit =
    [0-9a-f]i

DecDigit =
    [0-9]

EscapeChar =
    SingleEscapeChar
    / DecDigit
    / "x"
    / "u"

HexEscapeSequence =
    "x" digits: $(HexDigit HexDigit) {
        return String.fromCharCode(parseInt(digits, 16));
    }

UnicodeEscapeSequence =
    "u" digits: $(HexDigit HexDigit HexDigit HexDigit) {
        return String.fromCharCode(parseInt(digits, 16));
    }

Identifier =
    !(Keyword [^a-zA-Z0-9_]) id: ([a-zA-Z_$][a-zA-Z$0-9_]*) { return text(); }

Word =
    id: ([a-zA-Z_$][a-zA-Z$0-9_]*) { return text(); }

Number =
    [0-9]+ { return BigInt(text()); }

MaybeNegNumber =
    sign: ("-"?) __ num: Number {
        return sign === null ? num : -num;
    }

InaccessibleDynamicType =
    "inaccessible dynamic type" {
        return new InaccessibleDynamicType();
    }

SimpleType =
    BoolType
    / InaccessibleDynamicType
    / AddressType
    / IntLiteralType
    / RationalLiteralType
    / StringLiteralType
    / IntType
    / BytesType
    / FixedSizeBytesType
    / StringType
    / UserDefinedType

StringLiteralErrorMsg =
    "(" [^\)]* ")" {
        return [text(), false];
    }

StringLiteralType =
    LITERAL_STRING __ literal: (
        StringLiteral
        / HexLiteral
        / StringLiteralErrorMsg
    ) {
        return new StringLiteralType(literal[1]);
    }

IntLiteralType =
    INT_CONST __ prefix: MaybeNegNumber rest: ("...(" [^\)]* ")..." Number)? {
        return new IntLiteralType(prefix);
    }

RationalLiteralType =
    RATIONAL_CONST __ numerator: MaybeNegNumber __ "/" __ denominator: Number {
        return new RationalLiteralType({numerator: numerator, denominator: denominator})
    }

BoolType =
    BOOL { return new BoolType(); }

AddressType =
    ADDRESS __ payable: (PAYABLE?) {
        return new AddressType(payable !== null);
    }

IntType =
    unsigned: ("u"?) "int" width: (Number?) {
        const signed = unsigned === null;
        const bitWidth = width === null ? 256 : Number(width);

        return new IntType(bitWidth, signed);
    }

FixedSizeBytesType =
    BYTES width: Number {
        return new FixedBytesType(Number(width));
    }
    / BYTE {
        return new FixedBytesType(1);
    }

BytesType =
    BYTES !Number { return new BytesType(); }

StringType =
    STRING { return new StringType(); }

FQName =
    Identifier ( "." Word )* { return text(); }

UserDefinedType =
    STRUCT __ name: FQName {
        return makeUserDefinedType(
            name,
            StructDefinition,
            options.inference,
            options.ctx
        );
    }
    / ENUM __ name: FQName {
        return makeUserDefinedType(
            name,
            EnumDefinition,
            options.inference,
            options.ctx
        );
    }
    / CONTRACT __ SUPER? __ name: FQName {
        return makeUserDefinedType(
            name,
            ContractDefinition,
            options.inference,
            options.ctx
        );
    }
    / LIBRARY __ name: FQName {
        return makeUserDefinedType(
            name,
            ContractDefinition,
            options.inference,
            options.ctx
        );
    } / name: FQName {
        return makeUserDefinedType(
            name,
            UserDefinedValueTypeDefinition,
            options.inference,
            options.ctx
        );
    }

MappingType =
    MAPPING __ "(" __ keyType: ArrayPtrType __ "=>" __ valueType: Type __ ")" {
        // Identifiers referring directly to state variable maps
        // don't have a pointer suffix.
        // So we wrap them in a PointerType here.
        // This means we explicitly disagree with the exact typeString.
        return new PointerType(
            new MappingType(keyType, valueType),
            DataLocation.Storage
        );
    }

DataLocation =
    MEMORY
    / STORAGE
    / CALLDATA

PointerType =
    POINTER
    / REF
    / SLICE

TypeList =
    head: Type tail: (__ "," __ Type)* {
        return tail.reduce(
            (lst, cur) => {
                lst.push(cur[3]);

                return lst;
            },
            [head]
        );
    }
    / __ {
        return [];
    }

FunctionVisibility =
    PRIVATE
    / INTERNAL
    / EXTERNAL
    / PUBLIC

FunctionMutability =
    PURE
    / VIEW
    / PAYABLE
    / NONPAYABLE
    / CONSTANT

FunctionDecorator =
    FunctionVisibility
    / FunctionMutability

FunctionDecoratorList =
    head: FunctionDecorator tail: (__ FunctionDecorator)* {
        return tail.reduce(
            (acc, cur) => {
                acc.push(cur[1]);

                return acc;
            },
            [head]
        );
    }

FunctionType =
    FUNCTION __ name: FQName? __ "(" __ args: TypeList? __ ")" __ decorators: (FunctionDecoratorList?) __ returns: (RETURNS __ "(" __ TypeList __ ")")? {
        const retTypes = returns === null ? [] : returns[4];
        const [visibility, mutability] = getFunctionAttributes(
            decorators === null ? [] : decorators
        );

        return new FunctionType(
            name === null ? undefined : name,
            args,
            retTypes,
            visibility,
            mutability
        );
    }

ModifierType =
    MODIFIER __ "(" __ args: TypeList? __ ")" {
        throw new Error("Shouldn't try to type modifiers!");
    }

TupleType =
    TUPLE __ "(" __  elements: TypeList? __ ")" {
        return new TupleType(elements === null ? [] : elements);
    }

TypeExprType =
    TYPE __ "(" innerT: Type ")" {
        return new TypeNameType(innerT);
    }

BuiltinTypes =
    name: MSG {
        return new BuiltinType(name);
    }
    / name: ABI {
        return new BuiltinType(name);
    }
    / name: BLOCK {
        return new BuiltinType(name);
    }
    / name: TX {
        return new BuiltinType(name);
    }

ModuleType =
    MODULE __ path: StringLiteral {
        return new ModuleType(path[0]);
    }

NonArrPtrType =
    MappingType
    / SimpleType
    / FunctionType

ArrayPtrType =
    head: NonArrPtrType
    tail: (
        __ !PointerType "[" __ size: Number? __ "]"
        / __ storageLocation: (DataLocation) pointerType: (__ PointerType)?
    )* {
    return tail.reduce(
            (acc, cur) => {
                acc = acc;
                
                if (cur.length > 3) {
                    const size = cur[4];

                    return new ArrayType(acc, size === null ? undefined : size);
                }

                const location = cur[1] as DataLocation;
                const kind = cur[2] === null ? undefined : cur[2][1];

                return new PointerType(acc, location, kind);
            },
            head
        );
    }

// Top-level rule
Type =
    ModuleType
    / ModifierType
    / TypeExprType
    / TupleType
    / BuiltinTypes
    / ArrayPtrType
