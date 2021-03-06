# Rhapsody Web Application

### Team Members: 
- James (Jamie) Kuesel
- Hartley (Jim) Howe
- Olivia Blier
- Jaime Kvaternik

## Project Idea: 
In this project, we will be creating Rhapsody, a single-page application in conjunction with the Spotify API. Our
application will allow users to create groups with each other and
create Spotify playlists based on the group’s top tracks and artists,
within the genres of their choice. Users can decide to create these
groups for whatever occasion or just for fun. It is perfect for
creating a party or road trip playlist! The Spotify API grants us
access to the user’s top tracks and artists, as well as reading or
modifying any public or private playlist. For this project, we’ll only
need to modify public playlists — which will be handled by the scopes
(or permissions) we select. 

## API:
The Spotify Web API is our chosen API for this project. Spotify
has a very succinct and encompassing Web API to access Spotify
features. It requires an OAuth2 authorization flow to receive an
access token, which is used to access Spotify features such as search,
get top tracks, read playlists, modify playlists, etc. This OAuth2
authorization flow will be carried out using the Elixir OAuth2
dependency that is mentioned in the lectures. Furthermore, any other
requests to the Spotify Web API will use Elixir and the OAuth2 access
token. 

For further documentation and guides, here is a link to the Spotify
Web API: https://developer.spotify.com/documentation/web-api/

## Features:

### Realtime & Database: 
Rhapsody will create realtime groups and provide
updates based on group removals and additions. Users can join groups
via a link that contains the id of the group. When they go to this
link, they will see who the other members of the group are, and be
able to specify information about the playlist (for example, genre).
When all of the desired group members have joined and the genres are
selected, a playlist can be generated by clicking a “Make playlist”
button. This will, in real time, generate a playlist by communicating
with the Spotify API, and display it for all group members to see. 

In order to build this application, a number of things will need to be
stored in the Postgres database. Of course, there will be a Users
table that stores the username and password hash of all of the apps
users. When you make an account with Rhapsody, your user information
will be inserted into this table. In addition to users, we will also
have a Groups table to keep track of which users are in which group.
There can be an unlimited number of users in every group. Once a group
decides on what genres they want, they can choose to generate a
playlist. Once they do this, the resulting playlist will be added to a
Playlist table. The playlist table will store the playlist information
given from the API request, as well as the id of the group that it is
associated with. 

### Something Neat..: 
Using Rhapsody, users can create groups of friends
and request a playlist based on the collective groups’ interests. Our
front-end client will allow users to create groups and add friends to
their groups. After they’ve created a group, users can request for a
playlist. Upon receiving this request, we will send a GET request to
Spotify’s API to gather each user’s top tracks and artists. Then,
these will be handled by our Elixir-based backend to create a mix of
tracks and then sent to Spotify in a POST request. The mix of tracks
will be based on not only the top songs from the group members, but
also on the genre information that they provide about the type of
playlist they want. Using an algorithm we will create, the users will
be given a playlist that is a personalized mix of everyone in the
group’s favorite songs and the requested genres. As a result of the
POST request, the playlist will appear on a user’s Spotify account and
be displayed in the web application.


## Experiments:

### Experiment 1. 
**Using Oauth2 to authenticate users through the Spotify API:**

For our first experiment, we worked on allowing users to sign in and
authenticate with their Spotify accounts. Spotify’s API uses an OAuth2
workflow to authenticate users. In this experiment, we attempted to
implement the OAuth2 protocol by looking at his lecture notes from
Week 15 and his bug_bot Github repo — which uses the Github’s
authorization workflow and follows the OAuth2 Elixir dependency.
Additionally, we reviewed OAuth2’s documentation for creating our
authentication strategy.

Initially, we had great difficulty figuring out how to set up the
OAuth2 strategy and apply it to Spotify’s authentication pattern. At
first, we successfully created an app on Spotify's Developer dashboard
and got the client information. We also deemed this to be a good time
to add the logic for creating sessions and used lecture code to create
users and sessions on the server and database. Then, we attempted to
use the OAuth2 dependency to develop a strategy to get the
authentication and callback workflows working. However, this was more
of a problem than we anticipated. We weren’t fully aware of how to
implement the OAuth workflow using both React and Elixir. We found
examples online that used the Phoenix framework and could understand
the intended workflows, but were unable to replicate it in a single
page application framework. Eventually, we decided to replicate
authentication in another way, and revisit it next week after we learn
more about OAuth2 in lecture.

For the sake of the experiments, we implemented an authentication
workflow using React.js. Upon load, the user can click on a link which
will redirect the user to the Spotify authentication dialog. Then,
Spotify redirects users back to our development server by the callback
URL we added to the app. After granting our application access, we
display the access token to the user. For the sake of the experiment
and the following experiments, we needed this authentication token so
we chose to display it on the screen and test our Elixir backend using
this token and the terminal.  

