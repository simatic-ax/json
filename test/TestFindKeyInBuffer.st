USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS Test_FindKeyInBuffer
    VAR protected
        doc : JsonDocument;
        key: STRING := 'key';
        testString : STRING := 'works!';
        buffer : ARRAY[0..999] OF CHAR;        
    END_VAR

    {Test}
    Method Public Test_FindAKeyPosition_in_JSON_OneEntry
        VAR
            JSON_Entry: STRING := '{"Key1": "Element1"}';

            len:DINT;
            keyStart : int;
            keyEnd : int;
            keysFound: int;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := doc.buffer);

        keysFound := doc.FindKey(keyStart, keyEnd);

        //index is 0 based, not 1 based!
        Equal(2, keyStart);
        Equal(5, keyEnd);
        Equal(keysFound, 1);
    END_Method

    {Test}
    Method Public Test_FindKeysPosition_in_JSON_2Entries
        VAR
            JSON_Entry: STRING := '{"Key1": "Element1","Key2": 1234}';

            len:DINT;
            keyStart : int;
            keyEnd : int;
            keysFound: int;
        END_VAR

        len:= Strings.ToArray(str := JSON_Entry, arr := doc.buffer);

        keysFound := doc.FindKey(keyStart, keyEnd);

        //index is 0 based, not 1 based!
        Equal(21, keyStart);
        Equal(24, keyEnd);
        Equal(keysFound, 2);
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

        len:= Strings.ToArray(str := key, arr := doc.buffer);

        keyFound := doc.KeyIsInIndexSpan(REF(key), keyStart, keyEnd);
        Equal(TRUE, keyFound);

        key := 'not';
        keyFound := doc.KeyIsInIndexSpan(REF(key), keyStart, keyEnd);
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