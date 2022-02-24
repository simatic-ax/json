USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonString EXTENDS AbstractJsonElement
        VAR PUBLIC
            Value : STRING;
        END_VAR
        VAR PROTECTED
            
        END_VAR
    
        METHOD PUBLIC OVERRIDE ToString : STRING
            VAR_TEMP
                _S : STRING;
            END_VAR
            _s := value;
            ToString := THIS.ToStringHelper(valueAsString := _s);
        END_METHOD

        METHOD PUBLIC OVERRIDE Serialize : BOOL
            VAR_INPUT
                doc : REF_TO JsonDocument;
            END_VAR
            VAR_TEMP
                _s : STRING;
            END_VAR
            _s := THIS.ToString();
            THIS.SerializeHelper(doc, _s);
            // THIS.SerializeHelper(doc, THIS.ToString());
            Serialize := FALSE;
        END_METHOD
    END_CLASS
END_NAMESPACE