Note: We intend on remodeling this after learning more about OAuth
next week in lecture. This fix was created to proceed and test our API
in our other experiments.

### Experiment 2: 
**Pulling a list of a users top songs with the “user-top-read” 
endpoint:**

In our second experiment, we tested out a piece of the core
functionality for our app, pulling users top songs from their Spotify
accounts. To do this we used the “user-top-read” endpoint from the
“Personalization API”, which returns a user’s top artists or top
tracks. The requests to this endpoint require the user’s
authentication token, a type of entity to return (artists or tracks),
and optionally a time range over which “top results'' is calculated, a
number of entities returned, and an offset.

This experiment was a success! One of our group members (Jaime) was
able to authenticate to his own Spotify account, and then make an API
request to receive his top five tracks. We were able to then parse the
JSON response and print out the names of the songs in a list on Elixir
terminal.

This experiment showed us that our core idea of pulling top songs from
users and then using them for future work is possible, and showed us
the range of options provided by the Spotify API. In the actual
implementation of our application, we will be customizing the request
more in order to get a more tailored response, and we confirmed that
this will be possible in this experiment. This experiment was also our
first time interacting with the API apart from authentication, and it
was very easy to use! We became much more familiar with the
development tools on the website and with the documentation in
general. We now have more confidence going forward with using the
Spotify API for pulling user top tracks, as well as more advanced
requests that we may need to do.

### Experiment 3: 
**Pulling a list of song recommendations based on tracks, artists, or 
genres:**

To expand on our previous experiment, we decided to try out a few more
gets from Spotify. We figured getting recommendations would be a good
experiment. Spotify’s API takes in four arguments for getting
recommendations: an access token, seed_artists, seed_tracks, and
seed_genres. The seeds guide Spotify’s API to spit out suggestions
relevant to those seeds. We initially had some trouble with this
specific function as we wanted to adjust for if those seeds were null
(nil). We were confused on how exactly mutation worked in elixir
because we wanted to either assign a URI encode of each seed or an
empty string if nil. This is because the url we had to pass into
Spotify’s API had to include all three seeds. After a bit of research,
we found out that we could assign a variable to an if statement in
Elixir. This worked perfectly for our purposes. After we assigned each
variable, we contactinated our URL with our seeds and then passed it
to the Spotify API with a HTTPoison request.

In order to make this readable, we decided to put it into a map of
song recommendations that would include the name of the song and its
ID, and then a nested map of the artist’s id and name. This way, we
could easily identify and use these parameters in the future.

We consider this experiment a great success! We learned how to
effectively communicate with Spotify’s API and extract the exact
information we needed. We tested the `get_recommendation` functionality
by seeding the request with both the song IDs that we pulled in
Experiment 2, as well as genres from Spotify's list of available genres 
through `get_recommendation_genres`. This allowed us to confirm that we
will be able to combine the different types of seeds to get the kind
of tailored recommendations that we will need in order to produce
playlists in the way we want. We also investigated the documentation
for the request, and saw that there is plenty of room for us to
customize our requests based on user input or other data that we
choose to pull from a user’s listening history. We now know that we
can apply this process to a wide variety of other use cases depending
on if we decide to add any additional features to our App that require
requesting more information.

## Users: 
We expect to have mostly current Spotify users for our app.
Those who do not have a  Spotify account would need to create a
Spotify account before they can use our app. This is also great for
Spotify, as our app can add an extra dimensionality to their
ecosystem. It may convince some users on other platforms to switch or
create a Spotify account. Anyone who wants a new way to share music
with friends and create group playlists should try out Rhapsody! 

## User Workflow: 
Our anticipated user workflow is as follows: Joe and
Alice are friends who both use spotify, and want to create a playlist
that they both enjoy for an upcoming road trip. Both Joe and Alice
make an account on Rhapsody, and authenticate to their Spotify
accounts. Now that they both have an account, Joe searches for Alice’s
username (or vice versa), and invites her to join his Rhapsody group
‘roadtrippers’. Alice see’s the invite and joins. Now that they are in
a group together, either one of them can choose a genre for the
playlist they want to create, like “happy”, “pop”, “guitar”, or
“detroit techno”. Rhapsody will then choose songs that best match the
chosen genre as well as Alice and Joe’s ‘most popular songs’, and 
create one playlist of a specified length. They then have the option of 
copying this playlist back down to their own Spotify libraries, and 
sharing it with friends! More users can join the group at any time and 
decide to re-create the group playlist, now using the new user(s) top 
songs as well. The group owner can decide to disband the group at 
any time. Groups will stick around for as long as users want.

