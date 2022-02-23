USING Simatic.Ax.Conversion;
USING Deserializer;
USING System.Strings;

NAMESPACE Simatic.Ax.Json
    CLASS Deserializer
        //TODO: initializer (kontruktor)
        VAR PRIVATE //TODO Public entfernen wenn ref_to array star, derzeit nur noch zum testen drin!
            buffer : REF_TO ARRAY[0..999] OF CHAR;
        END_VAR

        //Temporäre Hilfsmethode um Buffer zus etzten, bis Ref_to array*
        METHOD PUBLIC SetBuffer
            VAR_INPUT
                _buffer : REF_TO ARRAY[0..999] OF CHAR;
            end_var

            buffer := _buffer;
        END_METHOD

        METHOD PUBLIC KeyIsInIndexSpan : BOOL
            VAR_INPUT
                key : REF_TO STRING;
                startIndex: INT;
                endIndex: INT;
            end_var
            VAR_TEMP
                keyIndex: INT := 1;
                loopIndex: INT;
            END_VAR

            FOR loopIndex := startIndex TO endIndex DO
                IF NOT (buffer^[loopIndex] = key^[keyIndex])  THEN
                    KeyIsInIndexSpan := FALSE;
                    RETURN;
                END_IF;

                keyIndex := keyIndex + 1;
            END_FOR;

            KeyIsInIndexSpan := TRUE;

        END_METHOD

        METHOD PUBLIC GetValueFromIndex : STRING
            VAR_INPUT
               startIndex: INT;
               endIndex: INT; 
            END_VAR
            VAR_TEMP
                index: INT;
                realStartIndex: INT;
                realEndIndex: INT;
                
                incrementBackwards: INT := -1;
            END_VAR

            FOR index := startIndex TO endIndex DO
                IF NOT ((buffer^[index] = ' ') OR ((buffer^[index] = '"'))) THEN
                    realStartIndex := index;
                    EXIT;
                END_IF;
            END_FOR;


            FOR index := endIndex TO realStartIndex BY incrementBackwards DO
                IF NOT ((buffer^[index] = ' ') OR ((buffer^[index] = '"'))) THEN
                    realEndIndex := index;
                    EXIT;
                END_IF;
            
            END_FOR;

            GetValueFromIndex := Conversion.Arrays.ToString(buffer^, realStartIndex, realEndIndex);
        END_METHOD

        METHOD PRIVATE GetBufferIndizes
            VAR_OUTPUT
                bufferStart: INT;
                bufferEnd: INT;
            END_VAR
            VAR_TEMP
                index: INT;
                incrementBackwards: INT := -1;
            END_VAR

            FOR index := 0 TO 999 DO //TODO: Array* upper und lowerbound
                IF (buffer^[index] = '{') THEN
                    bufferStart := index;
                    EXIT;
                END_IF;
            END_FOR;

            FOR index := 999 TO 0 BY incrementBackwards DO
                IF (buffer^[index] = '}') THEN
                    bufferEnd := index;
                    RETURN;
                END_IF;
            END_FOR;
        END_METHOD

        //---------------------TODO: Temporary for playground
        METHOD PUBLIC KeyIsInIndexSpan : BOOL 
            VAR_INPUT
                key :  STRING;
                startIndex: INT;
                endIndex: INT;
            end_var
            VAR_TEMP
                keyIndex: INT := 1;
                loopIndex: INT;
            END_VAR

            FOR loopIndex := startIndex TO endIndex DO
                IF NOT (buffer^[loopIndex] = key[keyIndex])  THEN
                    KeyIsInIndexSpan := FALSE;
                    RETURN;
                END_IF;

                keyIndex := keyIndex + 1;
            END_FOR;

            KeyIsInIndexSpan := TRUE;

        END_METHOD

        //Playground
        METHOD PUBLIC GetValue_WithKeyArray : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR_TEMP
                key: STRING;
                keyFound: BOOL := FALSE;
                valueFound: BOOL := FALSE;

                keyIndex: DINT;
                index: INT;

                quotationMarkCount : INT := 0;
                bracesCount: INT := 0;
                squareBrakedCount: INT := 0;

                inKeyArea : BOOL := TRUE;
                inValueArea: BOOL := FALSE;
                inArrayArea: BOOL := FALSE;
                inNestedArea: BOOL := FALSE;

                documentStartIndex: INT;
                documentEndIndex: INT;

                keyArrayLower: DINT;
                keyArrayUpper: DINT;
            END_VAR
            VAR_OUTPUT
                areaStartIndex: INT;
                areaEndIndex: INT;
            END_VAR

            THIS.GetBufferIndizes(documentStartIndex, documentEndIndex );

            keyArrayLower:= LOWER_BOUND(keyArray, 1);
            keyArrayUpper:= UPPER_BOUND(keyArray, 1);

            //gehe durch key Array!
            FOR keyIndex := keyArrayLower TO keyArrayUpper DO
                key := keyArray[keyIndex];
                
                FOR index := documentStartIndex TO documentEndIndex DO 
                
                    //----- key area
                    IF inKeyArea AND NOT inNestedArea AND NOT inValueArea AND NOT inArrayArea THEN
                        IF (keyFound = FALSE AND buffer^[index] = '"') THEN
                            quotationMarkCount := quotationMarkCount + 1;
        
                            IF (quotationMarkCount = 1) THEN
                                areaStartIndex := index + 1;
                            END_IF;
        
                            IF (quotationMarkCount = 2) THEN
                                inKeyArea := FALSE;
    
                                areaEndIndex := index - 1;
                                quotationMarkCount := 0;
        
                                IF (LengthOf(key) = (areaEndIndex - areaStartIndex + 1)) THEN
                                    keyFound := THIS.KeyIsInIndexSpan(key, areaStartIndex, areaEndIndex);
                                END_IF;
                            END_IF;
    
                            CONTINUE;
                        END_IF;
                    END_IF;
                    
                    //----- array area
                    IF NOT inKeyArea AND NOT inNestedArea THEN
                        IF (buffer^[index] = '[') THEN
                            squareBrakedCount := squareBrakedCount + 1;

                            IF squareBrakedCount = 1 THEN
                                inArrayArea := TRUE;
                                inNestedArea := FALSE;
                                inKeyArea := FALSE;
                                inValueArea:= FALSE;
    
                                areaStartIndex := index;
                            END_IF;
                            
                            CONTINUE;
                        END_IF;
    
                        IF (buffer^[index] = ']' AND NOT inValueArea) THEN
                            squareBrakedCount := squareBrakedCount - 1;

                            IF squareBrakedCount = 0 THEN
                                inKeyArea := TRUE;
                                inNestedArea := FALSE;
                                inValueArea := FALSE;
                                inArrayArea := FALSE;
                            
                                areaEndIndex := index;
                                valueFound := TRUE;
                            END_IF;
                            
                        END_IF;
                    END_IF;
    
                    //----- nested area
                    IF NOT inKeyArea AND NOT inArrayArea THEN
                        IF (buffer^[index] = '{') THEN
                            bracesCount := bracesCount + 1;

                            IF bracesCount = 1 THEN
                                inNestedArea := TRUE;
                                inKeyArea := FALSE;
                                inValueArea:= FALSE;
                                inArrayArea := FALSE;
    
                                areaStartIndex := index;
                            END_IF;
                            
                            CONTINUE;
                        END_IF;
        
                        IF (buffer^[index] = '}' AND NOT inValueArea) THEN
                            bracesCount := bracesCount - 1;

                            IF bracesCount = 0 THEN
                                inKeyArea := TRUE;
                                inNestedArea := FALSE;
                                inValueArea := FALSE;
                                inArrayArea := FALSE;
                            
                                areaEndIndex := index;
                                valueFound := TRUE;
                            END_IF;
                            
                        END_IF;
                    END_IF;
                    
                    //----- value area
                    IF NOT inKeyArea AND NOT inNestedArea AND NOT inArrayArea THEN
                        IF (buffer^[index] = ':' ) THEN
                            inValueArea := TRUE;
                            inNestedArea := FALSE;
                            inKeyArea := FALSE;
                            inArrayArea := FALSE;
    
                            areaStartIndex := index + 1;
                            CONTINUE;
                        END_IF;
        
                        IF (buffer^[index] = ',' OR buffer^[index] = '}') THEN
                            inKeyArea := TRUE;
                            inValueArea := FALSE;
                            inNestedArea := FALSE;
                            inArrayArea := FALSE;
        
                            areaEndIndex := index - 1;
                            valueFound := TRUE;
                        END_IF;
                    END_IF;
                    
                    //----- get value
                    IF (keyFound = TRUE AND valueFound = TRUE) THEN
                        EXIT;

                    END_IF;
    
                    valueFound := FALSE; // must be reset, otherwise the last found key is attached!
    
                END_FOR;

                //doubleCheck, Remove later
                IF (keyFound = TRUE AND valueFound = TRUE) THEN
                    
                    GetValue_WithKeyArray:= keyFound;
                    documentStartIndex:= areaStartIndex;
                    documentEndIndex:= areaEndIndex;
                    GetValue_WithKeyArray := keyFound;
                    
                    valueFound:= FALSE;
                    keyFound:= FALSE;

                
                ELSE //doublecode remove later

                    GetValue_WithKeyArray := keyFound;
                    RETURN;
                END_IF;



            END_FOR;
            
            

        END_METHOD






        METHOD PUBLIC GetValue : BOOL
            VAR_INPUT
                key : REF_TO STRING;
            END_VAR
            VAR_TEMP
                keyFound: BOOL := FALSE;
                valueFound: BOOL := FALSE;

                index: INT;
                quotationMarkCount : INT := 0;
                bracesCount: INT := 0;
                squareBrakedCount: INT := 0;

                inKeyArea : BOOL := TRUE;
                inNestedArea: BOOL := FALSE;
                inValueArea: BOOL := FALSE;
                inArrayArea: BOOL := FALSE;

                areaStartIndex: INT;
                areaEndIndex: INT;

                documentStartIndex: INT;
                documentEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: STRING;
            END_VAR

            THIS.GetBufferIndizes(documentStartIndex, documentEndIndex );

            FOR index := documentStartIndex TO documentEndIndex DO 
                
                //----- key area
                IF inKeyArea AND NOT inNestedArea AND NOT inValueArea AND NOT inArrayArea THEN
                    IF (keyFound = FALSE AND buffer^[index] = '"') THEN
                        quotationMarkCount := quotationMarkCount + 1;
    
                        IF (quotationMarkCount = 1) THEN
                            areaStartIndex := index + 1;
                        END_IF;
    
                        IF (quotationMarkCount = 2) THEN
                            inKeyArea := FALSE;

                            areaEndIndex := index - 1;
                            quotationMarkCount := 0;
    
                            IF (LengthOf(key^) = (areaEndIndex - areaStartIndex + 1)) THEN
                                keyFound := THIS.KeyIsInIndexSpan(key, areaStartIndex, areaEndIndex);
                            END_IF;
                        END_IF;

                        CONTINUE;
                    END_IF;
                END_IF;
                
                //----- array area
                IF NOT inKeyArea AND NOT inNestedArea THEN
                    IF (buffer^[index] = '[') THEN
                        squareBrakedCount := squareBrakedCount + 1;

                        IF squareBrakedCount = 1 THEN
                            inArrayArea := TRUE;
                            inNestedArea := FALSE;
                            inKeyArea := FALSE;
                            inValueArea:= FALSE;

                            areaStartIndex := index;
                        END_IF;
                        
                        CONTINUE;
                    END_IF;

                    IF (buffer^[index] = ']' AND NOT inValueArea) THEN
                        squareBrakedCount := squareBrakedCount - 1;

                        IF squareBrakedCount = 0 THEN
                            inKeyArea := TRUE;
                            inNestedArea := FALSE;
                            inValueArea := FALSE;
                            inArrayArea := FALSE;
                        
                            areaEndIndex := index;
                            valueFound := TRUE;
                        END_IF;
                        
                    END_IF;
                END_IF;

                //----- nested area
                IF NOT inKeyArea AND NOT inArrayArea THEN
                    IF (buffer^[index] = '{') THEN
                        bracesCount := bracesCount + 1;

                        IF bracesCount = 1 THEN
                            inNestedArea := TRUE;
                            inKeyArea := FALSE;
                            inValueArea:= FALSE;
                            inArrayArea := FALSE;

                            areaStartIndex := index;
                        END_IF;
                        
                        CONTINUE;
                    END_IF;
    
                    IF (buffer^[index] = '}' AND NOT inValueArea) THEN
                        bracesCount := bracesCount - 1;

                        IF bracesCount = 0 THEN
                            inKeyArea := TRUE;
                            inNestedArea := FALSE;
                            inValueArea := FALSE;
                            inArrayArea := FALSE;
                        
                            areaEndIndex := index;
                            valueFound := TRUE;
                        END_IF;
                        
                    END_IF;
                END_IF;
                
                //----- value area
                IF NOT inKeyArea AND NOT inNestedArea AND NOT inArrayArea THEN
                    IF (buffer^[index] = ':' ) THEN
                        inValueArea := TRUE;
                        inNestedArea := FALSE;
                        inKeyArea := FALSE;
                        inArrayArea := FALSE;

                        areaStartIndex := index + 1;
                        CONTINUE;
                    END_IF;
    
                    IF (buffer^[index] = ',' OR buffer^[index] = '}') THEN
                        inKeyArea := TRUE;
                        inValueArea := FALSE;
                        inNestedArea := FALSE;
                        inArrayArea := FALSE;
    
                        areaEndIndex := index - 1;
                        valueFound := TRUE;
                    END_IF;
                END_IF;
                
                //----- get value
                IF (keyFound = TRUE AND valueFound = TRUE) THEN
                    value:= THIS.GetValueFromIndex(areaStartIndex, areaEndIndex);
                    GetValue:= keyFound;
                    RETURN;
                END_IF;

                valueFound := FALSE; // must be reset, otherwise the last found key is attached!

            END_FOR;

            value := '';
            GetValue := keyFound;

        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key: STRING;
            END_VAR
            VAR 
                keyArray: ARRAY[0..0] OF STRING;
                valueStartIndex: INT;
                valueEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: STRING;
            END_VAR

            keyArray[0] := key;

            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);

            IF TryParse THEN
                value:= THIS.GetValueFromIndex(valueStartIndex, valueEndIndex);
            END_IF;
          
        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray: ARRAY[*] OF STRING;
            END_VAR
            VAR 
                valueStartIndex: INT;
                valueEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: STRING;
            END_VAR

            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);

            IF TryParse THEN
                value:= THIS.GetValueFromIndex(valueStartIndex, valueEndIndex);
            END_IF;
          
        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key: STRING;
            END_VAR
            VAR 
                keyArray: ARRAY[0..0] OF STRING;
                valueStartIndex: INT;
                valueEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: SINT;
            END_VAR

            keyArray[0] := key;

            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);

            IF TryParse THEN
                TryParse:= Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
          
        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray: ARRAY[*] OF STRING;
            END_VAR
            VAR 
                valueStartIndex: INT;
                valueEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: SINT;
            END_VAR

            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);

            IF TryParse THEN
                TryParse:= Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
          
        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key: STRING;
            END_VAR
            VAR 
                keyArray: ARRAY[0..0] OF STRING;
                valueStartIndex: INT;
                valueEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: LINT;
            END_VAR

            keyArray[0] := key;

            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);

            IF TryParse THEN
                TryParse:= Conversion.StringToAnyInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
          
        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray: ARRAY[*] OF STRING;
            END_VAR
            VAR 
                valueStartIndex: INT;
                valueEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: LINT;
            END_VAR

            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);

            IF TryParse THEN
                TryParse:= Conversion.StringToAnyInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
          
        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key: STRING;
            END_VAR
            VAR 
                keyArray: ARRAY[0..0] OF STRING;
                valueStartIndex: INT;
                valueEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: DINT;
            END_VAR

            keyArray[0] := key;

            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);

            IF TryParse THEN
                TryParse:= Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
          
        END_METHOD

        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray: ARRAY[*] OF STRING;
            END_VAR
            VAR 
                valueStartIndex: INT;
                valueEndIndex: INT;
            END_VAR
            VAR_OUTPUT
                value: DINT;
            END_VAR

            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);

            IF TryParse THEN
                TryParse:= Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
          
        END_METHOD

    END_CLASS
END_NAMESPACE