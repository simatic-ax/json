USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS TryParse
    VAR protected
        deserializer : Deserializer;
        buffer : ARRAY[0..999] OF CHAR;
    END_VAR

    {Test}
    Method Public Test_TryParse_Value_as_String
        VAR
            JSON_Entry: STRING := '{ "key1": "nestedkey1"}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: STRING;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal('nestedkey1', value);
    END_Method

    {Test}
    Method Public Test_TryParse_Value_as_String2
        VAR
            JSON_Entry: STRING := '{"Name": "SIMATIC", data: {plc_type: 1518, OPC_SERVER_ENABLED: true}}';
            key: STRING := 'Name';
            len:DINT;
            keyFound: BOOL;
            value: STRING;
        END_VAR
        JSON_Entry:= '{"Name": "SIMATIC", data: {plc_type: 1518, OPC_SERVER_ENABLED: true}}';
        key := 'Name';
        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal('SIMATIC-', value);
    END_Method

    {Test}
    Method Public Test_TryParse_String
        VAR
            JSON_Entry: STRING := '{ "key1": {"nestedkey1": 123}}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: STRING;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal('{"nestedkey1": 123}', value);
    END_Method

    {Test}
    Method Public Test_TryParse_String_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: STRING;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal('123', value);
    END_Method

    {Test}
    Method Public Test_TryParse_LINT
        VAR
            JSON_Entry: STRING := '{ "leftBoundary": -9223372036854775808, "rightBoundary": 9223372036854775807, "outofBoundaryLeft": 9223372036854775808, "outofBoundaryRight": -9223372036854775809}';
            key: STRING;
            len:DINT;
            keyFound: BOOL;
            value: LINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);
        
        key:= 'leftBoundary';
        keyFound := deserializer.TryParse( key, value);
        Equal(LINT#-9223372036854775808, value);

        key:= 'rightBoundary';
        keyFound := deserializer.TryParse( key, value);
        Equal(LINT#9223372036854775807, value);

        key:= 'outofBoundaryLeft';
        keyFound := deserializer.TryParse( key, value);
        Equal(FALSE, keyFound);
        Equal(0, value);

        key:= 'outofBoundaryRight';
        keyFound := deserializer.TryParse( key, value);
        Equal(FALSE, keyFound);
        Equal(0, value);
    END_Method

    {Test}
    Method Public Test_TryParse_LINT_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: LINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(123, value);
    END_Method

    {Test}
    Method Public Test_TryParse_SINT
        VAR
            JSON_Entry: STRING := '{ "key1": -128}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: SINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal(-128, value);
    END_Method

    {Test}
    Method Public Test_TryParse_SINT_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: SINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(123, value);
    END_Method

    {Test}
    Method Public Test_TryParse_DINT
        VAR
            JSON_Entry: STRING := '{ "key1": 1234}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: DINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal(1234, value);
    END_Method

    {Test}
    Method Public Test_TryParse_DINT_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: SINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(123, value);
    END_Method

    {Test}
    Method Public Test_TryParse_INT
        VAR
            JSON_Entry: STRING := '{ "key1": 1234}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: INT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal(1234, value);
    END_Method

    {Test}
    Method Public Test_TryParse_INT_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: INT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(123, value);
    END_Method

    {Test}
    Method Public Test_TryParse_USINT
        VAR
            JSON_Entry: STRING := '{ "key1": 123}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: USINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal(USINT#123, value);
    END_Method

    {Test}
    Method Public Test_TryParse_USINT_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: USINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(123, value);
    END_Method

    {Test}
    Method Public Test_TryParse_UINT
        VAR
            JSON_Entry: STRING := '{ "key1": 1234}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: UINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal(UINT#1234, value);
    END_Method

    {Test}
    Method Public Test_TryParse_UINT_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: UINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(UINT#123, value);
    END_Method

    {Test}
    Method Public Test_TryParse_UDINT
        VAR
            JSON_Entry: STRING := '{ "key1": 1234}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: UDINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal(UDINT#1234, value);
    END_Method

    {Test}
    Method Public Test_TryParse_UDINT_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: UDINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(UDINT#123, value);
    END_Method

    {Test}
    Method Public Test_TryParse_ULINT
        VAR
            JSON_Entry: STRING := '{ "key1": 1234}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: ULINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( key, value);
        Equal(ULINT#1234, value);
    END_Method

    {Test}
    Method Public Test_TryParse_ULINT_Nested
        VAR
            JSON_Entry: STRING := '{ "aKey": "hallo", "anotherKey": 1234, "key1": {"nestedkey1": 123, "nestedkey2": "hallo", "nestedkey3": {"nestedInNestedkey1": 1234 }}}';
            keyArray: ARRAY [0..1] OF STRING := ['key1', 'nestedkey1'];
            len:DINT;
            keyFound: BOOL;
            value: ULINT;
        END_VAR

        len:= Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
        deserializer.buffer := REF(buffer);

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(ULINT#123, value);
    END_Method

END_CLASS

END_NAMESPACE