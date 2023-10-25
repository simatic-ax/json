NAMESPACE Simatic.Ax.Json
    INTERFACE INTERNAL IGetBufferIndizes
        METHOD Find : IPlcOpen
            VAR_INPUT
                buffer : REF_TO ARRAY[*] OF CHAR;
            END_VAR
        END_METHOD
        METHOD StartIndex : INT END_METHOD
        METHOD EndIndex : INT END_METHOD
    END_INTERFACE
END_NAMESPACE