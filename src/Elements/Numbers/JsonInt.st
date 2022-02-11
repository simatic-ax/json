USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;

NAMESPACE Simatic.Ax.Json
    CLASS JsonInt EXTENDS JsonNumber
        VAR PUBLIC
            value : INT;
        END_VAR
    
        METHOD PUBLIC OVERRIDE ToString : STRING
            ToString := THIS.ToStringHelper(Integer.ToString(value := value));
        END_METHOD

        METHOD PUBLIC OVERRIDE Serialize : BOOL
            VAR_INPUT
                doc : REF_TO JsonDocument;
            END_VAR
            THIS.SerializeHelper(doc, THIS.ToString());
            Serialize := FALSE;
        END_METHOD

    END_CLASS
END_NAMESPACE