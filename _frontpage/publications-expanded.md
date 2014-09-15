---
section: publicationsExpanded
---

<!-- TODO: Sort out Mark's horrible CSS -->

## Selected Recent Publications

<ol>
{% for paper in site.data.pubs %}
	<li>  
		<span class="content_publications_title">&ldquo;{{ paper.title }}&rdquo;</span>
		<span class="content_publications_authors">{{ paper.author }}</span>
		<span class="content_publications_journal">{{ paper.journal }}</span>
		<span class="content_publications_year">{{ paper.year }}</span>
		<span class="content_publications_pages">{{ paper.pages }}</span>
		<a href="{{ paper.link }}"> <img src="/images/pdflogo.jpg" alt="View Article"></a>
		{% if paper.notes %}
		<p class="pubNotes">{{ paper.notes }}</p>
		{% endif %}
	</li>
{% endfor %}
</ol>

Papers linked from here require subscription access to the appropriate journal.  For university staff or students not on a university provided connection, external access is available via the [VPN Service](http://www.oucs.ox.ac.uk/network/vpn/).