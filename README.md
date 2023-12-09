# Fast list class implementation based on native arrays
This is a very fast implementation of a generic list. Shares some interface
with `TFPGList`, but is _a lot_ faster. Uses native pascal array under the hood
instead of linked list.

It is all about performance, so some things are deliberately not checked, like
for example getting out of bounds of the array. Anything past index `Count - 1`
is either unallocated or garbage, but there are no safety checks for that.

In addition to that, since it's not a linked list, performance will suffer when
elements are added or removed near the beggining. All the elements must be
copied - `O(n)`, while in a linked list this operation will be `O(1)`. Use
other list if that's your use case.

## Code and documentation
See the contents of `src` directory. Documentation can be viewed inline or generated with pasdoc.

## Bugs and feature requests
Please use the Github's issue tracker to file both bugs and feature requests.

## Contributions
Contributions to the project in form of Github's pull requests are
welcome. Please make sure your code is in line with the general
coding style of the module. Let me know if you plan something
bigger so we can talk it through.

### Author
Bartosz Jarzyna <bbrtj.pro@gmail.com>

