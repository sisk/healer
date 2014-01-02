# Healer

Application to support humanitarian surgical missions.

## Get it running

Healer is a Rails 3 application. You should be able to use bundler to get things ready.

```
$ bundle
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

## Running tests

Tests are built with Rspec and live in spec/v1. ```bundle exec rspec spec/v1``` runs the full suite.

## V1 vs. "Legacy" development

As of December 2013, work is underway to rewrite the application in place. As such, there's a lot of code in play that is in the process of being deprecated/rewritten/removed. All *new* code lives in the V1 namespace. Anything in that namespace should be assumed to be tested to current standards.

There's a lot of cruft/deprecated code and tests outside the V1 namespace which is not guaranteed to work. Caveat emptor.