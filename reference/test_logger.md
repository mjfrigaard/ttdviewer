# Test Logger (Test Utility)

Emits structured log messages to the test output, suitable for
bracketing test blocks with start/end markers.

## Usage

``` r
test_logger(start = NULL, end = NULL, msg)
```

## Arguments

- start:

  Optional character string for the start-of-test label.

- end:

  Optional character string for the end-of-test label.

- msg:

  Character string for the log message body.

## Value

Called for its side-effect of writing to the log output.
