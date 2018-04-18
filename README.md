Spritely
========

[![Build Status](https://travis-ci.org/agrobbin/spritely.svg?branch=master)](https://travis-ci.org/agrobbin/spritely)
[![Code Climate](https://codeclimate.com/github/agrobbin/spritely.png)](https://codeclimate.com/github/agrobbin/spritely)
[![Dependency Status](https://gemnasium.com/agrobbin/spritely.svg)](https://gemnasium.com/agrobbin/spritely)

Spritely hooks into the Sprockets asset packaging system to allow you to easily generate sprite maps.

See the [list of releases](https://github.com/agrobbin/spritely/releases) for changes in each version.

## How does it work?

Spritely provides a [Sprockets](https://github.com/rails/sprockets) preprocessor and transformer. It hooks into the processing stage of Sprockets compilation to generate a sprite image from a manifest file (in a very similar way to how `application.css` is processed). Several Sass functions are defined that are included into all other Sass scripting functions. If the image has not been generated (or is outdated), a request for the sprite will determine how to lay out the sprite, and then generate the image via ChunkyPNG, storing it in the Sprockets cache like all other compiled assets.

## Installation

Add the gem to your gemfile

```ruby
gem 'spritely'
```

## Usage

### Manifest file

Spritely takes advantage of Sprockets directives to define how a sprite should be generated. If you want to create a sprite map called `application`, create a `app/assets/images/sprites/application.png.sprite` manifest file. If you want just a default sprite map, leave the file blank. Otherwise, add any number of directives to the file (available directives are outlined below).

### Stylesheet

If you aren't doing anything special, you can use a Spritely-provided Sass mixin:

```scss
#icon {
  @include spritely-image("application", "icon");
}
```

The compiled CSS should look something like this:

```css
#icon {
  background-image: url(/assets/sprites/application.png);
  background-position: 0 25px;
  width: 20px;
  height: 20px;
}
```

Otherwise, you can use the Spritely Sass functions directly:

```scss
#icon {
  background: {
    image: spritely-url("application");
    position: spritely-position("application", "icon");
  }
}
```

The compiled CSS should look something like this:

```css
#icon {
  background-image: url(/assets/sprites/application.png);
  background-position: 0 25px;
}
```

### Busting the cache

Spritely utilizes Sprockets' `depend_on` and `link_asset` directives to listen to changes to existing images within a sprited folder. This, in addition to the cache being busted upon related stylesheet changes, takes care of 99 out of 100 cases of image changes.

### Configuration directives

You can customize the configuration of your sprite map by using these global directives.

#### Directory

If you have sprite images that are stored in a different location than the default (`app/assets/images/[sprite-name]`), you can override the directory that Spritely looks for images to sprite. To do so when a sprite's images are stored in `app/assets/images/foo/bar`:

```
//= directory foo/bar
```

#### Sorting

You can sort images in the sprite based on `name`, `width`, `height`, or `size`:

```
//= sort width
```

To reverse the order, add a direction:

```
//= sort width desc
```

The default is `name` (`asc` is the default direction).

### Image directives

There are a few different image-related sprite map directives available to you. All of these are available as both global and per-image directives. Per-image directives overwrite global directives. Global directives are set just like per-image ones are, except they don't include an image name.

#### Repetition

You can repeat the image horizontally. To do so for an image named `arrow.png`:

```
//= repeat arrow true
```

Note: While repetition can be done globally, you should exercise caution. If your globally-repeating sprite map has multiple oddly-shaped images (rather than small images like background tiles), your sprite map could get very large, and its generation/loading could severely slow down your computer. This is because, to correctly fill the space with whole copies of each image, Spritely has to determine the least common multiple of all repeated images. This means that for a sprite map with 4 repeating images with widths of `[35px, 327px, 250px, 200px]`, your sprite will need to be `2289000px` wide.

#### Positioning

When you want to use a sprited image on the opposite side of an element, it's useful to position that image to the right/bottom (depending on the `direction`) of the sprite map. To do so for an image named `arrow.png`:

```
//= opposite arrow true
```

To do it for all images in a sprite map:

```
//= opposite true
```

#### Spacing

There are sometimes cases where you want to add some extra spacing (or padding) above or below images in your sprite. To do so for an image named `arrow.png`:

```
//= spacing_before arrow 5
//= spacing_after arrow 10
```

This will add 5 pixels of spacing before `arrow.png` and 10 pixels of spacing after `arrow.png` within the sprite.

To do it for all images in a sprite map:

```
//= spacing_before 5
//= spacing_after 10
```

## Tests

```bash
rspec spec
```

Spritely uses Appraisal to test against multiple versions of Rails. See their [README](https://github.com/thoughtbot/appraisal) for more information on how to run a particular suite.
