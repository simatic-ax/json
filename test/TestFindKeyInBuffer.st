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
        buffer : ARRAY[1..999] OF CHAR;

        simple_JSON: STRING := '{"Key1": "Element1","Key2": 1234}';
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

        FOR Index := 1 TO stringlength DO
            buffer[index] := inputstring[index];
        END_FOR;

    END_METHOD

    {Test}
    METHOD PUBLIC Test_ConvertStringToCharArray
            THIS.ConvertStringToCharArray(testString);
            Equal('w', buffer[1]);
            Equal('o', buffer[2]);
            Equal('r', buffer[3]);
            Equal('k', buffer[4]);
            Equal('s', buffer[5]);
            Equal('!', buffer[6]);
    END_METHOD


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