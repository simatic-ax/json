USING AxUnit.Assert;

NAMESPACE Simatic.Ax.Json
    {TestFixture}
    CLASS TestNoElementsMustNotBeAddedTwice
        VAR PROTECTED
            e1 : JsonDInt := (Key := 'Element1', Value := 1);
            e2 : JsonDInt := (Key := 'Element2', Value := 1);
            doc : JsonDocument;
        END_VAR
        {Test}
        METHOD PUBLIC Add_e1_twice_returns_error
            VAR_TEMP
                result : IJsonContainerElement;
            END_VAR
            
            result := doc.AddElement(e1);
            result := doc.AddElement(e1);
            Equal(expected := true, actual := result = NULL);
            ;
        END_METHOD
    END_CLASS    
END_NAMESPACE
