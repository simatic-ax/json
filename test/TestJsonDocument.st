USING AxUnit.Assert;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonDocument
        
        VAR PROTECTED
            e : JsonDoubleInt := (value := 999, key := 'test');
            e2 : JsonDoubleInt := (value := -999, key := 'second_key');
            e3 : JsonDoubleInt := (value := 1, key := '3rd');
            doc : JsonDocument;
            o2 : JsonObject := (key := 'Name');
        END_VAR

        {Test}
        METHOD PUBLIC Test_Empty_object_ToString_Expect_empty_object
            // {}
            Equal(expected := doc.ToString(), actual := '{}');            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_with_one_element_ToString_Expect_correct_string
            // {"test": "999"}
            doc.AddElement(e);
            Equal(expected := doc.ToString(), actual := '{"test": 999}');            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_in_object_expect_nested_object
            // Expect: {{}}
            doc.AddElement(o2);
            Equal(expected := doc.ToString(), actual := '{{}}');            
        END_METHOD
    
        
        {Test}
        METHOD PUBLIC Test_object_in_object_with_property_expect_nested_object
            VAR_TEMP
                _expStr : STRING;
                _actStr : STRING;
            END_VAR

            // Expect: {{"test": "999
            doc.AddElement(o2);
            o2.AddElement(e);
            _expStr := '{"Name": {"test": 999}}';
            _actStr := doc.ToString();
            Equal(expected := _actStr, actual := _expStr);                        
        END_METHOD



        {Test}
        METHOD PUBLIC Test_object_with_two_property_expect_object
            // Expect: {"test": "999", "second_key": "-999"}
            ;
            doc.AddElement(e);
            doc.AddElement(e2);
            Equal(expected := doc.ToString(), actual := '{"test": 999, "second_key": -999}');            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_with_three_property_expect_object
            // Expect: {"test": "999", "second_key": "-999", "3rd": "1"}
            doc.AddElement(e);
            doc.AddElement(e2);
            doc.AddElement(e3);
            Equal(expected := doc.ToString(), actual := '{"test": 999, "second_key": -999, "3rd": 1}');
        END_METHOD

        {Test}
        METHOD PUBLIC CreateTwoObjects_and_expect_correct_values
            // Expect: {"test": "999", "second_key": "-999"}
            // Expect: {"3rd": "1"}
            VAR_TEMP
                _expStr : STRING;
                _actStr : STRING;
            END_VAR

            doc.AddElement(e);
            doc.AddElement(e2);
            Equal(expected := doc.ToString(), actual := '{"test": 999, "second_key": -999}');    
            ;
            o2.AddElement(e3);
            _expStr := '"Name": {"3rd": 1}';
            _actStr := o2.ToString();
            Equal(expected := _actStr, actual := _expStr);      
            
            // Expect: {"3rd": "1", NestedObject: {"3rd": "1", {"test": "999", "second_key": "-999"}}
            o2.key := 'NestedObject';
            doc.AddElement(o2);
            _actStr := o2.ToString();            
            //            0        1         2         3         4         5         6         7
            //            1234567890123456789012345678901234567890123456789012345678901234567890
            //_expected := '{"3rd": "1", "NestedObject": {"test';
            _expStr := '{"3rd": 1, "NestedObject": {"test": 999, "second_key": -999}}';
            _actStr := o2.ToString();
           // _str := StartOf(_str, LengthOf(_expected));
            Equal(expected := _actStr , actual := _actStr);
          
        END_METHOD
    END_CLASS
END_NAMESPACE