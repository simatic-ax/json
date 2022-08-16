NAMESPACE Simatic.Ax.Json
    INTERFACE IJsonElementMuteable
        METHOD HasNext : BOOL
        END_METHOD

        METHOD GetNext : IJsonElementMuteable
        END_METHOD


        METHOD ToString : STRING
        END_METHOD
        
        METHOD Serialize : BOOL
            VAR_INPUT
                doc : REF_TO JsonDocument;
            END_VAR
        END_METHOD
        METHOD Reset
        END_METHOD
    END_INTERFACE
END_NAMESPACE