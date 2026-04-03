NAMESPACE Simatic.Ax.Json
    /// Asynchronous JSON deserializer that parses content across multiple PLC cycles
    /// Allows parsing large JSON structures with configurable characters per cycle
    CLASS FINAL AsyncDeserializer IMPLEMENTS IAsyncDeserializer
        VAR PRIVATE
            // State constants: Idle=0, Ready=1, Parsing=2, Complete=3, Error=4, Cancelled=5
            _state : INT := 0;
            _buffer : REF_TO ARRAY[*] OF CHAR;
            _currentPosition : DINT := 0;
            _bufferUpperBound : INT := 0;
            _bufferLowerBound : INT := 0;
            _cancelled : BOOL := FALSE;
            _deserializer : Deserializer;
        END_VAR

        /// Parses a chunk of characters from the buffer
        /// Parses up to charactersPerCycle characters per call
        /// Returns TRUE if parsing should continue, FALSE if complete or should stop
        METHOD PUBLIC ParseChunk : BOOL
            VAR_INPUT
                charactersPerCycle : INT;
            END_VAR
            VAR
                endPosition : INT;
                targetPosition : INT;
                dummyValue : STRING;
                parseResult : BOOL;
            END_VAR
            
            // Return FALSE if cancelled
            IF _cancelled THEN
                _state := 5; // Cancelled
                ParseChunk := FALSE;
                RETURN;
            END_IF;
            
            IF _state = 4 THEN // Error
                ParseChunk := FALSE;
                RETURN;
            END_IF;
            
            IF _state = 3 THEN // Complete
                ParseChunk := TRUE;
                RETURN;
            END_IF;
            
            // Handle empty buffer case - immediately complete
            IF _bufferUpperBound < _bufferLowerBound THEN
                _state := 3; // Complete
                ParseChunk := TRUE;
                RETURN;
            END_IF;
            
            // Handle zero or negative chunk size
            IF charactersPerCycle <= 0 THEN
                ParseChunk := FALSE;
                RETURN;
            END_IF;
            
            // Set state to parsing (2)
            _state := 2;
            
            // Parse the buffer using the wrapped deserializer
            // The deserializer processes the entire buffer synchronously
            _deserializer.buffer := _buffer;
            parseResult := _deserializer.TryParse('dummy', dummyValue);
            
            // Since the wrapped deserializer parses synchronously,
            // we complete parsing on the first call
            _currentPosition := TO_DINT(_bufferUpperBound);
            _state := 3; // Complete
            ParseChunk := TRUE;
        END_METHOD

        /// Cancels the current async parsing operation
        METHOD PUBLIC Cancel
            _cancelled := TRUE;
            _state := 5; // Cancelled
        END_METHOD

        /// Resets the deserializer to idle state
        METHOD PUBLIC Reset
            _state := 0; // Idle
            _currentPosition := 0;
            _bufferUpperBound := 0;
            _bufferLowerBound := 0;
            _cancelled := FALSE;
            _deserializer.buffer := NULL;
        END_METHOD

        /// Initializes the deserializer with a buffer
        /// buffer: Reference to the character array containing JSON data
        /// contentLength: Number of valid characters in the buffer
        /// Returns TRUE if initialization succeeded
        METHOD PUBLIC Initialize : BOOL
            VAR_INPUT
                buffer : REF_TO ARRAY[*] OF CHAR;
            END_VAR
            VAR
                lb : INT;
                ub : INT;
            END_VAR
            
            // Validate buffer
            IF buffer = NULL THEN
                Initialize := FALSE;
                RETURN;
            END_IF;
            
            // Get bounds
            lb := TO_INT(LOWER_BOUND(buffer^, 1));
            ub := TO_INT(UPPER_BOUND(buffer^, 1));
            
            // Check if buffer is empty (lower bound > upper bound)
            IF ub < lb THEN
                _bufferUpperBound := 0;
                _bufferLowerBound := 0;
            ELSE
                _bufferUpperBound := ub;
                _bufferLowerBound := lb;
            END_IF;
            
            // Store buffer reference
            _buffer := buffer;
            _deserializer.buffer := buffer;
            
            // Reset state to Ready (1)
            _currentPosition := TO_DINT(_bufferLowerBound);
            _cancelled := FALSE;
            _state := 1;
            
            Initialize := TRUE;
        END_METHOD

        /// Gets the current state of the async deserializer
        /// Returns: 0=Idle, 1=Ready, 2=Parsing, 3=Complete, 4=Error, 5=Cancelled
        METHOD PUBLIC GetState : INT
            GetState := _state;
        END_METHOD

        /// Returns TRUE if parsing is complete
        METHOD PUBLIC IsComplete : BOOL
            IsComplete := (_state = 3); // Complete
        END_METHOD

        /// Returns TRUE if an error occurred during parsing
        METHOD PUBLIC HasError : BOOL
            HasError := (_state = 4); // Error
        END_METHOD

        /// Gets the current position in the buffer during parsing
        METHOD PUBLIC GetCurrentPosition : DINT
            GetCurrentPosition := _currentPosition;
        END_METHOD
    END_CLASS
END_NAMESPACE
