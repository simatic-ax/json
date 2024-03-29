USING System.Strings;

NAMESPACE Simatic.Ax.Json
    /// The Object contains nested JsonElements
    {axcode:docs-v0:@simatic-ax/json:JsonObject.md}
    CLASS FINAL JsonObject EXTENDS AbstractJsonElement IMPLEMENTS IJsonContainerElement
        
        VAR PROTECTED
            _lastElement : IJsonElementMuteable;
            _firstElement : IJsonElementMuteable;
        END_VAR

        METHOD PUBLIC OVERRIDE ToString : STRING
            VAR_TEMP
                _str : STRING;
                _to : IJsonElementMuteable;
            END_VAR

            ;
            IF (_firstElement <> NULL) THEN
                _str := Concat(_str, '"', Key, '": ');
            END_IF;
        
            _str := Concat(_str, '{');
            // insert properties
            _to := _firstElement;
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

        METHOD PUBLIC OVERRIDE Serialize : BOOL
            VAR_INPUT
                doc : REF_TO JsonDocument;
            END_VAR
            VAR_TEMP
                _str : STRING;
                _to : IJsonElementMuteable;
            END_VAR
            
            Serialize := FALSE;

            IF (_firstElement <> NULL) THEN
                
                _str := Concat(_str, '"', Key, '": ');
                doc^.AddString(_str);
            END_IF;
        
            doc^.AddChar('{');
            
            // insert properties
            _to := _firstElement;
            WHILE _to <> NULL DO
                _to.Serialize(doc);
                _to := _to.GetNext();
                IF (_to <> NULL) THEN
                    doc^.AddString(', ');
                END_IF;
            END_WHILE;
            doc^.AddChar('}');
            Serialize := TRUE;
        END_METHOD
        
        METHOD PUBLIC OVERRIDE Reset
            VAR_TEMP
                _currentElement : IJsonElementMuteable;
                _nextElement : IJsonElementMuteable;
            END_VAR
            
            SUPER.Reset();
            
            _currentElement := _firstElement;
            WHILE _currentElement <> NULL DO
                _nextElement := _currentElement.GetNext();           
                _currentElement.Reset();      
                _currentElement := _nextElement;    
            END_WHILE;
            _lastElement := NULL;
            _firstElement := NULL;
        END_METHOD

        METHOD PUBLIC AddElement : IJsonContainerElement
            VAR_INPUT
                elem : IJsonElement;
            END_VAR
            VAR_TEMP
                _lastElem : IJsonElement;
            END_VAR
            IF (_firstElement = NULL) THEN
                _firstElement ?= elem;
                _lastElement := _firstElement;
            ELSE
                _lastElem ?= _lastElement;
                _lastElem.Insert(elem);
                _lastElement ?= elem;
            END_IF;
            AddElement := THIS;
            ;
        END_METHOD
    END_CLASS
END_NAMESPACE