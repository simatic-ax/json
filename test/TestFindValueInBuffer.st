USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS Test_FindValueInBuffer
    VAR protected
        doc : Deserializer;

        buffer : ARRAY[0..999] OF CHAR;
        key: STRING;
        value: STRING;
        testIndex1: INT;
        testIndex2: INT;
    END_VAR

    {Test}
    Method Public Test_GetValueFromIndex_GetValue        
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := '1234', arr := buffer);
        doc.SetBuffer(buffer);

        testIndex1:= 0; testIndex2 := 3;
        value:= doc.GetValueFromIndex(testIndex1, testIndex2);

        Equal('1234', value);
        
    END_Method

    {Test}
    Method Public Test_GetValueFromIndex_GetValue_withSpaces     
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := '    1234    ', arr := buffer);
        doc.SetBuffer(buffer);

        testIndex1:= 0; testIndex2 := 10;
        value:= doc.GetValueFromIndex(testIndex1, testIndex2);

        Equal('1234', value);
        
    END_Method

    {Test}
    Method Public Test_GetValueFromIndex_GetValue_withQuotationMarks      
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := ' "1234"      ', arr := buffer);
        doc.SetBuffer(buffer);

        testIndex1:= 0; testIndex2 := 10;
        value:= doc.GetValueFromIndex(testIndex1, testIndex2);

        Equal('1234', value);
        
    END_Method

    {Test}
    Method Public Test_FindValue_in_JSON_SimpleEntries
        VAR
            JSON_Entry: STRING := '{"key": "Element1", "key 2": "something", "key 3": 456, "Key 4":  1234 }';

            len:DINT;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := buffer);
        doc.SetBuffer(buffer); //TODO: ausbauen und ersetzen durch buffer in methode

        key := 'key';
        keyFound := doc.GetValue( REF(key), value);
        Equal(8, LengthOf(value));
        Equal('Element1', value);

        key := 'Key 4';
        keyFound := doc.GetValue( REF(key), value);
        Equal(4, LengthOf(value));
        Equal('1234', value);

        key := 'not a key';
        keyFound := doc.GetValue( REF(key), value);
        Equal('', value);
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
        doc.SetBuffer(buffer);

        key := 'key';
        keyFound := doc.GetValue( REF(key), nestedElement);
        Equal(true, keyFound);
        Equal('{"nested1" : "hello", "nested2" : 1234  }', nestedElement);

        len := Strings.ToArray(str := nestedElement, arr := buffer);
        doc.SetBuffer(buffer);
        key := 'nested1';
        keyFound := doc.GetValue( REF(key), value);
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
        doc.SetBuffer(buffer);

        key := 'key';
        keyFound := doc.GetValue( REF(key), nestedElement);
        Equal(true, keyFound);
        Equal('{"nested1" : "hello", "nested2" : 1234  }', nestedElement);

        len := Strings.ToArray(str := nestedElement, arr := buffer);
        doc.SetBuffer(buffer);
        key := 'nested1';
        keyFound := doc.GetValue( REF(key), value);
        Equal('hello', value);

    END_Method

END_CLASS

END_NAMESPACE