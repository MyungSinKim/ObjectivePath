# Objective Path

## Overview

Even more fiddly key value paths.

    Foo.bar.#0.(foo,bar).{predicate}.%@."foo".'bar'.(#0-#100).%^.r".*"

Like [xpath](http://en.wikipedia.org/wiki/Xpath) for XML or [JSONPath](http://goessner.net/articles/JsonPath/) for JSON but purely for Cocoa objects.

## Notes

This is just a quick sketch of what the path format could look like and doesn't necessarily constitute a specification or documentation.

### Components

    Foo or "foo" or 'foo' - key lookup
    #0 - index lookup
    (foo,bar) - set of keys
    (#0,#1) - set of indexes
    {<predicate>} - NSPredicate
    %@ - key/index/predicate/block passed as parameter
    r"<pattern>" - regex
    %^ - block (use same block signature as predicate blocks) (vetoed just use %@)

* Optional: Foo.#0 can be expressed as foo#0 (vetoed bad idea)
* Compile into an executable object: CObjectPath
* Could use blocks internally?
* Good error reporting
* Use valueForKey: where appropriate
* Keys can be any kind of object. Index sets, and sets may be treated differently - outputting arrays instead of single values.
* How do we treat index sets & sets as non special?

### Recursion

Use ".." or perhaps "..." syntax to recurse through arrays and dictionary values.

    "...foo" - look for any key matching "foo"
    "...(foo,bar)"

## Implemented

* Key & index lookups.
* Sets (or rather lists, because order does matter)
* Predicate queries

## TODO

* Recursion
* More concise/familiar C array style path format "foo[0].bar[1]"
* Block queries
