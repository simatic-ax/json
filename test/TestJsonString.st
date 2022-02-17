USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonString
        
        VAR PROTECTED
            //e : JsonString := (value := 'value', key := 'test');
            e : JsonString := (value := 'my#1234,,,,', Key := 'test');
            expString, actString : STRING;
            cmpBuff : ARRAY[0..20] OF CHAR;
            doc : JsonDocument;
        END_VAR

        {Test}
        METHOD PUBLIC TestSerialize_s_test_true
            VAR_TEMP
                len : DINT;
                res : BOOL;
            END_VAR
            e.Serialize(REF(doc));

            expString := '"test": "my#1234,,,,"';
            len := Strings.ToArray(str := expString, arr := cmpBuff);
            res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD

    END_CLASS
END_NAMESPACE