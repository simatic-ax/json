USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonNumber EXTENDS AbstractJsonElement

        METHOD PROTECTED OVERRIDE ToStringHelper : STRING
            VAR_INPUT
                valueAsString : STRING;
            END_VAR
            VAR_TEMP
                _str : STRING;
            END_VAR
            _str := Concat('"', Key, '": ', valueAsString);
            ToStringHelper := _str;
        END_METHOD
    
        METHOD PUBLIC OVERRIDE ToString : STRING
            ;
        END_METHOD
    
        METHOD PUBLIC OVERRIDE Serialize : BOOL
            VAR_INPUT
                doc : REF_TO Simatic.Ax.Json.JsonDocument;
            END_VAR
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE