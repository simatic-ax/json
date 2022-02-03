USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonNumber EXTENDS JsonProperty

        METHOD PROTECTED OVERRIDE ToStringHelper : STRING
            VAR_INPUT
                valueAsString : STRING;
            END_VAR
            VAR_TEMP
                _str : STRING;
            END_VAR
            _str := Concat('"', key, '": ', valueAsString);
            ToStringHelper := _str;
        END_METHOD
        
        METHOD PUBLIC OVERRIDE ToString : STRING
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE