[Article as appeared in the [December 2018 issue of eForensics](https://eforensicsmag.com/download/social-media-forensics/).]

# Facebook data forensics

Given
[all of](https://www.theguardian.com/news/2018/mar/17/cambridge-analytica-facebook-influence-us-election)
the
[recent](https://www.bbc.com/news/technology-46231284)
issues
[around Facebook](https://www.bbc.com/news/technology-43649018)
and the data it keeps about
[all of us](https://www.consumerreports.org/digital-security/what-makes-the-facebook-data-breach-so-harmful/)
it seemed like a good time for a tool to help us analyze the data dump Facebook is
[willing to give us](https://www.facebook.com/help/1701730696756992?helpref=hc_global_nav).
The tools I have written give you an overview of what Facebook has collected about you.
You can also see how many messages you have sent to each recipient and look for keywords
in your message history.

[This toolset](https://github.com/chicks-net/fbdata-forensics) was originally written
to help a friend comb through their Facebook data dump, but after a few months to think
about it I decided to simplify the process and document how to use it.  Now that
Facebook is providing data in JSON format it is much easier to process using software.
There are good reasons to work with this data in JSON format even if you have no desire
to import it into a new social network.

So far I have only tested this rewrite on my own data, but I am happy to work with
[bug reports](https://github.com/chicks-net/fbdata-forensics/issues).
It seems like a bad idea to have people sending me their personal data to
help debug things so I hope someone will create a sock puppet on Facebook and get
a download of the data for that account.  That should let us treat that dataset as
public info.  From there it is easier to build unit tests using public tools and
not risk any secrets in the process.  Until the sock puppet data is available I ask
that you just include the error message initialy and if I need to see the JSON
itself I will ask for it in the issue tracker and it can be sent through a different
channel.

## Installation

If you have Perl 5 installed you only need to add a couple of modules:
the [`JSON::MaybeXS`](https://metacpan.org/pod/JSON::MaybeXS) module and one of
the three JSON modules it supports.  To get this on CentOS 7 I would run:

	yum install perl-JSON-MaybeXS perl-JSON-XS

In Debian or Ubuntu this should work:

	apt-get install libjson-maybexs-perl libjson-xs-perl

Once you have got that pre-requisite out of the way somehow you need to clone this repo:

	git clone https://github.com/chicks-net/fbdata-forensics.git
	cd fbdata-forensics

## Using

### Get your data

Get your data [from Facebook](https://www.facebook.com/help/1701730696756992?helpref=hc_global_nav).
Ask for it as JSON since this tool does not process the HTML flavor of the data
download.  Most reports I have found of the data say it takes 2-4 hours to be
ready, but for me it took 28 hours!  They did send me a notfication when it was done,
but a better indication of progress or how long it would take would have been nice.

![pick JSON](img/pick_json.png)

Facebook gives you a file like `facebook-username.zip`.
I would rename it to `facebook-username-YYYMMDD.zip` so you can compare how data
changes through time.
So for me it ends up being `facebook-chicks-20181118.zip`.

One of the limitations of the data downloads from Facebook is that people
who delete their accounts become renamed in your download to "Facebook User".
Sometimes you can figure these things out from context, but it will be even easier
on you if you have a copy of your data from a year ago and you can see the
name of the person without sleuthing.

If you are going to download your data periodically and keep it for the long haul
it would be a good idea to encrypt it also.

### Unpack your data

Within a copy of this repo create a directory like `data.username`.  For me
`data.chicks` would be created by

	mkdir data.chicks

So you should have something like this if you `ls`:

	data.chicks  html_v0.1  img  json-counts  json-messages  keywords.txt  LICENSE  TODO.md

NOTE: Any `data.*` directory will be hard to add to git because it is intentionally in the
[`.gitignore`](.gitignore).

Then unpack your data into that directory:

	cd data.chicks
	unzip ~/Downloads/facebook-chicks-20181118.zip
	# unzip does its bit
	cd ..
	# you should be back in the top dir of this repo again

After this you should be back in the top dir of this repo again.

### Data overview

To get a high-level overview run `./json-counts` with a directory of Facebook data prepared
as mentioned in the previous section.  For example:

	fbdata-forensics$ ./json-counts data.chicks
	data.chicks looks like a Facebook data dump
	- 0 marketplace entries
	- 0 saved_items entries
	... skipping about_you/face_recognition.json which isn't generic enough for here
	... skipping about_you/friend_peer_group.json which isn't generic enough for here
	... skipping about_you/your_address_books.json which isn't generic enough for here
	- 0 ad interests entries
	- 0 advertiser uploaded contact entries
	- 4 advertiser touched entries
	- 6 installed_apps entries
	- 361 app_post entries
	- 79 comment entries

### Search messages

Edit the [`keywords.txt`](keywords.txt) file to contain the words to dig for in your messages.
Then run `./json-messages` with a directory of Facebook data like so:

	fbdata-forensics$ ./json-messages data.chicks/
	data.chicks/ looks like a Facebook data dump
	- 107 conversations found in Facebook Messages
	+ 1 messages with Abe Jones (inbox)
	$keyword_matches = {};
	+ 1 messages with Alex Smith (inbox)
	$keyword_matches = {};
	+ 6 messages with Bob Smith (inbox)
	$keyword_matches = {};
	+ 1 messages with Carol Jones (inbox)
	$keyword_matches = {};


## Author

[Christopher Hicks](http://www.chicks.net) is the primary author of this project.
He has gotten lots of assistance and wonderful feedback so noone
is pretending they are doing it all alone.

Christopher has been doing systems administration and programming for 25 years.
He has worked for Yahoo, OpenX, and BrightRoll helping keep thousands of
servers monitored and ready for users.
To give back to the free software community Christopher has answered questions
on [ServerFault and other StackExchange sites](https://stackexchange.com/users/2276315/chicks)
that have been read by hundreds of thousands of people.
