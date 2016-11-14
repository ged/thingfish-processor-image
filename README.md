# Thingfish-Processor-Image

home
: http://deveiate.org/projects/Thingfish-Processor-Image

code
: http://bitbucket.org/ged/Thingfish-Processor-Image

github
: https://github.com/ged/thingfish-processor-image

docs
: http://deveiate.org/code/thingfish-processor-image


## Description

This is a basic image-processor plugin for the Thingfish digital asset manager.
It extracts image-related metadata from uploaded media files, and generates one
or more thumbnail images as related resources.


## Authors

* Michael Granger <ged@FaerieMUD.org>


## Installation

This plugin relies on [ImageMagick](http://www.imagemagick.org/), so you'll
need to have that installed as well as any `-dev` dependencies appropriate for
your system.

One you've done that:

    $ gem install thingfish-processor-image


##  Usage

As with Thingfish itself, this plugin uses
Configurability[https://rubygems.org/gems/configurability] to modify default
behaviors.

Here's an example configuration file that enables this plugin.

    --
    thingfish:
      processors:
        - image
    
    images:
      thumbnail_dimensions: 150x150



## Contributing

You can check out the current development source with Mercurial via its
{project page}[http://bitbucket.org/ged/thingfish-processor-image]. Or if you prefer Git, via 
{its Github mirror}[https://github.com/ged/thingfish-processor-image].

After checking out the source, run:

    $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the API documentation.


## License

Copyright (c) 2016, Michael Granger
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the author/s, nor the names of the project's
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


