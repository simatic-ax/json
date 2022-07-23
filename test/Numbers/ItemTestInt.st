USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonElementsInt
        
        VAR PROTECTED
            e : JsonInt := (Value := 999, Key := 'test');
            e2 : JsonInt := (Value := -999, Key := 'second_key');
            s_test_999 : STRING := '"test": 999';
            s_test_minus_999 : STRING := '"second_key": -999';
            cmpBuff : ARRAY[0..20] OF CHAR;
            doc : JsonDocument;
        END_VAR

        {Test}
        METHOD PUBLIC Test_Tostring_with_999_expect_test_999
            VAR_TEMP
                _str : STRING;
            END_VAR
            _str := e.ToString();
            Equal(expected := _str, actual := s_test_999);   
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Tostring_with_Minus_999_expect_test_Minus_999
            Equal(expected := e2.ToString(), actual := s_test_minus_999);  
        END_METHOD

        {Test}
        METHOD PUBLIC TestSerialize_s_test_999
            VAR_TEMP
                len : DINT;
                res : BOOL;
            END_VAR
            e.Serialize(REF(doc));

            len := Strings.ToArray.OfCharCount(str := s_test_999, arr := cmpBuff);
            res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD

        {Test}
        METHOD PUBLIC TestSerialize_s_test_minus_999
            VAR_TEMP
                len : DINT;
                res : BOOL;
            END_VAR
            
            e2.Serialize(REF(doc));
            len := Strings.ToArray.OfCharCount(str := s_test_minus_999, arr := cmpBuff);
            res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD
    END_CLASS
END_NAMESPACE