NAMESPACE Simatic.Ax.Json
    /// Interface for asynchronous JSON deserialization
    /// Allows parsing to be distributed across multiple PLC cycles
    INTERFACE IAsyncDeserializer
        /// Parses a chunk of characters from the buffer
        /// charactersPerCycle: Maximum number of characters to parse in this cycle
        /// Returns TRUE if parsing should continue, FALSE if complete or should stop
        METHOD ParseChunk : BOOL
            VAR_INPUT
                charactersPerCycle : INT;
            END_VAR
        END_METHOD
        
        /// Cancels the current async parsing operation
        METHOD Cancel
        END_METHOD
        
        /// Resets the deserializer to idle state
        METHOD Reset
        END_METHOD
        
        /// Initializes the deserializer with a buffer
        /// buffer: Reference to the character array containing JSON data
        /// Returns TRUE if initialization succeeded
        METHOD Initialize : BOOL
            VAR_INPUT
                buffer : REF_TO ARRAY[*] OF CHAR;
            END_VAR
        END_METHOD
        
        /// Gets the current state of the async deserializer
        /// Returns: 0=Idle, 1=Ready, 2=Parsing, 3=Complete, 4=Error, 5=Cancelled
        METHOD GetState : INT
        END_METHOD
        
        /// Returns TRUE if parsing is complete
        METHOD IsComplete : BOOL
        END_METHOD
        
        /// Returns TRUE if an error occurred during parsing
        METHOD HasError : BOOL
        END_METHOD
        
        /// Gets the current position in the buffer during parsing
        METHOD GetCurrentPosition : DINT
        END_METHOD
    END_INTERFACE
END_NAMESPACE
