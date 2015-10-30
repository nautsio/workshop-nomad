# Nauts.io presentation template
Use this template as the starting point for your presentations and workshops.

## How to use
- [Create a new repo](https://github.com/organizations/nautsio/repositories/new) and checkout the `gh-pages` branch
- Add the contents from this repo
- Add your slide contents in [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown) to `presentation.md`
- Or add a new MarkDown file and add it to `<div class="slides">` in `index.html`


## How to build/preview
- Build your site using the `jekyll/jekyll:pages` Docker image

```
docker run --rm --name=jekyll --volume=$(pwd):/srv/jekyll -it -p 4000:4000 jekyll/jekyll:pages jekyll s
```


## Notes
- Reveal.js and the stying are pulled from the shared [cdn.nauts.io](https://github.com/nautsio/cdn) repo
- Markdown separators:
 - New slide: `^\n!SLIDE`
 - New vertical sub-slide: `^\n!SUB`
 - Presenter notes: `^\n!NOTE`
