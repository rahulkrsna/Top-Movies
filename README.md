# Project 1 - *Top-Movies*

**Top-Movies** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **6** hours spent in total

## User Stories

The following **required** functionality is complete:

- [ ] User can view a list of movies currently playing in theaters from The Movie Database.
- [ ] Poster images are loaded using the UIImageView category in the AFNetworking library.


The following **optional** features are implemented:


The following **additional** features are implemented:


## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://imgur.com/fWuFVWW' title='Video Walkthrough' width='' alt='TopMovies' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Image loading sometimes takes time. So the view is created without the poster of the movie only on refresh(scrolling up and down) the posters are shown.
Image has been going out of the image view area. I have resolved that by fixing the image view width and height.
It took sometime in understanding the constraints to be given to the views.


## License

    Copyright [2016] [Rahul Krishna Vasantham]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at