USING AxUnit.Assert;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonObject
        
        VAR PROTECTED
            e : Properties.DoubleInt := (value := 999, key := 'test');
            e2 : Properties.DoubleInt := (value := -999, key := 'second_key');
            e3 : Properties.DoubleInt := (value := 1, key := '3rd');
            o, o2 : JsonObject;
        END_VAR

        {Test}
        METHOD PUBLIC Test_Empty_object_ToString_Expect_empty_object
            // {}
            Equal(expected := o.ToString(), actual := '{}');            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_with_one_element_ToString_Expect_correct_string
            // {"test": "999"}
            o.AddObject(e);
            Equal(expected := o.ToString(), actual := '{"test": 999}');            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_in_object_expect_nested_object
            // Expect: {{}}
            o.AddObject(o2);
            Equal(expected := o.ToString(), actual := '{{}}');            
        END_METHOD
    
        
        {Test}
        METHOD PUBLIC Test_object_in_object_with_property_expect_nested_object
            // Expect: {{"test": "999"}}
            o.AddObject(o2);
            o2.AddObject(e);
            Equal(expected := o.ToString(), actual := '{{"test": 999}}');            
        END_METHOD



        {Test}
        METHOD PUBLIC Test_object_with_two_property_expect_object
            // Expect: {"test": "999", "second_key": "-999"}
            ;
            o.AddObject(e);
            o.AddObject(e2);
            Equal(expected := o.ToString(), actual := '{"test": 999, "second_key": -999}');            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_with_three_property_expect_object
            // Expect: {"test": "999", "second_key": "-999", "3rd": "1"}
            ;
            o.AddObject(e);
            o.AddObject(e2);
            o.AddObject(e3);
            Equal(expected := o.ToString(), actual := '{"test": 999, "second_key": -999, "3rd": 1}');
        END_METHOD

        {Test}
        METHOD PUBLIC CreateTwoObjects_and_expect_correct_values
            // Expect: {"test": "999", "second_key": "-999"}
            // Expect: {"3rd": "1"}
            VAR_TEMP
                _str : STRING;
                _expected : STRING;
            END_VAR

            o.AddObject(e);
            o.AddObject(e2);
            Equal(expected := o.ToString(), actual := '{"test": 999, "second_key": -999}');    
            ;
            o2.AddObject(e3);
            Equal(expected := o2.ToString(), actual := '{"3rd": 1}');            
            
            // Expect: {"3rd": "1", NestedObject: {"3rd": "1", {"test": "999", "second_key": "-999"}}
            o.key := 'NestedObject';
            o2.AddObject(o);
            _str := o2.ToString();            
            //            0        1         2         3         4         5         6         7
            //            1234567890123456789012345678901234567890123456789012345678901234567890
            //_expected := '{"3rd": "1", "NestedObject": {"test';
            _expected := '{"3rd": 1, "NestedObject": {"test": 999, "second_key": -999}}';
           // _str := StartOf(_str, LengthOf(_expected));
            Equal(expected := _expected, actual := _str);
          
        END_METHOD
    END_CLASS
END_NAMESPACE