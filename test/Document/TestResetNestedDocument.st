// ToDo -> tests with exit code 255
USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;

NAMESPACE Document

    {TestFixture}
    CLASS TestResetNestedDocument
        VAR PUBLIC
            doc : JsonDocument;
            cmpBuff : ARRAY[0..20] OF CHAR;
            str : STRING;
            s : STRING;
            myBoolean : JsonBoolean := (Value := TRUE, Key := 'myBoolean');
            myInt : JsonInt := (Value := 1234, Key := 'myInt');
            myDint : JsonDInt := (Value := DINT#12345678, Key := 'myDint');
            myString : JsonString := (Value := 'this is my string', Key := 'myString');
            myObject : JsonObject := (Key := 'myObject');
            buffer : ARRAY[0..200] OF CHAR;
            // Stateless
            docStateLess : JsonDocument;
            cmpBuffStateLess : ARRAY[0..20] OF CHAR;
            strStateLess : STRING;
            sStateLess : STRING;
            myBooleanStateLess : JsonBoolean := (Value := TRUE, Key := 'myBoolean');
            myIntStateLess : JsonInt := (Value := 1234, Key := 'myInt');
            myDintStateLess : JsonDInt := (Value := DINT#12345678, Key := 'myDint');
            myStringStateLess : JsonString := (Value := 'this is my string', Key := 'myString');
            myObjectStateLess : JsonObject := (Key := 'myObject');
            bufferStateLess : ARRAY[0..200] OF CHAR;
        END_VAR

        {TestSetup}
        METHOD PUBLIC TestSetup
            doc := docStateLess;
            cmpBuff := cmpBuffStateLess;
            str := strStateLess;
            s := sStateLess;
            myBoolean := myBooleanStateLess;
            myInt := myIntStateLess;
            myDint := myDintStateLess;
            myString := myStringStateLess;
            myObject := myObjectStateLess;
            buffer := bufferStateLess;
        END_METHOD

        {Test}
        METHOD PUBLIC Serialize_BOOLEAN
            doc.buffer := REF(buffer);
            doc.AddElement(myBoolean);
            doc.Serialize();
            str := Arrays.ToString(buffer, 0, 18);
            Equal(expected := '{"myBoolean": true}', actual := str);
        END_METHOD

        {Test}
        METHOD PUBLIC Serialize_INT
            doc.buffer := REF(buffer);
            doc.AddElement(myInt);
            doc.Serialize();
            str := Arrays.ToString(buffer, 0, 14);
            Equal(expected := '{"myInt": 1234}', actual := str);
        END_METHOD

        {Test}
        METHOD PUBLIC Serialize_DINT
            doc.buffer := REF(buffer);
            doc.AddElement(myDint);
            doc.Serialize();
            str := Arrays.ToString(buffer, 0, 19);
            Equal(expected := '{"myDint": 12345678}', actual := str);
        END_METHOD

        {Test}
        METHOD PUBLIC Serialize_STRING
            doc.buffer := REF(buffer);
            doc.AddElement(myString);
            doc.Serialize();
            str := Arrays.ToString(buffer, 0, 32);
            Equal(expected := '{"myString": "this is my string"}', actual := str);
        END_METHOD

        {Test}
        METHOD PUBLIC Serialize_INT_DINT
            doc.buffer := REF(buffer);
            doc.AddElement(myInt);
            doc.AddElement(myDint);
            doc.Serialize();
            str := Arrays.ToString(buffer, 0, 34);
            Equal(expected := '{"myInt": 1234, "myDint": 12345678}', actual := str);
        END_METHOD

        {Test}
        METHOD PUBLIC Reset_nested_document_and_get_correct_result_after_adding_elements_again
            myObject.AddElement(myInt);
            myObject.AddElement(myDint);
            doc.AddElement(myBoolean);
            doc.AddElement(myObject);
            doc.buffer := REF(buffer);
            doc.Serialize();
            str := Arrays.ToString(buffer, 0, 67);
            Equal(expected := '{"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}', actual := str);
            // Reset document
            doc.Reset();
            // Create new document
            myObject.AddElement(myInt);
            myObject.AddElement(myDint);
            doc.AddElement(myBoolean);
            doc.AddElement(myObject);
            doc.Serialize();
            str := Arrays.ToString(buffer, 0, 67);
            Equal(expected := '{"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}', actual := str);
        END_METHOD
    END_CLASS

END_NAMESPACE
