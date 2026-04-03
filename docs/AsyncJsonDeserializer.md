# AsyncJsonDeserializer

## Description

Provides asynchronous parsing of large JSON structures. Splits JSON parsing across multiple PLC cycles to prevent cycle time issues when processing large documents.

The class parses a configurable number of characters per cycle (default 100), allowing the PLC to remain responsive while processing large JSON files.

## Namespace

```st
Simatic.Ax.Json
```

## ParseState Enum

| State | Description |
|-------|-------------|
| `Idle` | Parser is idle, not started |
| `Parsing` | Actively parsing JSON |
| `Completed` | Parsing finished successfully |
| `Error` | Parsing failed with error |

## CLASS AsyncJsonDeserializer

### Properties

#### CharsPerCycle : INT

Number of characters to parse per PLC cycle. Default is 100. Adjust based on your PLC cycle time requirements.

- **Range**: 1 - 1000
- **Default**: 100

### Methods

#### Start(buffer : REF_TO ARRAY[*] OF CHAR) : BOOL

Begins asynchronous parsing of the provided JSON buffer.

**Parameters:**
- `buffer` - Reference to character array containing JSON data

**Returns:**
- `BOOL` - TRUE if parsing started successfully, FALSE on error

**Errors:**
- Returns FALSE if buffer is NULL
- Returns FALSE if buffer is empty
- Returns FALSE if JSON opening brace `{` not found
- Returns FALSE if JSON closing brace `}` not found

**Example:**
```iec-st
VAR
    parser : AsyncJsonDeserializer;
    buffer : ARRAY[0..9999] OF CHAR;
    jsonData : STRING := '{"key": "value"}';
END_VAR

Strings.ToArray(str := jsonData, arr := buffer);
parser.Start(REF(buffer));
```

---

#### Process

Called each PLC cycle to parse a chunk of JSON data. Processes up to `CharsPerCycle` characters per call.

**Requirements:**
- Must call `Start()` before first `Process()` call
- Call repeatedly until `IsComplete()` returns TRUE

**Example:**
```iec-st
// In PROGRAM cycle
IF parser.GetState() = ParseState#Parsing THEN
    parser.Process();
END_IF;
```

---

#### IsComplete() : BOOL

Returns TRUE when parsing is finished (Completed or Error state).

**Returns:**
- `BOOL` - TRUE if parsing completed or errored, FALSE if still parsing

---

#### GetProgress() : DINT

Returns parsing progress as percentage (0-100).

**Returns:**
- `DINT` - Progress percentage from 0 to 100

**Example:**
```iec-st
progress := parser.GetProgress(); // e.g., 45 = 45% complete
```

---

#### GetResult() : REF_TO Deserializer

Returns reference to the Deserializer containing parsed data. Only valid when `IsComplete()` returns TRUE and `GetState()` returns Completed.

**Returns:**
- `REF_TO Deserializer` - Reference to parsed data, or NULL if not completed

**Example:**
```iec-st
IF parser.IsComplete() AND parser.GetState() = ParseState#Completed THEN
    result := parser.GetResult();
    // Use result->TryParse(...) to extract values
END_IF;
```

---

#### GetErrorMessage() : STRING

Returns error description if state is Error.

**Returns:**
- `STRING` - Error message, empty string if no error

---

#### GetState() : ParseState

Returns current parser state.

**Returns:**
- `ParseState` - Current state (Idle, Parsing, Completed, or Error)

---

#### Reset

Cancels current parsing operation and returns parser to Idle state. Call this to abort parsing and start fresh.

**Example:**
```iec-st
// Abort parsing
parser.Reset();
// Start new parse
parser.Start(REF(newBuffer));
```

## Usage Example

Complete example showing async JSON parsing:

```iec-st
USING Simatic.Ax.Json;
USING Simatic.Ax.Conversion;

TYPE
    ParseSteps : (Idle, Start, ProcessLoop, Done);
END_TYPE

PROGRAM AsyncParseExample
    VAR
        parser : AsyncJsonDeserializer;
        buffer : ARRAY[0..9999] OF CHAR;
        jsonData : STRING := '{"name": "test", "value": 123}';
        result : REF_TO Deserializer;
        parsedValue : INT;
        step : ParseSteps;
    END_VAR
    
    CASE step OF
        ParseSteps#Idle:
            // Convert string to character array
            Strings.ToArray(str := jsonData, arr := buffer);
            
            // Configure and start parsing
            parser.CharsPerCycle := 50; // 50 chars per cycle
            parser.Start(REF(buffer));
            
            step := ParseSteps#ProcessLoop;
            
        ParseSteps#ProcessLoop:
            // Process one chunk per cycle
            parser.Process();
            
            // Check if complete
            IF parser.IsComplete() THEN
                IF parser.GetState() = ParseState#Completed THEN
                    // Get result and parse values
                    result := parser.GetResult();
                    result^.TryParse('value', parsedValue); // parsedValue = 123
                ELSE
                    // Handle error
                    errorMsg := parser.GetErrorMessage();
                END_IF;
                step := ParseSteps#Done;
            END_IF;
            
        ParseSteps#Done:
            // Parsing complete
            ;
    END_CASE;
END_PROGRAM
```

## Performance Considerations

- **CharsPerCycle**: Adjust based on your PLC's cycle time budget. Higher values = faster completion but longer cycles.
- **Memory**: Each AsyncJsonDeserializer instance requires ~50 bytes internal state.
- **Reset**: Call `Reset()` before starting a new parse to ensure clean state.

## See Also

- [JsonDocument](JsonDocument.md)
- [JsonObject](JsonObject.md)
- Deserializer class (synchronous parsing)