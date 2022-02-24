USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer
NAMESPACE FindKeys

{TestFixture}
CLASS Test_FindKeyInBuffer
    VAR protected
        deserializer : Deserializer;

        buffer : ARRAY[0..999] OF CHAR;
        key: STRING;
        value: STRING;
        testIndex1: INT;
        testIndex2: INT;
    END_VAR

    {Test}
    Method Public Test_FindKeysPosition_in_JSON_SimpleEntries
        VAR
            JSON_Entry: STRING := '{"key ": " Elem ent1", "Hello": "something", "Nothing": 456, "Key 2": 1234 }';

            len:DINT;
            keyStart : int;
            keyEnd : int;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'key ';
        keyFound := deserializer.TryParse( key, value);
        Equal(TRUE, keyFound);

        key := 'Key 2';
        keyFound := deserializer.TryParse( key, value);
        Equal(TRUE, keyFound);

        key := 'not a key';
        keyFound := deserializer.TryParse( key, value);
        Equal(FALSE, keyFound);
    END_Method

    {Test}
    Method Public Test_FindKeysPosition_in_JSON_Single_Nested_Entry
        VAR
            JSON_Entry: STRING := '{"nested": {"nested1" : "hello", "nested2" : 1234  }}';

            len:DINT;
            keyStart : int;
            keyEnd : int;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'nested';
        keyFound := deserializer.TryParse( key, value);
        Equal(TRUE, keyFound);
    END_Method

    {Test}
    Method Public Test_FindKeysPosition_with_JSON_Nested_Entry
        VAR
            JSON_Entry: STRING := '{"key ": " Elem ent1", "nested": {"nested1" : "hello", "nested2" : 1234  }, "key2": " Elem ent1"}';

            len:DINT;
            keyStart : int;
            keyEnd : int;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'key ';
        keyFound := deserializer.TryParse( key, value);
        Equal(TRUE, keyFound);

        key := 'nested';
        keyFound := deserializer.TryParse( key, value);
        Equal(TRUE, keyFound);

        key := 'key2';
        keyFound := deserializer.TryParse( key, value);
        Equal(TRUE, keyFound);
    END_Method

    {Test}
    Method Public Test_FindKeysPosition_with_JSON_SimpleArray
        VAR
            JSON_Entry: STRING := '{ "simpleArray": [123, 456]}';

            len:DINT;
            keyStart : int;
            keyEnd : int;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'simpleArray';
        keyFound := deserializer.TryParse( key, value);
        Equal(TRUE, keyFound);
    END_Method

    //Comment in to test the private KeyIsInIndexSpan method
    // {Test}
    // Method Public Test_KeyIsInIndexSpan_FindsKey
    //     VAR
    //         len:DINT;
    //         keyStart : int := 0;
    //         keyEnd : int := 2;
    //         keyFound: BOOL;
    //     END_VAR

    //     key := 'key';
    //     len:= Strings.ToArray(str := key, arr := buffer);
    //     deserializer.SetBuffer(REF(buffer));

    //     keyFound := deserializer.KeyIsInIndexSpan(key, keyStart, keyEnd);
    //     Equal(TRUE, keyFound);

    //     key := 'not';
    //     keyFound := deserializer.KeyIsInIndexSpan(key, keyStart, keyEnd);
    //     Equal(FALSE, keyFound);
    // END_Method

END_CLASS

END_NAMESPACE
END_NAMESPACE