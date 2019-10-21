# The Good News

An obnoxiously simple queued publishing platform comprised of a few shell
scripts and some text files for the queues.

## Setup

You'll need to create `hook_urls.txt` containing Slack WebHook URLs prefixed
with a key used to reference them:

    #random https://hooks.slack.com/services/T00000000/B00000000/SSqFiZsXAi5m79ENrUBg
    another https://hooks.slack.com/services/T11111111/B11111111/MNZ1Q0H0e0cnO4Y6eqeP

You'll also need one or more queue files, each containing a URL per line. For
example, create `queue/jokes.txt`:

    https://552011.smushcdn.com/1101428/wp-content/uploads/2014/04/What-a-Joke_Blog-Image.png?lossy=0&strip=1&webp=1
    https://i.redd.it/uubwjcabka931.jpg

Note that while I've used the term "queue", it's not really a queue in the
normal sense of the word. It's just a bag of URLs which will be processed
randomly. As items are processed, they're removed from the queue, of course, but
there's no way to control order of publication (aside from manually managing a
queue of length one).

## Running

To run, invoke the `script.sh` with three args:

    ./script.sh #random --image queue/jokes.txt

The first argument is the hook key to use, the second is either `--image` or
`--link` corresponding to an explicitly unfurled image post or to let Slack
figure out what to do with the URL, and the last is the queue file to process.
The file must be readable and writable.

The script will create a `log.txt` file next to it with information about what
it did and when. It'll also print a warning to STDOUT if the queue is "low".

All this brings us to it's intended use: from your `crontab`. Just set it up
to run on whatever schedule(s) you want, and it'll warn you when the queue
needs attention (and gracefully do nothing if the queue's empty).

## Enqueueing New URLs

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
