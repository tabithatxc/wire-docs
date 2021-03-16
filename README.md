# Wire-docs

Source files for wire-server documentation hosted on https://docs.wire.com

## Reading the documentation

Visit https://docs.wire.com/

## Making contributions

The structure of this document has been heavily inspired by [this blog
post](https://www.divio.com/blog/documentation/).

We use [sphinx](http://sphinx-doc.org/) for rendering.  Here is a [cheat
sheet](http://docutils.sourceforge.net/docs/user/rst/quickref.html)
for writing re-structured text (`*.rst`).
[here is another one](http://docutils.sourceforge.net/docs/user/rst/cheatsheet.html).
And [another one](https://sublime-and-sphinx-guide.readthedocs.io/en/latest/references.html).

## Generate html output using docker

Generate docs (using docker, so you don't need to install python dependencies yourself)

```
make docs
```

See build/html/index.html

## Generate html output without docker

Install the dependencies locally:

* you need `python3` and [poetry](https://github.com/python-poetry/poetry#installation) then run `poetry install`. If that fails you may not have a required system dependency, have a look at the [Dockerfile](./Dockerfile) for hints of packages you may need.

Once you have all python dependencies installed globally, run `make html`.

## Local development environment for file watching

Enter a *development mode* by running `make dev-srun` to start a local server and file watcher.

Look at results by opening build/html/index.html

Any changes you do leads to a rebuild, and refreshing your browser shows you the change.

## Generating a PDF file

NOTE: support is experimental and resulting pdf may not have great formatting. See the [rst2pdf](https://rst2pdf.org/static/manual.pdf) manual to improve the configuration here so the resulting PDF becomes nicer.

Locally:
* You need `rst2pdf`, then run `make pdf` and look at `./build/pdf/`

Using docker:
* `make docs-pdf`

## For maintainers (Wire employees)

### Upload to S3

CI is set up to do this automatically on a push to master. If for some reason you wish to upload manually to S3:

(You need amazon credentials for pushing to S3)

```
make push
```

Please note that cloudfront CDN has a certain cache duration (at the time of writing: 1 minute), so changes will take a bit of time to take effect.
