USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonObject IMPLEMENTS IJsonObject
        VAR PUBLIC
            
        END_VAR
        VAR PROTECTED
            _firstObject : IJsonObject;
            _lastObject : IJsonObject;
        END_VAR
    
        METHOD PUBLIC AddObject
            VAR_INPUT
                obj : IJsonObject;
            END_VAR
            IF (_firstObject = NULL) THEN
                _firstObject := obj;
                _lastObject := obj;
            ELSE
                _lastObject := obj;
            END_IF;
        END_METHOD

        METHOD PUBLIC ToString : STRING
            VAR_TEMP
                _str : STRING;
            END_VAR
            _str := '{';
            // insert properties
            IF (_firstObject <> NULL) THEN
                Concat(_str, _firstObject.ToString());
            END_IF;
            _str := Concat(_str, '}');
            ToString := _str;
        END_METHOD

        METHOD PUBLIC Serialize : BOOL
            VAR_INPUT
                t : ARRAY [*] OF BYTE;
            END_VAR

            ;
        END_METHOD
    END_CLASS
END_NAMESPACE