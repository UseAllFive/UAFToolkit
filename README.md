Welcome to the UAFToolkit library. Please read this first if you're new or need a refresher.

## Documentation

To generate these docs, just do:

    cd [repo-root]
    appledoc .

That's it and you'll see these instructions when you succeed. Recursion, whoa.

Some packages of interest:

- `Boilerplate` - A collection of 'final' base classes that remove the
constructor boilerplate of various `UIKit` classes, especially when using IB.
Some classes have additional extensions that won't work in categories.

- `UI_Effects` - Macros for animation and UI related behavior. Also
see related protocols: <UAFToggledView>, etc.

- `UIKit_Layouts` - Custom layout extensions.
