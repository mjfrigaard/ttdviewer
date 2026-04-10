# Test Logger (Test Utility)

Emits structured log messages to the test output, suitable for
bracketing test blocks with start/end markers.

## Usage

``` r
test_logger(start = NULL, end = NULL, msg)

test_logger(start = NULL, end = NULL, msg)
```

## Arguments

- start:

  test start message

- end:

  test end message

- msg:

  test message

## Value

Called for its side-effect of writing to the log output.

message to test output
