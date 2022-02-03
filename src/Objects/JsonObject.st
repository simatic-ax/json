USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS JsonObject IMPLEMENTS IJsonObject
        VAR PUBLIC
            key : STRING := '';
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
                _lastObject.AddObject(obj);
                _lastObject := obj;
            END_IF;
        END_METHOD

        METHOD PUBLIC ToString : STRING
            VAR_TEMP
                _str : STRING;
                _to : IJsonObject;
            END_VAR

            IF (key <> '') THEN
                _str := Concat(_str, '"', key, '": ');
            END_IF;
        
            _str := Concat(_str, '{');
            // insert properties
            _to := _firstObject;
            WHILE _to <> NULL DO
                _str := Concat(_str, _to.ToString());
                _to := _to.GetNext();
                IF (_to <> NULL) THEN
                    _str := Concat(_str, ', ');
                END_IF;
            END_WHILE;
            _str := Concat(_str, '}');
            ToString := _str;
        END_METHOD

        METHOD PUBLIC Serialize : BOOL
            VAR_INPUT
                t : ARRAY [*] OF BYTE;
            END_VAR

            ;
        END_METHOD
    
        METHOD PUBLIC GetNext : IJsonObject
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE