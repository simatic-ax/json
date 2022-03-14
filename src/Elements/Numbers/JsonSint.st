USING Simatic.Ax.Conversion;
    
NAMESPACE Simatic.Ax.Json
    CLASS FINAL JsonSInt EXTENDS BaseJsonNumber
        VAR PUBLIC
            Value : SINT;
        END_VAR
    
        METHOD PUBLIC OVERRIDE ToString : STRING
            ToString := THIS.ToStringHelper(Integer.ToString(value := Value));
        END_METHOD

    END_CLASS
END_NAMESPACE