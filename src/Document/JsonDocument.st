USING System.Strings;

NAMESPACE Simatic.Ax.Json

    /// The JsonDocument contains the object model of the Json object.
    {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
    CLASS FINAL JsonDocument IMPLEMENTS IJsonContainerElement
        VAR PUBLIC
            buffer : REF_TO ARRAY[*] OF CHAR;
        END_VAR
        
        VAR PROTECTED
            _firstElement : IJsonElementMuteable;
            _lastElement : IJsonElementMuteable;
            _rootElement : IJsonElement;
            _lentgh : DINT;
            _bufIndex : DINT;
        END_VAR

        /// Returns the JSON string of the JSON document (max. 254 characters)
        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC ToString : STRING
            VAR_TEMP
                _str : STRING;
                _to : IJsonElementMuteable;
            END_VAR
        
            _str := Concat(_str, '{');
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

        /// Serializes the JSON document ino a ARRAY OF CHAR
        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC Serialize : BOOL
            VAR_TEMP
                _to : IJsonElementMuteable;
                _bufLowerBound : DINT;
            END_VAR
            IF (buffer = NULL)  THEN
                Serialize := FALSE;
                RETURN;
            END_IF;
            // Clear buffer (not hard before serializing)
            THIS.ClearBuffer();

            _bufLowerBound := LOWER_BOUND(buffer^, 1);
            _bufIndex := _bufLowerBound;
            THIS.AddChar(c := '{');            
            
            _to := _firstElement;
            WHILE _to <> NULL DO
                _to.Serialize(doc := REF(THIS));
                _to := _to.GetNext();
                IF (_to <> NULL) THEN
                    THIS.AddString(s := ', ');                     
                END_IF;
            END_WHILE;
            THIS.AddChar(c := '}'); 
            Serialize := TRUE;
        END_METHOD

        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC AddChar : BOOL
            VAR_INPUT
                c : CHAR;
            END_VAR
            IF (buffer = NULL)  THEN
                AddChar := FALSE;
                RETURN;
            END_IF;
            buffer^[_bufIndex] := c;
            _bufIndex := _bufIndex + 1;
            _lentgh := _lentgh + 1;
            AddChar := TRUE;
        END_METHOD

        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC AddString : BOOL
            VAR_INPUT
                s : STRING;
            END_VAR
            VAR_TEMP
                i : INT;
            END_VAR
            IF (buffer = NULL)  THEN
                AddString := FALSE;
                RETURN;
            END_IF;
            FOR i := 1 TO LengthOf(s) DO
                buffer^[_bufIndex] := s[i];
                _bufIndex := _bufIndex + 1;
                _lentgh := _lentgh + 1;
            END_FOR;
            AddString := TRUE;
        END_METHOD
    
        /// Returns the count of the serialized characters
        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC GetLength : DINT
            GetLength := _lentgh;
        END_METHOD

        /// Returns root element of the JSON document
        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC GetRootElement : IJsonElement
            GetRootElement := _rootElement;
        END_METHOD
    
        /// Add a new element to the JSON document
        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC AddElement : IJsonContainerElement
            VAR_INPUT
                elem : IJsonElement;
            END_VAR
            VAR_TEMP
                _elemMuted : IJsonElementMuteable;
                _lastElem : IJsonElement;
            END_VAR
            _elemMuted ?= elem;
            IF (_firstElement = NULL) THEN
                _firstElement := _elemMuted;
                _lastElement := _elemMuted;
                _rootElement := elem;
            ELSE
                _elemMuted ?= elem;
                _lastElem ?= _lastElement;
                _lastElem.Insert(elem);
                _lastElement := _elemMuted;
            END_IF;
            AddElement := THIS;
        END_METHOD

        /// Clear the buffer logically (fast). 
        /// If `hard = TRUE` then delete the buffer also 
        /// physically (slow)
        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC ClearBuffer
            VAR_INPUT
                hard : BOOL;
            END_VAR
            VAR_TEMP
                i : DINT;
                _bufLowerBound : DINT;
            END_VAR
            IF (buffer = NULL)  THEN
                RETURN;
            END_IF;
            _bufLowerBound := LOWER_BOUND(buffer^, 1);
            IF (hard) THEN
                FOR i := _bufLowerBound TO _bufIndex DO
                    buffer^[i] := TO_CHAR(BYTE#16#00);
                END_FOR;
            END_IF;
            _bufLowerBound := 0;
            _bufIndex := 0;
            _lentgh := 0;
        END_METHOD

        /// Reset the complete object tree and the destination buffer 
        /// of the JSON document for the purpose, a new JSON object should
        /// be created.
        {axcode:docs-v0:@simatic-ax/json:JsonDocument.md}
        METHOD PUBLIC Reset
            VAR_TEMP
                _currentElement : IJsonElementMuteable;
                _nextElement : IJsonElementMuteable;
            END_VAR
            
            _currentElement := _firstElement;
            WHILE _currentElement <> NULL DO
                _nextElement := _currentElement.GetNext();           
                _currentElement.Reset();      
                _currentElement := _nextElement;    
            END_WHILE;

            /// Clear the buffer
            THIS.ClearBuffer(hard := TRUE);
            _firstElement := NULL;
            _lastElement := NULL;
            _rootElement := NULL;
        END_METHOD

    END_CLASS
END_NAMESPACE