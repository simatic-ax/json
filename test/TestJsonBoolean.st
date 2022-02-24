USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonBoolean
        
        VAR PROTECTED
            e : JsonBoolean := (Value := true, Key := 'test');
            e2 : JsonBoolean := (Value := false, Key := 'second_key');
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

            expString := '"test": true';
            len := Strings.ToArray(str := expString, arr := cmpBuff);
            res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD

        {Test}
        METHOD PUBLIC TestSerialize_s_test_minus_false
            VAR_TEMP
                len : DINT;
                res : BOOL;
            END_VAR
            
            e2.Serialize(REF(doc));
            expString := '"second_key": false';
            len := Strings.ToArray(str := expString, arr := cmpBuff);
            res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD
    END_CLASS
END_NAMESPACE