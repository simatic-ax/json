USING Simatic.Ax.Conversion;
    
NAMESPACE Simatic.Ax.Json
    CLASS JsonDInt EXTENDS BaseJsonNumber
        VAR PUBLIC
            Value : DINT;
        END_VAR
    
        METHOD PUBLIC OVERRIDE ToString : STRING
            ToString := THIS.ToStringHelper(Integer.ToString(value := Value));
        END_METHOD

    END_CLASS
END_NAMESPACE