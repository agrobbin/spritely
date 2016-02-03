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

### Available directives

There are a few different sprite map directives available to you. Some directives are available as both global and per-image directives while others are just per-image. Per-image directives overwrite global directives.

Global directives are set just like per-image ones are, except they don't include an image name.

#### Repetition (per-image only)

You can repeat the image horizontally. To do so for an image named `arrow.png`:

```
//= repeat arrow true
```

#### Positioning (global and per-image)

When you want to use a sprited image on the right-hand side of an element, it's useful to position that image to the absolute right of the sprite map. To do so for an image named `arrow.png`:

```
//= position arrow right
```

To do it for all images in a sprite map:

```
//= position right
```

The default value is `left`.

#### Spacing (global and per-image)

There are sometimes cases where you want to add some extra spacing (or padding) to images in your sprite. To do so for an image named `arrow.png`:

```
//= spacing arrow 10
```

This will add 10 pixels of padding to the bottom of `arrow.png` within the sprite.

To do it for all images in a sprite map:

```
//= spacing 10
```

## Tests

```bash
rspec spec
```

Spritely uses Appraisal to test against multiple versions of Rails. See their [README](https://github.com/thoughtbot/appraisal) for more information on how to run a particular suite.
