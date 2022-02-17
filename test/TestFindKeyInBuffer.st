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

        JSON_1Entry: STRING := '{"Key1": "Element1"}';
        JSON_2Entries: STRING := '{"Key1": "Element1","Key2": 1234}';
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
            keyStart : int;
            keyEnd : int;
        END_VAR

        THIS.ConvertStringToCharArray(JSON_1Entry);
        doc.buffer := buffer;
        doc.FindKeys(keyStart, keyEnd);

        Equal(2, keyStart);
        Equal(5, keyEnd);
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