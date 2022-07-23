USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonObject
        
        VAR PROTECTED
            e : JsonDInt := (Value := 999, Key := 'test');
            e2 : JsonDInt := (Value := -999, Key := 'second_key');
            e3 : JsonDInt := (Value := 1, Key := '3rd');
            o : JsonObject := (Key := 'Name');
            doc : JsonDocument;
            cmpBuff : ARRAY[0..399] OF CHAR;
            len : DINT;
        END_VAR

        {Test}
        METHOD PUBLIC Test_Empty_object_ToString_Expect_empty_object
            VAR_TEMP
                _expStr : STRING;
                _actStr : STRING;
            END_VAR

            // {}
            _expStr := '{}';
            _actStr := o.ToString();
            Equal(expected := _actStr, actual := _expStr);          
        END_METHOD
        
        {Test}
        METHOD PUBLIC Test_Object_with_one_element
            VAR_TEMP
                _expStr : STRING;
                _actStr : STRING;
            END_VAR
            o.AddElement(e);
            _expStr := '"Name": {"test": 999}';
            _actStr := o.ToString();
            Equal(expected := _actStr, actual := _expStr);                 
        END_METHOD
   
        {Test}
        METHOD PUBLIC Test_Object_with_three_elements
            VAR_TEMP
                _expStr : STRING;
                _actStr : STRING;
                _i, _j : INT;
            END_VAR
            o.AddElement(e);
            o.AddElement(e2);
            o.AddElement(e3);
            _expStr := '"Name": {"test": 999, "second_key": -999, "3rd": 1}';
            _expStr := StartOf(_expStr, 5);
            
            _i := LengthOf(_expStr);

           
            
            _actStr := StartOf(o.ToString(), LengthOf(_expStr));
            _j := LengthOf(_actStr);
            Equal(expected := _actStr, actual := _expStr);            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_Serialize_Object_with_three_elements
            VAR_TEMP
                _expStr : STRING;
                _actStr : STRING;
                _i, _j : INT;
                _res : BOOL;
            END_VAR
            THIS.Test_Object_with_three_elements();
            _expStr := '"Name": {"test": 999, "second_key": -999, "3rd": 1}';

            
            o.Serialize(REF(doc));

            len := Strings.ToArray.OfCharCount(str := _expStr, arr := cmpBuff);
            _res := CompareArray(first := doc.buffer, scnd := cmpBuff, count := TO_INT(len));
            Equal(expected := TRUE, actual := _res);
        END_METHOD

    END_CLASS
END_NAMESPACE