USING Simatic.Ax.Conversion;
USING System.Strings;

NAMESPACE Simatic.Ax.Json

    CLASS FINAL Deserializer
        VAR PUBLIC
            buffer : REF_TO ARRAY[*] OF CHAR;
        END_VAR
        METHOD PRIVATE KeyIsInIndexSpan : BOOL
            VAR_INPUT
                key : STRING;
                startIndex : INT;
                endIndex : INT;
            END_VAR
            VAR_TEMP
                keyIndex : INT := 1;
                loopIndex : INT;
            END_VAR
            FOR loopIndex := startIndex TO endIndex DO
                IF NOT (buffer^[loopIndex] = key[keyIndex]) THEN
                    KeyIsInIndexSpan := FALSE;
                    RETURN;
                END_IF;
                keyIndex := keyIndex + 1;
            END_FOR;
            KeyIsInIndexSpan := TRUE;
        END_METHOD
        METHOD PRIVATE GetValueFromIndex : STRING
            VAR_INPUT
                startIndex : INT;
                endIndex : INT;
            END_VAR
            VAR_TEMP
                index : INT;
                realStartIndex : INT;
                realEndIndex : INT;
                incrementBackwards : INT := -1;
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
                bufferStart : INT;
                bufferEnd : INT;
            END_VAR
            VAR_TEMP
                index : INT;
                incrementBackwards : INT := -1;
                _lb, _ub : INT;
            END_VAR
            _lb := TO_INT(LOWER_BOUND(buffer^, 1));
            _ub := TO_INT(UPPER_BOUND(buffer^, 1));
            FOR index := _lb TO _ub DO //TODO: When possible change to Array* upper und lowerbound
                IF (buffer^[index] = '{') THEN
                    bufferStart := index;
                    EXIT;
                END_IF;
            END_FOR;
            FOR index := _ub TO _lb BY incrementBackwards DO
                IF (buffer^[index] = '}') THEN
                    bufferEnd := index;
                    EXIT;
                END_IF;
            END_FOR;
        END_METHOD
        METHOD PRIVATE GetValue_WithKeyArray : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR_TEMP
                key : STRING;
                keyFound : BOOL := FALSE;
                valueFound : BOOL := FALSE;
                keyIndex : DINT;
                index : INT;
                quotationMarkCount : INT := 0;
                bracesCount : INT := 0;
                squareBrakedCount : INT := 0;
                inKeyArea : BOOL := TRUE;
                inValueArea : BOOL := FALSE;
                inArrayArea : BOOL := FALSE;
                inNestedArea : BOOL := FALSE;
                documentStartIndex : INT;
                documentEndIndex : INT;
                keyArrayLower : DINT;
                keyArrayUpper : DINT;
            END_VAR
            VAR_OUTPUT
                areaStartIndex : INT;
                areaEndIndex : INT;
            END_VAR
            THIS.GetBufferIndizes(documentStartIndex, documentEndIndex);
            keyArrayLower := LOWER_BOUND(keyArray, 1);
            keyArrayUpper := UPPER_BOUND(keyArray, 1);
            //iterate through keys
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
                                inValueArea := FALSE;
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
                                inValueArea := FALSE;
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
                        IF (buffer^[index] = ':') THEN
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
                    IF (keyFound = TRUE AND valueFound = TRUE) THEN
                        EXIT;
                    END_IF;
                    valueFound := FALSE;
                END_FOR;
                IF (keyFound = TRUE AND valueFound = TRUE) THEN
                    GetValue_WithKeyArray := keyFound;
                    documentStartIndex := areaStartIndex;
                    documentEndIndex := areaEndIndex;
                    valueFound := FALSE;
                    keyFound := FALSE;
                ELSE
                    GetValue_WithKeyArray := keyFound;
                    RETURN;
                END_IF;
            END_FOR;
        END_METHOD
        /// TryParse(String) : String
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : STRING;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                value := THIS.GetValueFromIndex(valueStartIndex, valueEndIndex);
            ELSE
                value := '';
            END_IF;
        END_METHOD
        /// TryParse(ARRAY[*] OF STRING) : String
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : STRING;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                value := THIS.GetValueFromIndex(valueStartIndex, valueEndIndex);
            ELSE
                value := '';
            END_IF;
        END_METHOD
        /// TryParse(String) : SINT
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : SINT;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := SINT#0;
            END_IF;
        END_METHOD
        /// TryParse(ARRAY[*] OF STRING) : SINT
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : SINT;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := SINT#0;
            END_IF;
        END_METHOD
        /// TryParse(String) : LINT
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : LINT;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.StringToAnyInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := 0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : LINT;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.StringToAnyInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := 0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : DINT;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := 0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : DINT;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := 0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : INT;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := 0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : INT;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := 0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : USINT;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := USINT#0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : USINT;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := USINT#0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : UINT;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := USINT#0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : UINT;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := USINT#0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : UDINT;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := USINT#0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : UDINT;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := USINT#0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                key : STRING;
            END_VAR
            VAR
                keyArray : ARRAY[0..0] OF STRING;
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : ULINT;
            END_VAR
            keyArray[0] := key;
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := USINT#0;
            END_IF;
        END_METHOD
        METHOD PUBLIC TryParse : BOOL
            VAR_INPUT
                keyArray : ARRAY[*] OF STRING;
            END_VAR
            VAR
                valueStartIndex : INT;
                valueEndIndex : INT;
            END_VAR
            VAR_OUTPUT
                value : ULINT;
            END_VAR
            TryParse := THIS.GetValue_WithKeyArray(keyArray, valueStartIndex, valueEndIndex);
            IF TryParse THEN
                TryParse := Conversion.Strings.ToInt(THIS.GetValueFromIndex(valueStartIndex, valueEndIndex), value);
            END_IF;
            IF NOT TryParse THEN
                value := USINT#0;
            END_IF;
        END_METHOD
    END_CLASS

END_NAMESPACE
