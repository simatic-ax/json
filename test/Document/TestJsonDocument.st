USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;

NAMESPACE Document
    {TestFixture}
    CLASS TestJsonDocument
        
        VAR PROTECTED
            e : JsonDInt := (Value := 999, Key := 'test');
            e2 : JsonDInt := (Value := -999, Key := 'second_key');
            e3 : JsonDInt := (Value := 1, Key := '3rd');
            doc : JsonDocument;
            o2 : JsonObject := (Key := 'Name');
            
            iElem : IJsonElement;
            rElem : REF_TO JsonDInt;
            expArray : ARRAY[0..399] OF CHAR;
            expArrayCnt : DINT;
            expString : STRING;
            actString : STRING;
            result : BOOL;



        END_VAR

        {Test}
        METHOD PUBLIC Test_Empty_object_ToString_Expect_empty_object
           
            // expected string
            expString := '{}';

            actString :=  doc.ToString();
            Equal(expected := expString, actual := actString);       
            
            // Test Serialize
            expArrayCnt := Strings.ToArray(str := expString, arr := expArray);
            doc.Serialize(doc.buffer);
            result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            Equal(expected := TRUE, actual := result);
            
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_with_one_element_And_Call_Serialize_twice_Expectstill_correct_string
            // expected string
            expString := '{"test": 999}';

            doc.AddElement(e);
            actString := doc.ToString();
            Equal(expected := expString, actual := actString);           
            
            // Test Serialize
            expArrayCnt := Strings.ToArray(str := expString, arr := expArray);
            doc.Serialize(doc.buffer);
            doc.Serialize(doc.buffer);
            result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            Equal(expected := TRUE, actual := result);
        END_METHOD


        {Test}
        METHOD PUBLIC Test_object_with_one_element_ToString_Expect_correct_string
            // expected string
            expString := '{"test": 999}';

            doc.AddElement(e);
            actString := doc.ToString();
            Equal(expected := expString, actual := actString);           
            
            // Test Serialize
            expArrayCnt := Strings.ToArray(str := expString, arr := expArray);
            doc.Serialize(doc.buffer);
            result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            Equal(expected := TRUE, actual := result);
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_in_object_expect_nested_object
            // expected string
            expString := '{{}}';

            doc.AddElement(o2);
            Equal(expected := doc.ToString(), actual := expString);    
            
            // Test Serialize
            expArrayCnt := Strings.ToArray(str := expString, arr := expArray);
            doc.Serialize(doc.buffer);
            result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            Equal(expected := TRUE, actual := result);
        END_METHOD
    
        
        {Test}
        METHOD PUBLIC Test_object_in_object_with_property_expect_nested_object
            // expected string
            expString := '{"Name": {"test": 999}}';

            doc.AddElement(o2);
            o2.AddElement(e);

            actString := doc.ToString();
            Equal(expected := actString, actual := expString);   
            
            // Test Serialize
            expArrayCnt := Strings.ToArray(str := expString, arr := expArray);
            doc.Serialize(doc.buffer);
            result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            Equal(expected := TRUE, actual := result);
        END_METHOD



        {Test}
        METHOD PUBLIC Test_object_with_two_property_expect_object
            // expected string
            expString := '{"test": 999, "second_key": -999}';


            doc.AddElement(e);
            doc.AddElement(e2);
            Equal(expected := doc.ToString(), actual := expString);          
            
            // Test Serialize
            expArrayCnt := Strings.ToArray(str := expString, arr := expArray);
            doc.Serialize(doc.buffer);
            result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            Equal(expected := TRUE, actual := result);
        END_METHOD

        {Test}
        METHOD PUBLIC Test_object_with_three_property_expect_object
            // expected string
            expString := '{"test": 999, "second_key": -999, "3rd": 1}';
            
            doc.AddElement(e);
            doc.AddElement(e2);
            doc.AddElement(e3);
            Equal(expected := doc.ToString(), actual := expString);

            // Test Serialize
            expArrayCnt := Strings.ToArray(str := expString, arr := expArray);
            doc.Serialize(doc.buffer);
            result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            Equal(expected := TRUE, actual := result);
        END_METHOD

        {Test}
        METHOD PUBLIC CreateTwoObjects_and_expect_correct_values
            // expected string
            expString := '{"test": 999, "second_key": -999}';

            doc.AddElement(e);
            doc.AddElement(e2);
            Equal(expected := doc.ToString(), actual := expString);    
            
            
            // expected string
            expString := '"NestedObject": {"3rd": 1}';

            o2.Key := 'NestedObject';
            o2.AddElement(e3);
            actString := o2.ToString();
            Equal(expected := expString, actual := actString);      
            
            
            //            0        1         2         3         4         5         6         7
            //            1234567890123456789012345678901234567890123456789012345678901234567890
            expString := '{"test": 999, "second_key": -999, "NestedObject": {"3rd": 1}}';

            doc.AddElement(o2);
            actString := o2.ToString();            

            actString := doc.ToString();
            Equal(expected := expString , actual := actString);

            // // Test Serialize
            // expArrayCnt := Strings.ToArray(str := expString, arr := expArray);
            // doc.Serialize(doc.buffer);
            // result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            // Equal(expected := TRUE, actual := result);
        END_METHOD
    END_CLASS
END_NAMESPACE