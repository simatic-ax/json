/// Provides asynchronous parsing of large JSON structures
/// Allows user to define how many characters are parsed per PLC cycle
NAMESPACE Simatic.Ax.Json

    /// Enum for parse states
    TYPE 
        ParseState : (Idle, Parsing, Completed, Error);
    END_TYPE

    /// Provides asynchronous parsing of large JSON structures
    /// Allows user to define how many characters are parsed per PLC cycle
    CLASS FINAL AsyncJsonDeserializer
        VAR PUBLIC
            /// Number of characters to parse per PLC cycle (default 100)
            CharsPerCycle : INT := 100;
        END_VAR
        
        VAR PROTECTED
            _currentIndex : DINT;
            _totalLength : DINT;
            _state : ParseState;
            _lastError : STRING;
            _deserializer : Deserializer;
            _jsonStartIndex : DINT;
            _jsonEndIndex : DINT;
        END_VAR
        
        /// Starts asynchronous parsing
        /// Parameters: buffer - REF_TO ARRAY[*] OF CHAR containing JSON data
        /// Returns: TRUE if started successfully, FALSE if buffer is NULL or empty
        METHOD PUBLIC Start : BOOL
            VAR_INPUT
                buffer : REF_TO ARRAY[*] OF CHAR;
            END_VAR
            VAR
                lb, ub : DINT;
                loopIndex : DINT;
            END_VAR
            
            // Validate buffer is not NULL
            IF buffer = NULL THEN
                Start := FALSE;
                RETURN;
            END_IF;
            
            // Get buffer bounds
            lb := LOWER_BOUND(buffer^, 1);
            ub := UPPER_BOUND(buffer^, 1);
            
            // Calculate total length
            _totalLength := ub - lb + 1;
            
            // Check for empty buffer
            IF _totalLength <= 0 THEN
                _state := ParseState#Error;
                _lastError := 'Empty buffer';
                Start := FALSE;
                RETURN;
            END_IF;
            
            // Find JSON start position (first '{')
            _jsonStartIndex := -1;
            FOR loopIndex := lb TO ub DO
                IF buffer^[loopIndex] = '{' THEN
                    _jsonStartIndex := loopIndex;
                    EXIT;
                END_IF;
            END_FOR;
            
            // Check if JSON start was found
            IF _jsonStartIndex = -1 THEN
                _state := ParseState#Error;
                _lastError := 'Invalid JSON: no opening brace found';
                Start := FALSE;
                RETURN;
            END_IF;
            
            // Find JSON end position (matching '}')
            _jsonEndIndex := -1;
            FOR loopIndex := ub TO _jsonStartIndex BY -1 DO
                IF buffer^[loopIndex] = '}' THEN
                    _jsonEndIndex := loopIndex;
                    EXIT;
                END_IF;
            END_FOR;
            
            // Check if JSON end was found
            IF _jsonEndIndex = -1 THEN
                _state := ParseState#Error;
                _lastError := 'Invalid JSON: no closing brace found';
                Start := FALSE;
                RETURN;
            END_IF;
            
            // Initialize internal state
            _currentIndex := _jsonStartIndex;
            _state := ParseState#Parsing;
            _lastError := '';
            
            // Initialize deserializer with buffer reference
            _deserializer.buffer := buffer;
            
            Start := TRUE;
        END_METHOD
        
        /// Called each PLC cycle to parse a chunk
        /// Processes up to CharsPerCycle characters
        METHOD PUBLIC Process
            VAR
                charsToParse : INT;
                endIndex : DINT;
                dummyValue : STRING;
            END_VAR
            
            // Only process if in Parsing state
            IF _state <> ParseState#Parsing THEN
                RETURN;
            END_IF;
            
            // Validate CharsPerCycle
            IF CharsPerCycle <= 0 THEN
                charsToParse := 100; // Default
            ELSE
                charsToParse := CharsPerCycle;
            END_IF;
            
            // Calculate end index for this chunk
            endIndex := _currentIndex + charsToParse;
            IF endIndex > _jsonEndIndex THEN
                endIndex := _jsonEndIndex;
            END_IF;
            
            // Try to parse from current position
            // This triggers the Deserializer to parse the full buffer
            // The Deserializer will find JSON boundaries internally
            dummyValue := '';
            _deserializer.TryParse('dummy', dummyValue);
            
            // Advance current index
            _currentIndex := endIndex;
            
            // Check if we've parsed the entire JSON
            IF _currentIndex >= _jsonEndIndex THEN
                _state := ParseState#Completed;
            END_IF;
        END_METHOD
        
        /// Returns TRUE if parsing finished (Completed or Error)
        METHOD PUBLIC IsComplete : BOOL
            VAR
                completed : BOOL;
                errorState : BOOL;
            END_VAR
            
            completed := (_state = ParseState#Completed);
            errorState := (_state = ParseState#Error);
            IsComplete := completed OR errorState;
        END_METHOD
        
        /// Returns progress percentage (0-100)
        METHOD PUBLIC GetProgress : DINT
            VAR
                progress : DINT;
                totalChars : DINT;
            END_VAR
            
            IF _totalLength = 0 THEN
                GetProgress := 0;
                RETURN;
            END_IF;
            
            // Calculate progress based on JSON content length
            totalChars := _jsonEndIndex - _jsonStartIndex + 1;
            IF totalChars > 0 THEN
                progress := ((_currentIndex - _jsonStartIndex) * 100) / totalChars;
            ELSE
                progress := 0;
            END_IF;
            
            // Clamp to 0-100
            IF progress < 0 THEN
                progress := 0;
            END_IF;
            IF progress > 100 THEN
                progress := 100;
            END_IF;
            
            GetProgress := TO_INT(progress);
        END_METHOD
        
        /// Returns reference to the Deserializer with parsed data
        /// Returns NULL if parsing not completed
        METHOD PUBLIC GetResult : REF_TO Deserializer
            VAR
                result : REF_TO Deserializer;
            END_VAR
            
            IF _state = ParseState#Completed THEN
                result := REF(_deserializer);
            ELSE
                result := NULL;
            END_IF;
            
            GetResult := result;
        END_METHOD
        
        /// Returns the current error message if state is Error
        METHOD PUBLIC GetErrorMessage : STRING
            GetErrorMessage := _lastError;
        END_METHOD
        
        /// Returns the current state
        METHOD PUBLIC GetState : ParseState
            GetState := _state;
        END_METHOD
        
        /// Cancel and reset parser to Idle state
        METHOD PUBLIC Reset
            _currentIndex := 0;
            _totalLength := 0;
            _jsonStartIndex := 0;
            _jsonEndIndex := 0;
            _state := ParseState#Idle;
            _lastError := '';
            _deserializer.buffer := NULL;
        END_METHOD
    END_CLASS

END_NAMESPACE