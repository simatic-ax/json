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
    Method Public Test_TryParse_String
        VAR
            JSON_Entry: STRING := '{ "key1": {"nestedkey1": 123}}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: STRING;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

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

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        keyFound := deserializer.TryParse( keyArray, value);
        Equal('123', value);
    END_Method

    {Test}
    Method Public Test_TryParse_LINT
        VAR
            JSON_Entry: STRING := '{ "key1": 1234}';
            key: STRING := 'key1';
            len:DINT;
            keyFound: BOOL;
            value: LINT;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));
        
        keyFound := deserializer.TryParse( key, value);
        Equal(1234, value);
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

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

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

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer)); 

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

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

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

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

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

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        keyFound := deserializer.TryParse( keyArray, value);
        Equal(123, value);
    END_Method

END_CLASS

END_NAMESPACE