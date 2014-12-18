rumbrl
======

**R**eally d**UMB** **R**uby **L**ogger

So dumb you'll cry.

### API

Methods Delegated to `::Logger`:

- `datetime_format=`
- `log`
- `debug?`
- `error?`
- `fatal?`
- `info?`

Wrapped `::Logger` Methods:

- `debug`
- `info`
- `warn`
- `error`
- `fatal`
- `unknown`

### ENV vars

#### `LOG_PATH`

Directory where logs go

#### `LOG_SHIFT_SIZE` & `LOG_SHIFT_AGE`

Passed into [::Logger](http://www.ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html) (as `shift_age` & `shift_size`). Defaults to `1048576` & `weekly`, respectively.

#### `LOG_TIME_FORMAT`

Time format (`::Logger#datetime_format`). Defaults to `"[%F %T %z]"`

#### `LOG_DATA_FORMAT`

How to format log data. Defaults to `[%s] [%s]`
