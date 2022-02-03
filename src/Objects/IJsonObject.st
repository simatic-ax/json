NAMESPACE Simatic.Ax.Json
    INTERFACE IJsonObject
        METHOD ToString : STRING
        END_METHOD
        
        METHOD Serialize : BOOL
            VAR_INPUT
                t : Array[*] OF BYTE;
            END_VAR
        END_METHOD

        METHOD AddObject
            VAR_INPUT
                obj : IJsonObject;
            END_VAR
        END_METHOD

        METHOD GetNext : IJsonObject
        END_METHOD
    END_INTERFACE    
END_NAMESPACE