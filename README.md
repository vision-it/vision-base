# vision-base

[![Build Status](https://travis-ci.com/vision-it/vision-base.svg?branch=production)](https://travis-ci.com/vision-it/vision-base)

## Parameter

## Usage

Include in the *Puppetfile*:

```
mod 'vision_base',
    :git => 'https://github.com/vision-it/vision-base.git,
    :ref => 'production'
```

Include in a role/profile:

```puppet
contain ::vision_base
```
