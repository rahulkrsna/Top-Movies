# Project 1 - *Top-Movies*

**Top-Movies** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **10** hours spent in total

## User Stories

The following **required** functionality is complete:

- [X] User can view a list of movies currently playing in theaters from The Movie Database.
- [X] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [X] User sees a loading state while waiting for the movies API.
- [X] User can pull to refresh the movie list.
- [X] User can view movie details by tapping on a cell.
- [X] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [X] Customize the selection effect of the cell. 

The following **optional** features are implemented:
- [X] User sees an error message when there's a networking error.
- [X] Movies are displayed using a CollectionView instead of a TableView.
- [X] User can search for a movie.
- [X] All images fade in as they are loading.
- [X] Customize the UI.
- [X] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [X] Customize the navigation bar.

The following **additional** features are implemented:
- [X] Collection View cell size(width, height) calculated dynamically so as to fit only two cells horizantally on iphone of any size.
- [X] Cache data is invalidate after 100ms, so that network error is shown on refresh of the app.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. 
2.

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/WqZ4eeN.gif' title='Video Walkthrough' width='' alt='Top-Movies' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Image loading sometimes takes time. So the view is created without the poster of the movie only on refresh(scrolling up and down) the posters are shown.
Image has been going out of the image view area. I have resolved that by fixing the image view width and height.
It took sometime in understanding the constraints to be given to the views.
It got some help from the mentor on how to manipulate the cell location and size(width, height) dynamically and implemented the same.
Once I have started putting on the animations, view started to load slow, reduced the time of loading, shifted from low resolution to high resolution images whenever possible.

## License

    Copyright [2016] [Rahul Krishna Vasantham]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at