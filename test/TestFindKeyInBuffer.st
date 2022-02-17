USING Simatic.Ax.Conversion;
USING AxUnit.Assert;
USING System.Strings;
using Simatic.Ax.Json;


NAMESPACE Deserializer

{TestFixture}
CLASS Test_FindKeyInBuffer
    VAR protected
        doc : JsonDocument;
        testString : STRING := 'works!';
        buffer : ARRAY[0..999] OF CHAR;        
    END_VAR

    METHOD PUBLIC ConvertStringToCharArray
        VAR_INPUT
            inputstring: string;
        end_var
        VAR_TEMP
            stringLength : int;
            index : Int;
        end_var

        stringLength := LengthOf(inputstring);

        FOR Index := 0 TO stringlength DO
            buffer[index] := inputstring[index + 1];
        END_FOR;

    END_METHOD

    {Test}
    METHOD PUBLIC Test_ConvertStringToCharArray
            THIS.ConvertStringToCharArray(testString);
            Equal('w', buffer[0]);
            Equal('o', buffer[1]);
            Equal('r', buffer[2]);
            Equal('k', buffer[3]);
            Equal('s', buffer[4]);
            Equal('!', buffer[5]);
    END_METHOD

    {Test}
    Method Public Test_FindAKeyPosition_in_SimpleJSON
        VAR
            JSON_1Entry: STRING := '{"Key1": "Element1"}';

            keyStart : int;
            keyEnd : int;
            keysFound: int;
        END_VAR

        THIS.ConvertStringToCharArray(JSON_1Entry);
        doc.buffer := buffer;
        keysFound := doc.FindKeys(keyStart, keyEnd);

        //index is 0 based, not 1 based!
        Equal(2, keyStart);
        Equal(5, keyEnd);
        Equal(keysFound, 1);
    END_Method

    {Test}
    Method Public Test_FindKeysPosition_in_SimpleJSON_2Entries
        VAR
            JSON_2Entries: STRING := '{"Key1": "Element1","Key2": 1234}';

            keyStart : int;
            keyEnd : int;
            keysFound: int;
        END_VAR

        THIS.ConvertStringToCharArray(JSON_2Entries);
        doc.buffer := buffer;
        keysFound := doc.FindKeys(keyStart, keyEnd);

        //index is 0 based, not 1 based!
        Equal(21, keyStart);
        Equal(24, keyEnd);
        Equal(keysFound, 2);
    END_Method


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