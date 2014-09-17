---
section: publicationsExpanded
---

<!-- TODO: Sort out Mark's horrible CSS -->

## Selected Recent Publications

<ol>
{% for paper in site.data.pubs %}
	<li class="pub">  
		<span class="title">&ldquo;{{ paper.title }}&rdquo;</span>
		<span class="authors">{{ paper.author }}</span>
		<span class="journal">{{ paper.journal }}</span>
		<span class="year">{{ paper.year }}</span>
        <span class="volume">{{ paper.volume }}</span>
		<span class="pages">{{ paper.pages }}</span>
		<a href="{{ paper.link }}"> <img src="{{site.url}}/images/pdflogo.jpg" alt="View Article"></a>
		{% if paper.notes %}
		<p class="pubNotes">{{ paper.notes }}</p>
		{% endif %}
	</li>
{% endfor %}
</ol>

Papers linked from here require subscription access to the appropriate journal.  For university staff or students not on a university provided connection, external access is available via the [VPN Service](http://www.oucs.ox.ac.uk/network/vpn/).