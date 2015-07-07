rumbrl
======

[![Gem Version](https://badge.fury.io/rb/rumbrl.svg)](http://badge.fury.io/rb/rumbrl)
[![Dependency Status](https://gemnasium.com/behance/rumbrl.svg)](https://gemnasium.com/behance/rumbrl)
[![Code Climate](https://codeclimate.com/github/behance/rumbrl/badges/gpa.svg)](https://codeclimate.com/github/behance/rumbrl)

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

#### `LOG_APP_NAME`

Used by the formatter object to create a KV `APP_NAME=` string in the log entry. Full format is:

```
APP_NAME="#{ENV['LOG_APP_NAME']}::#{progname}"
```

Where `progname` is set in your logger.

The formatter is meant to be inherited from, you can implement your own version of `format_msg`. In conjunction with the `Smash` object, you can easily format objects into log entries that are readily consumed by [SumoLogic](https://www.sumologic.com/)
