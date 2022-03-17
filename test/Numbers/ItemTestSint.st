USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonElementsSInt
        
        VAR PROTECTED
            e : JsonSInt := (Value := SINT#127, Key := 'test');
            e2 : JsonSInt := (Value := SINT#-128, Key := 'second_key');
            s_test_max : STRING := '"test": 127';
            s_test_min : STRING := '"second_key": -128';
            cmpBuff : ARRAY[0..20] OF CHAR;
            doc : JsonDocument;
        END_VAR

        {Test}
        METHOD PUBLIC Test_Tostring_with_max_expect_test_max
            VAR_TEMP
                _str : STRING;
            END_VAR
            _str := e.ToString();
            Equal(expected := _str, actual := s_test_max);   
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Tostring_with_min_expect_test_min
            Equal(expected := e2.ToString(), actual := s_test_min);  
        END_METHOD

        {Test}
        METHOD PUBLIC TestSerialize_s_test_max
            VAR_TEMP
                len : DINT;
                res : BOOL;
            END_VAR
            e.Serialize(REF(doc));

            len := Strings.ToArray(str := s_test_max, arr := cmpBuff);
            res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD

        {Test}
        METHOD PUBLIC TestSerialize_s_test_min
            VAR_TEMP
                len : DINT;
                res : BOOL;
            END_VAR
            
            e2.Serialize(REF(doc));
            len := Strings.ToArray(str := s_test_min, arr := cmpBuff);
            res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD
    END_CLASS
END_NAMESPACE