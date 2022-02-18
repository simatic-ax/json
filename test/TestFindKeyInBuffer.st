USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS Test_FindKeyInBuffer
    VAR protected
        doc : JsonDocument;

        key: STRING;
        value: STRING;
        testIndex1: INT;
        testIndex2: INT;
    END_VAR

    {Test}
    Method Public Test_FindKeysPosition_in_JSON_SimpleEntries
        VAR
            JSON_Entry: STRING := '{"key": "Element1", "Hello": "something", "Nothing": 456, "Key 2": 1234, }';

            len:DINT;
            keyStart : int;
            keyEnd : int;
            keyFound: BOOL;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := doc.buffer);

        key := 'key';
        keyFound := doc.GetValue(REF(key), value);
        Equal(TRUE, keyFound);

        key := 'Key 2';
        keyFound := doc.GetValue(REF(key), value);
        Equal(TRUE, keyFound);

        key := 'not a key';
        keyFound := doc.GetValue(REF(key), value);
        Equal(FALSE, keyFound);
    END_Method

    {Test}
    Method Public Test_KeyIsInIndexSpan_FindsKey
        VAR
            len:DINT;
            keyStart : int := 0;
            keyEnd : int := 2;
            keyFound: BOOL;
        END_VAR

        key := 'key';
        len:= Strings.ToArray(str := key, arr := doc.buffer);

        keyFound := doc.KeyIsInIndexSpan(REF(key), keyStart, keyEnd);
        Equal(TRUE, keyFound);

        key := 'not';
        keyFound := doc.KeyIsInIndexSpan(REF(key), keyStart, keyEnd);
        Equal(FALSE, keyFound);
    END_Method

    {Test}
    Method Public Test_GetValueFromIndex_GetValue        
        VAR
            len: DINT;
        END_VAR

        len:= Strings.ToArray(str := '1234', arr := doc.buffer);

        testIndex1:= 0; testIndex2 := 3;
        value:= doc.GetValueFromIndex(REF(testIndex1), REF(testIndex2));

        Equal(4, LengthOf(value));
        Equal('1234', value);
        
    END_Method

    //start with FindKey, in a string, Get Back Key and value. Make TryParse out of it (provide key). Nachteil: json wird jedes mal durchsucht. Test: Stringlänge! (Refto string?)

END_CLASS

END_NAMESPACE