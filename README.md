# FFXI Targeter

*Note: This is a work in progress.*

An FFXI Windower 4 addon that targets the nearest enemy to you based on a target list.

*Use case:* In Dynamis Divergence, quickly target the closest statue amongst other enemies, even if it is right behind you.

## Load

`//lua load targeter`

## Setting a target

`//targ add aurix` or `//targ a aurix` adds aurix to the target list.

Simply running `//targ add` will add the currently selected target to the target list.

## Target an enemy

`//targ target` or `//targ t` targets the nearest enemy to you from the target list.

## Removing a target

`//targ remove aurix` or `//targ r aurix` removes aurix from the target list.

Simply running `//targ remove` will remove the currently selected target remove the target list.

## Display the target list

`//targ list` or `//targ l`

## Display Targeter help

`//targ` or `//targ help`

## Target sets

You can save sets of targets for future use. For example, you can set up a target set for Dynamis Divergence statues with the following:

```
//targ add corporal tombstone
//targ add lithicthrower image
//targ add incarnation idol
//targ add impish statue
//targ save statues
```

In the future, use the following to switch to the saved set:

`//targ load statues`

## Contributing

If you notice something not quite right, please [raise an issue](https://github.com/xurion/ffxi-targeter/issues).

Or better yet, [pull requests](https://github.com/xurion/ffxi-targeter/pulls) are welcome!
