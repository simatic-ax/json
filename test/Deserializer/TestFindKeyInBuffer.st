USING Simatic.Ax.Conversion; // TODO Fix AxUnit Error
USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Json;

NAMESPACE Deserializer

    NAMESPACE FindKeys

        {TestFixture}
        CLASS Test_FindKeyInBuffer
            VAR PROTECTED
                deserializer : Deserializer;
                buffer : ARRAY[0..999] OF CHAR;
                key : STRING;
                value : STRING;
                testIndex1 : INT;
                testIndex2 : INT;
            END_VAR

            {Test}
            METHOD PUBLIC Test_FindKeysPosition_in_JSON_SimpleEntries
                VAR
                    JSON_Entry : STRING := '{"key ": " Elem ent1", "Hello": "something", "Nothing": 456, "Key 2": 1234 }';
                    len : DINT;
                    keyStart : INT;
                    keyEnd : INT;
                    keyFound : BOOL;
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'key ';
                keyFound := deserializer.TryParse(key, value);
                Equal(FALSE, keyFound);
                key := 'Key 2';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
                key := 'not a key';
                keyFound := deserializer.TryParse(key, value);
                Equal(FALSE, keyFound);
            END_METHOD

            {Test}
            METHOD PUBLIC Test_FindKeysPosition_in_JSON_Single_Nested_Entry
                VAR
                    JSON_Entry : STRING := '{"nested": {"nested1" : "hello", "nested2" : 1234  }}';
                    len : DINT;
                    keyStart : INT;
                    keyEnd : INT;
                    keyFound : BOOL;
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'nested';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
            END_METHOD

            {Test}
            METHOD PUBLIC Test_FindKeysPosition_with_JSON_Nested_Entry
                VAR
                    JSON_Entry : STRING := '{"key ": " Elem ent1", "nested": {"nested1" : "hello", "nested2" : 1234  }, "key2": " Elem ent1"}';
                    len : DINT;
                    keyStart : INT;
                    keyEnd : INT;
                    keyFound : BOOL;
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'key ';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
                key := 'nested';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
                key := 'key2';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
            END_METHOD

            {Test}
            METHOD PUBLIC Test_FindKeysPosition_with_JSON_SimpleArray
                VAR
                    JSON_Entry : STRING := '{ "simpleArray": [123, 456]}';
                    len : DINT;
                    keyStart : INT;
                    keyEnd : INT;
                    keyFound : BOOL;
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'simpleArray';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
            END_METHOD
            //Comment in to test the private KeyIsInIndexSpan method

        //     {Test}
        //     METHOD PUBLIC Test_KeyIsInIndexSpan_FindsKey
        //         VAR
        //             len : DINT;
        //             keyStart : INT := 0;
        //             keyEnd : INT := 2;
        //             keyFound : BOOL;
        //         END_VAR
        //         key := 'key';
        //         len := Strings.ToArray.OfCharCount(str := key, arr := buffer);
        //         deserializer.buffer := (REF(buffer));
        //         keyFound := deserializer.KeyIsInIndexSpan(key, keyStart, keyEnd);
        //         Equal(TRUE, keyFound);
        //         key := 'not';
        //         keyFound := deserializer.KeyIsInIndexSpan(key, keyStart, keyEnd);
        //         Equal(FALSE, keyFound);
        //     END_METHOD
        END_CLASS

    END_NAMESPACE

END_NAMESPACE
