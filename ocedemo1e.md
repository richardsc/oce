---
css: syntax.css
pygments: true
brokenlayout: default
permalink: ocedemo1e.html
title: ocedemo1e
---

# Test 1002

Things I have tried

- add ``<link href="style.css" media="screen" rel="stylesheet" type="text/css" />`` at start of markdown file
- set ``css: syntax`` in YAML preamble
- set ``css: syntax.css`` in YAML preamble

## ruby (from the docs)

{% highlight ruby %}
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{% endhighlight %}

## R

{% highlight r %}
library(oce)
data(ctd)
plot(ctd, which=c(1,2,3,5))
{% endhighlight %}

