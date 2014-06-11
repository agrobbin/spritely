Spritely
========

[![Build Status](https://travis-ci.org/agrobbin/spritely.svg?branch=master)](https://travis-ci.org/agrobbin/spritely)
[![Code Climate](https://codeclimate.com/github/agrobbin/spritely.png)](https://codeclimate.com/github/agrobbin/spritely)
[![Dependency Status](https://gemnasium.com/agrobbin/spritely.svg)](https://gemnasium.com/agrobbin/spritely)

Spritely is a very small gem that hooks into the Rails asset pipeline to allow you to easily generate sprite maps.

See the [list of releases](https://github.com/agrobbin/spritely/releases) for changes in each version.

## Why should I use this?

I created Spritely because of issues when attempting to use Compass' spriting. All I wanted was to have something pull in a bunch of images, and keep track of where each image is located in the sprite. Compass does a lot of great stuff, but issues when upgrading Rails to new versions (particularly 4.0 and then 4.1) kept driving me nuts, so I decided to take a shot at a small, very lightweight gem that does the minimal amount possible to sprite images for me. Spritely is that lightweight gem!

I want to add that the Compass codebase helped me out tremendously while figuring out the best way to use ChunkyPNG for the PNG generation. So to everyone who has worked on Compass, thank you!

## Installation

Add the gem to your gemfile

```ruby
gem 'spritely'
```

Run the generator to update your gitignore

```bash
bundle exec rails generate spritely:install
```

This directory will be created in your deployed environments when precompiling assets.

## Usage

### In Stylesheets

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

Spritely utilizes Sprockets' `depend_on` and `depend_on_asset` directives to listen to changes to existing images within a sprited folder. This, in addition to the cache being busted upon related stylesheet changes, should take care of 99 of out 100 cases of image changes.

The one case this does *not* currently account for is when new files are added to the sprited image folder without corresponding changes to stylesheets. This should be a rare occurrence (more often then not, a new image in the sprite map will be accompanied by changes/additions to stylesheets), but in this case, you will need to forcefully bust the cache. The simplest way to do this is to have an extra option in your `spritely-map` initialization:

```scss
$application-sprite: spritely-map('applications/*.png', $version: 1);
```

### Available Options

There are a few different sprite map configuration options available to you. Some options are available as both global and per-image options while others are just per-image. Per-image options overwrite global options.

Global options are set just like per-image ones are, except they don't have an image name prefix.

#### Repetition (per-image only)

You can repeat the image horizontally by passing the following keyword arguments:

```scss
$application-sprite: spritely-map('application/*.png', $background-repeat: true);
```

#### Positioning (global and per-image)

When you want to use a sprited image on the right-hand side of an element, it's useful to position that image to the absolute right of the sprite map. To do that for an image name `arrow.png`:

```scss
$application-sprite: spritely-map('application/*.png', $arrow-position: right);
```

The default value is `left`.

#### Spacing (global and per-image)

There are sometimes cases where you want to add some extra spacing (or padding) to a particular image in your sprite. To do so for an image named `foo.png`:

```scss
$application-sprite: spritely-map('application/*.png', $foo-spacing: 10px);
```

This will add 10 pixels of padding to the bottom of `foo.png` within the sprite.

## Tests

```bash
rspec spec
```

Spritely uses Appraisal to test against multiple versions of Rails. See their [README](https://github.com/thoughtbot/appraisal) for more information on how to run a particular suite.
