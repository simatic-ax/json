USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;

NAMESPACE Simatic.Ax.Json
    CLASS FINAL JsonInt EXTENDS BaseJsonNumber
        VAR PUBLIC
            Value : INT;
        END_VAR
    
        METHOD PUBLIC OVERRIDE ToString : STRING
            ToString := THIS.ToStringHelper(Integer.ToString(value := Value));
        END_METHOD

    END_CLASS
END_NAMESPACE