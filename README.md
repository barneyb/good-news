# The Good News

An obnoxiously simple queued publishing platform comprised of a few shell
scripts and some text files for the queues.

## Setup

You'll need to create `hook_urls.txt` containing Slack WebHook URLs prefixed
with a key used to reference them:

    #random https://hooks.slack.com/services/T00000000/B00000000/SSqFiZsXAi5m79ENrUBg
    another https://hooks.slack.com/services/T11111111/B11111111/MNZ1Q0H0e0cnO4Y6eqeP

You'll also need one or more queue files, each containing a URL per line. For
example, create `queue/jokes.txt` with this content:

    https://552011.smushcdn.com/1101428/wp-content/uploads/2014/04/What-a-Joke_Blog-Image.png?lossy=0&strip=1&webp=1

## Running

To run, invoke the `script.sh` with three args:

    ./script.sh #random --image queue/jokes.txt

-------------------------------------------------------------------------------
The first argument is the hook key to use, the second is either `--image` or
`--link` corresponding to an explicitly unfurled image post, or to let Slack
figure out what to do with the URL.

The script will create a `log.txt` file next to it with information about what
it did and when. It's pretty neat.

## Enqueueing new URLs

There is an `add.sh` script which will help enqueue new URLs in whichever queue
you'd like. Just run it, and it'll ask you which queue you want to append to,
and then ask for the content to append.

## Stats

Lastly, there's a `stats.sh` script which will print out some basic counts for
all the queues and the log. For example:

    $ ./stats.sh 
      19 queue/jokes.txt
      14 queue/articles.txt
      33 total
    #random
     total: 31
      image: 10
      link: 21
    another
     total: 7
      image: 7
