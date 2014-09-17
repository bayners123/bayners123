---
layout: default
title: News
---

<script src="{{site.url}}/js/news.js"></script>

## News

<div id="newsPage" class="grid">
{% for post in site.posts %}

    <div class="unit half">
        
        {% if post.image %}<a class="filledImg" href="{{ site.url }}{{ post.image }}">
        {% else %}<div class="filledImg">{% endif %}
            <div>
                <img src="{% if post.image %}{{ site.url }}{{ post.image }}{% endif %}" alt="{{post.content | strip_html}}" />
            </div>
        {% if post.image %}</a>
        {% else %}</div>{% endif %}
        
    {{post.content}}
    
    <p class="newsDate">{{ post.date | date_to_long_string }}</p>
    
    </div>
    
    {% cycle '', '</div><div class="grid">' %}
    
{% endfor %}
</div>

