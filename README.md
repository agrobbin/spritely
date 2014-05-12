Spritely
========

[![Build Status](https://travis-ci.org/agrobbin/spritely.svg?branch=master)](https://travis-ci.org/agrobbin/spritely)

Spritely is a very small gem that hooks into the Rails asset pipeline to allow you to easily generate sprite maps.

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

## Tests

```bash
rspec spec
```

## Usage

### In Sass/Scss files

```scss
$application-sprite: sprite-map('applications/*.png');

#icon {
  background: {
    image: sprite-url($application-sprite);
    position: sprite-position($application-sprite, "icon");
  }
  width: sprite-width($application-sprite, "icon");
  height: sprite-height($application-sprite, "icon");
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
