NAMESPACE Simatic.Ax.Json
    INTERFACE IJsonElement
        METHOD ToString : STRING
        END_METHOD
        
        METHOD Serialize : BOOL
            VAR_INPUT
                t : Array[*] OF BYTE;
            END_VAR
        END_METHOD
    END_INTERFACE
END_NAMESPACE