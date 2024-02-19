USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;

NAMESPACE Document

    {TestFixture}
    CLASS TestResetFlatDocument
        VAR PROTECTED
            e1 : JsonDInt := (Value := 999, Key := 'e1');
            e2 : JsonBoolean := (Key := 'e2', Value := TRUE);
            e3 : JsonString := (Key := 'e3', Value := 'MyString');
            o1 : JSonObject := (Key := 'o1');
            oi1 : JsonSInt := (Key := 'oi1', Value := SINT#1);
            oi2 : JsonSInt := (Key := 'oi2', Value := SINT#1);
            e4 : JsonLInt := (Key := 'e4', Value := LINT#1);
            doc : JsonDocument;
            cmpBuff : ARRAY[0..399] OF CHAR;
            cmpBuffEmpty : ARRAY[0..399] OF CHAR;
            len : DINT;
        END_VAR

        {Test}
        METHOD PUBLIC Reset_flat_document_removes_all_next_elements_from_the_json_objects
            VAR_TEMP
                _to : IJsonElementMuteable;
                _elem : IJsonElement;
            END_VAR
            doc.AddElement(e1);
            doc.AddElement(e2);
            doc.AddElement(e3);
            doc.AddElement(o1);
            doc.AddElement(e4);
            o1.AddElement(oi1);
            o1.AddElement(oi2);
            doc.Reset();
            Equal(expected := FALSE, actual := e1.HasNext());
            Equal(expected := FALSE, actual := e2.HasNext());
            Equal(expected := FALSE, actual := e3.HasNext());
            Equal(expected := FALSE, actual := e4.HasNext());
            Equal(expected := FALSE, actual := o1.HasNext());
            Equal(expected := FALSE, actual := oi1.HasNext());
            Equal(expected := FALSE, actual := oi2.HasNext());
            Equal(expected := TRUE, actual := doc.GetRootElement() = NULL);
            Equal(expected := DINT#0, actual := doc.GetLength());
        END_METHOD
    END_CLASS

END_NAMESPACE
