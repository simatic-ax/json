USING Simatic.Ax.Conversion;
    
NAMESPACE Simatic.Ax.Json
    CLASS JsonLongInt EXTENDS JsonNumber
        VAR PUBLIC
            value : LINT;
        END_VAR
    
        METHOD PUBLIC OVERRIDE ToString : STRING
            ToString := THIS.ToStringHelper(Integer.ToString(value := value));
        END_METHOD
    END_CLASS
END_NAMESPACE