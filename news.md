---
layout: default
title: News
---

<script src="{{site.url}}/js/news.js"></script>

## News

<div class="grid">
{% for post in site.posts %}

    <div class="unit half">

    {{post.content}} - {{ post.date | date_to_long_string }}
    
    </div>
    
    {% cycle '', '</div><div class="grid">' %}
    
{% endfor %}
</div>