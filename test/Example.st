USING Simatic.Ax.Json;
USING AxUnit.Assert;

NAMESPACE Simatic.Ax
    CLASS JsonExample
        VAR PUBLIC
            
        END_VAR
        VAR PROTECTED
            doc : JsonDocument;
            e1 : JsonDoubleInt := (Key := 'Element1', Value := 1);
            e2 : JsonDoubleInt := (Key := 'Element2', Value := 2);
            e3 : JsonDoubleInt := (Key := 'Element3', Value := 3);
            o1 : JsonObject := (Key := 'NestedObject');
            
        END_VAR
        
        METHOD PUBLIC Init;
            // Example String:
            // {"Element1": 1, {"Element2": 2, "Element3": 3}}            
            doc.AddElement(e1);
            doc.AddElement(o1);
            o1.AddElement(e2);
            o1.AddElement(e3);
        END_METHOD

        METHOD PUBLIC ToString : STRING
            ToString := doc.ToString();
        END_METHOD
    END_CLASS    
END_NAMESPACE

NAMESPACE Simatic.Ax
    {TestFixture}
    CLASS TestExample
        VAR PROTECTED
            _ex : JsonExample;
        END_VAR

        {Test}
        METHOD PUBLIC TestExample_and_check_returned_string
            VAR_TEMP
                _expStr : STRING;
                _actStr : STRING;
            END_VAR
            _ex.Init();
            _expStr := '{"Element1": 1, "NestedObject": {"Element2": 2, "Element3": 3}}';
            _actStr := _ex.ToString();
            Equal(expected := _actStr, actual := _expStr);       
        END_METHOD
    END_CLASS

END_NAMESPACE
