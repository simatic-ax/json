USING AxUnit.Assert;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonObject
        
        VAR PROTECTED
            e : JsonDoubleInt := (value := 999, key := 'test');
            e2 : JsonDoubleInt := (value := -999, key := 'second_key');
            e3 : JsonDoubleInt := (value := 1, key := '3rd');
            o : JsonObject := (key := 'Name');
            doc : JsonDocument;
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
            END_VAR
            THIS.Test_Object_with_three_elements();
            _expStr := '"Name": {"test": 999, "second_key": -999, "3rd": 1}';
            _expStr := StartOf(_expStr, 5);
            
            _i := LengthOf(_expStr);

           
            
            _actStr := StartOf(o.ToString(), LengthOf(_expStr));
            _j := LengthOf(_actStr);
            Equal(expected := _actStr, actual := _expStr);            
        END_METHOD

    END_CLASS
END_NAMESPACE