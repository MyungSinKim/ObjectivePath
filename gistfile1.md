# CObjectPath

More fiddly key value paths.

    Foo.bar.#0.(foo,bar).{predicate}.%@."foo".'bar'.(#0-#100).%^.r".*"

Components

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