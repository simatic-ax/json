USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS Test_FindKeyInBuffer
    VAR protected
        doc : JsonDocument;

        notAKey: STRING := 'not a key!';
        key1: STRING := 'key';
        key2: STRING := 'Key 2';
        
        value: STRING;
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

        keyFound := doc.GetValue(REF(key1));
        Equal(TRUE, keyFound);

        keyFound := doc.GetValue(REF(key2));
        Equal(TRUE, keyFound);

        keyFound := doc.GetValue(REF(notAKey));
        Equal(FALSE, keyFound);
    END_Method

    {Test}
    Method Public Test_KeyIsInIndexSpan_FindsKey
        VAR
            len:DINT;
            keyStart : int := 0;
            keyEnd : int := 2;
            keyFound: BOOL;

            test: bool := true;
        END_VAR

        len:= Strings.ToArray(str := key1, arr := doc.buffer);

        keyFound := doc.KeyIsInIndexSpan(REF(key1), keyStart, keyEnd);
        Equal(TRUE, keyFound);

        key1 := 'not';
        keyFound := doc.KeyIsInIndexSpan(REF(key1), keyStart, keyEnd);
        Equal(FALSE, keyFound);
    END_Method

    //start with FindKey, in a string, Get Back Key and value. Make TryParse out of it (provide key). Nachteil: json wird jedes mal durchsucht. Test: Stringlänge! (Refto string?)

END_CLASS



{Test}
FUNCTION GetACharInString
    VAR_TEMP
        e : STRING := 'hallo';
        c : CHAR;
    end_var
        c := e[1];
        Equal(c, 'h');
END_FUNCTION

END_NAMESPACE