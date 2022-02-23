USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer
NAMESPACE GetValues

{TestFixture}
CLASS Test_Deserializer_GetValues_NestedElements
    VAR protected
        deserializer : Deserializer;

        buffer : ARRAY[0..999] OF CHAR;
        key: STRING;
        value: STRING;
    END_VAR

    {Test}
    Method Public Test_FindValue_in_JSON_NestedArray
        VAR
            JSON_Entry: STRING := '{ "key1": 1234,"arraykey": [{"nestedkey1": 1234, "nestedkey2": 456}, {"nestedkey3": 1234, "nestedkey4": 456}], "key2": 456}';

            len:DINT;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer)); //TODO: ausbauen und ersetzen durch buffer in methode

        key := 'arraykey';
        keyFound := deserializer.GetValue( REF(key), value);
        Equal('[{"nestedkey1": 1234, "nestedkey2": 456}, {"nestedkey3": 1234, "nestedkey4": 456}]', value);
    END_Method

    {Test}
    Method Public Test_FindValue_NestedElement_in_JSON_SimpleEntries
        VAR
            JSON_Entry: STRING := '{"key": {"nested1" : "hello", "nested2" : 1234  } }';
            len:DINT;
            keyFound: BOOL;
            nestedElement: STRING;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'key';
        keyFound := deserializer.GetValue( REF(key), nestedElement);
        Equal(true, keyFound);
        Equal('{"nested1" : "hello", "nested2" : 1234  }', nestedElement);

        len := Strings.ToArray(str := nestedElement, arr := buffer);
        //deserializer.SetBuffer(REF(buffer));
        key := 'nested1';
        keyFound := deserializer.GetValue( REF(key), value);
        Equal('hello', value);

    END_Method

    {Test}
    Method Public Test_FindValue_NestedElement_in_JSON_MoreEntries
        VAR
            JSON_Entry: STRING := '{"anotherkey": 123, "key": {"nested1" : "hello", "nested2" : 1234  }, "differentKey": 12 }';
            len:DINT;
            keyFound: BOOL;
            nestedElement: STRING;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'key';
        keyFound := deserializer.GetValue( REF(key), nestedElement);
        Equal(true, keyFound);
        Equal('{"nested1" : "hello", "nested2" : 1234  }', nestedElement);

        len := Strings.ToArray(str := nestedElement, arr := buffer);
        //deserializer.SetBuffer(REF(buffer));
        key := 'nested1';
        keyFound := deserializer.GetValue( REF(key), value);
        Equal('hello', value);

    END_Method

    {Test}
    Method Public Test_FindValue_NestedElement_in_JSON_ArrayInNested
        VAR
            JSON_Entry: STRING := '{"anotherkey": 123, "key": {"nested1" : ["hello", "123"], "nested2" : 1234  }, "differentKey": 12 }';
            len:DINT;
            keyFound: BOOL;
            nestedElement: STRING;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        deserializer.SetBuffer(REF(buffer));

        key := 'key';
        keyFound := deserializer.GetValue( REF(key), nestedElement);
        Equal(true, keyFound);
        Equal('{"nested1" : ["hello", "123"], "nested2" : 1234  }', nestedElement);

        len := Strings.ToArray(str := nestedElement, arr := buffer);
        //deserializer.SetBuffer(REF(buffer));
        key := 'nested1';
        keyFound := deserializer.GetValue( REF(key), value);
        Equal('["hello", "123"]', value);

    END_Method


END_CLASS

END_NAMESPACE
END_NAMESPACE