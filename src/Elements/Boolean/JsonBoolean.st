NAMESPACE Simatic.Ax.Json
    CLASS FINAL JsonBoolean EXTENDS BaseJsonNumber
        VAR PUBLIC
            Value : BOOL;
        END_VAR
        VAR PROTECTED
            
        END_VAR
    
        METHOD PUBLIC OVERRIDE ToString : STRING
            IF (Value) THEN
                ToString := THIS.ToStringHelper('true');
            ELSE
                ToString := THIS.ToStringHelper('false');
            END_IF;
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