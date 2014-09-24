---
layout: default
title: Testpage
---

# Testing display of HTML elements (h1)

# This is a 1st level heading

This is a test paragraph.

## This is 2nd level heading

This is a test paragraph.

### This is 3rd level heading
This is a test paragraph.

#### This is 4th level heading
This is a test paragraph.

##### This is 5th level heading
This is a test paragraph.

###### This is 6th level heading
This is a test paragraph.


## Basic block level elements
This is a normal paragraph (`p` element).
To add some length to it, let us mention that this page was
primarily written for testing the effect of __user style sheets__.
You can use it for various other purposes as well, like just checking how
your browser displays various HTML elements by default.
It can also be useful when testing conversions from HTML
format to other formats, since some elements can go wrong then.

This is another paragraph. I think it needs to be added that
the set of elements tested is not exhaustive in any sense. I have selected
those elements for which it can make sense to write user style sheet rules,
in my opinion.

<div>
This is a `div` element. Authors may use such elements instead
of paragraph markup for various reasons. (End of `div`.)
</div>

> This is a block quotation containing a single
> paragraph. Well, not quite, since this is not _really_
> quoted text, but I hope you understand the point. After all, this
> page does not use HTML markup very normally anyway.

The following contains address information about the author, in an `address`
element.

<address>
[Jukka Korpela](#),
[jkorpela@cs.tut.fi](mailto:jkorpela@cs.tut.fi)

Päivänsäteenkuja 4 A, Espoo, Finland
</address>

## Lists
This is a paragraph before an __unnumbered__ list (`ul`). Note that
the spacing between a paragraph and a list before or after that is hard
to tune in a user style sheet. You can't guess which paragraphs are
logically related to a list, e.g. as a "list header".

*  One.
*  Two.
*  Three. Well, probably this list item should be longer. Note that for short items
	lists look better if they are compactly presented, whereas for long items, it would be better to have more vertical spacing between items.
*  Four. This is the last item in this list.
   Let us terminate the list now without making any more fuss about it.

This is a paragraph before a __numbered__ list (`ol`). Note that
the spacing between a paragraph and a list before or after that is hard
to tune in a user style sheet. You can't guess which paragraphs are
logically related to a list, e.g. as a "list header".

1.  One.
2.  Two.
83498594378.  Three. Well, probably this list item should be longer. Note that if
items are short, lists look better if they are compactly presented,
       whereas for long items, it would be better to have more vertical spacing between items.
2131312.  Four. 
9. This list item contains another, nested list:
	1. Here
	2. It
	3. Is


## Text-level markup


*  <abbr title="Cascading Style Sheets">CSS</abbr> (an abbreviation; `abbr` markup used)
*  <acronym title="radio detecting and ranging">radar</acronym> (an acronym; `acronym` markup used)
*  <b>bolded</b> (`b` markup used - done in Markdown with \_\_xxx\_\_)
*  <big>big thing</big> (`big` markup used)
*  <cite>Origin of Species</cite> (a book title;
       `cite` markup used)
*  `a[i] = b[i] + c[i);` (computer code; `code` markup used)
*  here we have some <del>deleted</del> text (`del` markup used)
*  an <dfn>octet</dfn> is an entity consisting of eight bits
       (`dfn` markup used for the term being defined)
*  this is _very_ simple (`em` markup used for emphasizing a word, done in Markdown with \_xxx\_)
*  <i lang="la">Homo sapiens</i> (should appear in italics;  `i` markup used)
*  here we have some <ins>inserted</ins> text (`ins` markup used)
*  type <kbd>yes</kbd> when prompted for an answer (`kbd` markup
       used for text indicating keyboard input)
*  <q>Hello!</q> (`q` markup used for quotation)
*  He said: <q>She said <q>Hello!</q></q> (a quotation inside a quotation)
*  you may get the message <samp>Core dumped</samp> at times
       (`samp` markup used for sample output)
*  <small>this is not that important</small> (`small` markup used)
*  <strike>overstruck</strike> (`strike` markup used; note:
       `s` is a nonstandard synonym for `strike`)
*  __this is highlighted text__ (`strong`
       markup used)
*  In order to test how subscripts and superscripts (`sub` and
       `sup` markup) work inside running text, we need some
       dummy text around constructs like x<sub>1</sub> and H<sub>2</sub>O
       (where subscripts occur). So here is some fill so that
       you will (hopefully) see whether and how badly the subscripts
       and superscripts mess up vertical spacing between lines.
       Now superscripts: M<sup>lle</sup>, 1<sup>st</sup>, and then some
       mathematical notations: e<sup>x</sup>, sin<sup>2</sup> <i>x</i>,
       and some nested superscripts (exponents) too:
       e<sup>x<sup>2</sup></sup> and f(x)<sup>g(x)<sup>a+b+c</sup></sup>
       (where 2 and a+b+c should appear as exponents of exponents).
*  <tt>text in monospace font</tt> (`tt` markup used)
*  <u>underlined</u> text (`u` markup used)
*  the command `cat` <var>filename</var> displays the
       file specified by the <var>filename</var> (`var` markup
       used to indicate a word as a variable).

Some of the elements tested above are typically displayed in a monospace
font, often using the _same_ presentation for all of them. This
tests whether that is the case on your browser:


*  `This is sample text inside code markup`
*  <kbd>This is sample text inside kbd markup</kbd>
*  <samp>This is sample text inside samp markup</samp>
*  <tt>This is sample text inside tt markup</tt>


## Links

*  [main page](index.html)
*  [Unicode Standard, chapter&nbsp;6]("http://www.unicode.org/versions/Unicode4.0.0/ch06.pdf")

This is a text paragraph that contains some
inline links. Generally, inline links (as opposite to e.g. links
lists) are problematic
from the
[usability](http://www.useit.com) perspective,
but they may have use as
"incidental", less relevant links. See the document
<cite>[Links Want To Be Links](https://www.cs.tut.fi/~jkorpela/www/links.html)</cite>.

## Tables
The following table has a header row and three columns. 

| Country | Total area (km) | Land area (km<sup>2</sup>) |
| :---- | :-----: | ------: |
| Denmark |  43,070  |  42,370 |
| Finland | 337,030  | 305,470 |
| Iceland | 103,000  | 100,250 |
| Norway | 324,220  | 307,860 |
| Sweden | 449,964  | 410,928 |

The first column is left-aligned, the second center-aligned and the third right-aligned. This is achieved by the colon position in the header separator row:

    | Country | Total area (km) | Land area (km<sup>2</sup>) |
    | :---- | :-----: | ------: |
    ...

## Character test
The following table has some sample characters with
annotations. If the browser's default font does not
contain all of them, they may get displayed using backup fonts.
This may cause stylistic differences, but it should not
prevent the characters from being displayed at all.

|Char.|Explanation|Notes|
|-----------------------|
| ê | e with circumflex | Latin 1 character, should be ok |
|&#8212;|em dash|Windows Latin 1 character, should be ok, too|
|&#x100;|A with macron (line above)|Latin Extended-A character, not present in all fonts|
|&Omega;|capital omega|A Greek letter|
|&#x2212;|minus sign|Unicode minus|
|&#x2300;|diameter sign|relatively rare in fonts|


