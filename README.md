Spritely
========

[![Build Status](https://travis-ci.org/agrobbin/spritely.svg?branch=master)](https://travis-ci.org/agrobbin/spritely)
[![Code Climate](https://codeclimate.com/github/agrobbin/spritely.png)](https://codeclimate.com/github/agrobbin/spritely)
[![Dependency Status](https://gemnasium.com/agrobbin/spritely.svg)](https://gemnasium.com/agrobbin/spritely)

Spritely is a very small gem that hooks into the Rails asset pipeline to allow you to easily generate sprite maps.

See the [list of releases](https://github.com/agrobbin/spritely/releases) for changes in each version.

## Is this production-ready?

Absolutely not. The only reason that I've released it so early is because I wanted to snag the spritely gem name on RubyGems. I will bump the version number to 0.1.0 when I am confident it can be used in production environments.

## Why should I use this?

I created Spritely because of issues when attempting to use Compass' spriting. All I wanted was to have something pull in a bunch of images, and keep track of where each image is located in the sprite. Compass does a lot of great stuff, but issues when upgrading Rails to new versions (particularly 4.0 and then 4.1) kept driving me nuts, so I decided to take a shot at a small, very lightweight gem that does the minimal amount possible to sprite images for me. Spritely is that lightweight gem!

I want to add that the Compass codebase helped me out tremendously while figuring out the best way to use ChunkyPNG for the PNG generation. So to everyone who has worked on Compass, thank you!

## Installation

Add the gem to your gemfile

```ruby
gem 'spritely'
```

Add the following to your gitignore

```
app/assets/images/sprites
```

This directory will be created in your deployed environments when precompiling assets.

## Usage

### In Sass/Scss files

```scss
$application-sprite: spritely-map('applications/*.png');

#icon {
  background: {
    image: spritely-url($application-sprite);
    position: spritely-position($application-sprite, "icon");
  }
  width: spritely-width($application-sprite, "icon");
  height: spritely-height($application-sprite, "icon");
}
```

This should result in the files in `images/application` matching `*.png` (within each sprockets asset path) being loaded into the sprite file that will be saved at `app/assets/images/sprites/application.png`. The compiled CSS should look something like this:

```css
#icon {
  background-image: url(/assets/sprites/application.png);
  background-position: 0 25px;
  width: 20px;
  height: 20px;
}
```

### Busting the cache

I have yet to figure out the "smart" way to correctly bust the sprite cache when the images themselves change without any corresponding change to Sass/Scss files. 9 times out of 10, this is not a problem, as a change to a sprited image will be accompanied by changes to CSS in your application. However, that is not always the case. When an image itself is the only change required, you have to force the sass cache to be busted. The simplest way to do this is to have an extra option in your `spritely-map` initialization:

```scss
$application-sprite: spritely-map('applications/*.png', $version: 1);
```

If you have managed to figure out a more intelligent way of doing this with no input from the user, please [issue a pull request](https://github.com/agrobbin/spritely/pulls)!

### Repetition

Assuming file `background.png` in `app/assets/images/application`, you can repeat the image horizontally by passing the following keyword arguments.

```scss
$application-sprite: spritely-map('application/*.png', $background-repeat: true);
```

### Spacing

There are sometimes cases where you want to add some extra spacing (or padding) to a particular image in your sprite. To do so for an image named `foo.png`:

```scss
$application-sprite: spritely-map('application/*.png', $foo-spacing: 10px);
```

This will add 10 pixels of padding to the bottom of `foo.png` within the sprite.

#### Global spacing

If you want to add space between all images in a sprite, rather than specifying `$*-spacing` keyword arguments for every image, Spritely provides a global option.

```scss
$application-sprite: spritely-map('application/*.png', $spacing: 10px);
```

This will add 10 pixels of spacing between every image in the sprite.

*Note that per-image spacing options will override the global spacing option.*

## Tests

```bash
rspec spec
```

Spritely uses Appraisal to test against multiple versions of Rails. See their [README](https://github.com/thoughtbot/appraisal) for more information on how to run a particular suite.
