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
            
            oa : JsonObject := (Key := 'O1');
            ob : JsonObject := (Key := 'O3');
            oc : JsonObject := (Key := 'O5');
            ea : JsonDInt := (Key := 'ea', Value := 1);
            eb : JsonDInt := (Key := 'eb', Value := 2);
            ec : JsonDInt := (Key := 'ec', Value := 3);
            ed : JsonDInt := (Key := 'ed', Value := 4);
            
            ee : JsonString := (Key := 'ee', Value := 'ee');
            ef : JsonString := (Key := 'ef', Value := 'ef');
            eg : JsonString := (Key := 'eg', Value := 'eg');
            
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
            expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
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
            expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
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
            expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
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
            expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
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
            expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
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
            expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
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
            expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
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
            // expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
            // doc.Serialize(doc.buffer);
            // result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            // Equal(expected := TRUE, actual := result);
        END_METHOD

        {Test}
        METHOD PUBLIC Test_two_objects_with_two_nested_elements_in_each_object
            // expected string
            expString := '{"O1": {"ea": 1, "eb": 2}, "O3": {"ec": 3, "ed": 4}, "O5": {"ee": "ee", "ef": "ef", "eg": "eg"}}';
            
            doc.AddElement(oa).AddElement(ob).AddElement(oc);
            // doc.AddElement(ob);
            // doc.AddElement(oc);

            oa.AddElement(ea).AddElement(eb);
            
            ob.AddElement(ec).AddElement(ed);

            oc.AddElement(ee).AddElement(ef).AddElement(eg);
            
            
            // doc.AddElement(oa);
            Equal(expected := doc.ToString(), actual := expString);

            // Test Serialize
            expArrayCnt := Strings.ToArray.OfCharCount(str := expString, arr := expArray);
            doc.Serialize(doc.buffer);
            result := CompareArray(first := doc.buffer, scnd := expArray, count := TO_INT(expArrayCnt));
            Equal(expected := TRUE, actual := result);
    
        END_METHOD

        {Test}
        METHOD PUBLIC When_adding_elemens_by_building_pattern_the_correct_Json_will_be_Returned

            expString := '{"ea": 1, "eb": 2, "ec": 3}';
            doc.AddElement(ea).AddElement(eb).AddElement(ec);
            
            Equal(expected := doc.ToString(), actual := expString);

            ; // AxUnit.Assert.Equal(y, x)
        END_METHOD

    END_CLASS
END_NAMESPACE