USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Json;

NAMESPACE Deserializer

    NAMESPACE GetValues

        {TestFixture}
        CLASS Test_Deserializer_GetValues_NestedElements
            VAR PROTECTED
                deserializer : Deserializer;
                buffer : ARRAY[0..999] OF CHAR;
                key : STRING;
                value : STRING;
            END_VAR

            {Test}
            METHOD PUBLIC Test_FindValue_in_JSON_NestedArray
                VAR
                    JSON_Entry : STRING := '{ "key1": 1234,"arraykey": [{"nestedkey1": 1234, "nestedkey2": 456}, {"nestedkey3": 1234, "nestedkey4": 456}], "key2": 456}';
                    len : DINT;
                    keyFound : BOOL;
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'arraykey';
                keyFound := deserializer.TryParse(key, value);
                Equal('[{"nestedkey1": 1234, "nestedkey2": 456}, {"nestedkey3": 1234, "nestedkey4": 456}]', value);
            END_METHOD

            {Test}
            METHOD PUBLIC Test_FindValue_NestedElement_in_JSON_SimpleEntries
                VAR
                    JSON_Entry : STRING := '{"key": {"nested1" : "hello", "nested2" : 1234  } }';
                    len : DINT;
                    keyFound : BOOL;
                    keyArray : ARRAY[0..1] OF STRING := ['key', 'nested1'];
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'key';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
                Equal('{"nested1" : "hello", "nested2" : 1234  }', value);
                keyFound := deserializer.TryParse(keyArray, value);
                Equal('hello', value);
            END_METHOD

            {Test}
            METHOD PUBLIC Test_FindValue_NestedElement_in_JSON_MoreEntries
                VAR
                    JSON_Entry : STRING := '{"anotherkey": 123, "key": {"nested1" : "hello", "nested2" : 1234  }, "differentKey": 12 }';
                    len : DINT;
                    keyFound : BOOL;
                    keyArray : ARRAY[0..1] OF STRING := ['key', 'nested1'];
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'key';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
                Equal('{"nested1" : "hello", "nested2" : 1234  }', value);
                keyFound := deserializer.TryParse(keyArray, value);
                Equal('hello', value);
            END_METHOD

            {Test}
            METHOD PUBLIC Test_FindValue_NestedElement_in_JSON_NestedInNested
                VAR
                    JSON_Entry : STRING := '{"anotherkey": 123, "key": {"nested1" : "hello", "nestedkey": {"nInNested": "goodbye", "k": 1234}, "nested2" : 1234  }, "differentKey": 12 }';
                    len : DINT;
                    keyFound : BOOL;
                    keyArray : ARRAY[0..2] OF STRING := ['key', 'nestedkey', 'nInNested'];
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'key';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
                Equal('{"nested1" : "hello", "nestedkey": {"nInNested": "goodbye", "k": 1234}, "nested2" : 1234  }', value);
                keyFound := deserializer.TryParse(keyArray, value);
                Equal('goodbye', value);
            END_METHOD

            {Test}
            METHOD PUBLIC Test_FindValue_NestedElement_in_JSON_ArrayInNested
                VAR
                    JSON_Entry : STRING := '{"anotherkey": 123, "key": {"nested1" : ["hello", "123"], "nested2" : 1234  }, "differentKey": 12 }';
                    len : DINT;
                    keyFound : BOOL;
                    keyArray : ARRAY[0..1] OF STRING := ['key', 'nested1'];
                END_VAR
                len := Strings.ToArray.OfCharCount(str := JSON_Entry, arr := buffer);
                deserializer.buffer := REF(buffer);
                key := 'key';
                keyFound := deserializer.TryParse(key, value);
                Equal(TRUE, keyFound);
                Equal('{"nested1" : ["hello", "123"], "nested2" : 1234  }', value);
                keyFound := deserializer.TryParse(keyArray, value);
                Equal('["hello", "123"]', value);
            END_METHOD
        END_CLASS

    END_NAMESPACE

END_NAMESPACE
