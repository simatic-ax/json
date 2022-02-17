USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;
NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestJsonLongDocument
        
        VAR PROTECTED
            e1 : JsonInt := (Key := 'elem1', Value := 0);
            e2 : JsonLongInt := (Key := 'elem2', Value := 1);
            e3 : JsonDoubleInt := (Key := 'elem3', Value := 2);
            doc :JsonDocument;
        END_VAR
        
        METHOD PUBLIC MyMethod
            doc.AddElement(e1);
            doc.AddElement(e2);
            doc.AddElement(e3);
            doc.Serialize(doc.buffer); //--> {elem1: 0, elem2: 1, elem3: 2}\n
            // nice to have --> doc.Deserialize('{elem1: 99, elem2: 100, elem3: 111}\n')
        END_METHOD

    END_CLASS

END_NAMESPACE