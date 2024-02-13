USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonElementsUSInt
        
        VAR PROTECTED
            e : JsonUSInt := (Value := USINT#255, Key := 'test');
            e2 : JsonUSInt := (Value := USINT#0, Key := 'second_key');
            s_test_max : STRING := '"test": 255';
            s_test_minus_min : STRING := '"second_key": 0';
            cmpBuff : ARRAY[0..20] OF CHAR;
            doc : JsonDocument;
            buffer : ARRAY[0..200] OF CHAR;
            bufferStateLess : ARRAY[0..200] OF CHAR;
        END_VAR

        {TestSetup}
        METHOD PUBLIC TestSetup
            doc.Reset();
            buffer := bufferStateLess;
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Tostring_with_999_expect_test_999
            VAR_TEMP
                _str : STRING;
            END_VAR
            _str := e.ToString();
            Equal(expected := _str, actual := s_test_max);   
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Tostring_with_Minus_999_expect_test_Minus_999
            Equal(expected := e2.ToString(), actual := s_test_minus_min);  
        END_METHOD

        {Test}
        METHOD PUBLIC TestSerialize_s_test_999
            VAR_TEMP
                len : DINT;
                res : BOOL;
            END_VAR
            doc.buffer := REF(buffer);
            e.Serialize(REF(doc));

            len := Strings.ToArray.OfCharCount(str := s_test_max, arr := cmpBuff);
            res := CompareArray(first := buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD

        {Test}
        METHOD PUBLIC TestSerialize_s_test_minus_999
            VAR_TEMP
                len : DINT;
                res : BOOL;
            END_VAR
            doc.buffer := REF(buffer);
            e2.Serialize(REF(doc));
            len := Strings.ToArray.OfCharCount(str := s_test_minus_min, arr := cmpBuff);
            res := CompareArray(first := buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := res);

        END_METHOD
    END_CLASS
END_NAMESPACE