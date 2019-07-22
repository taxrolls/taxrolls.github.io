## About

The Tax Rolls of Medieval Paris is a TEI (Text Encoding Initiative)-based digital edition of the seven extant tax rolls from the *tailles* levied on the city of Paris by [Philip the Fair](../html/personography.html#P04) between 1292 and 1313. These documents provide a wealth of information about the individual people, demographics, and history of the city.

The information presented in the tax rolls appears relatively simple at first glance, organized by parish and *quête* (district), and containing lists of taxpayers and the amount of tax paid (or owed). However, a closer look reveals personal, occupational, topographical, and financial data, which the TEI markup can make available for searching, cross-referencing, mapping, tabulating, and exporting.

### Background

#### Historical Background
As part of his efforts to deal with ongoing conflicts in England, Aragon, and Flanders, [Philip IV of France](../html/personography.html#P04) was frequently short on funds. In 1292, he levied a *taille*, a tax on personal wealth, on all of the cities in northern France. The city of Paris negotiated with the crown in order to pay 100,000 *livres tournois* in 10,000 *livre* installments over ten years (although it seems to have only been collected for eight). How to assess and distribute the collection of these funds, was therefore left up to the city the decide.

In 1313, Philip again levied a 10,000 *livre* tax on the city, this time to pay for the ceremony and festival surrounding the knighting of the king's eldest son, the future [Louis X](../html/personography.html#L10). The eight-day festival was held in the city the week of Pentecost in 1313, and included multiple banquets for the nobility of France and England, a hastily constructed boat bridge, a renewed call to go on crusade, processions across the city, and theatrical tableaus staged by various trade guilds.

#### Tax Rolls
Unfortunately, not all of the tax rolls are still extant, nor are they all complete. The rolls for 1292 and 1313 are held in the *Bibliothèque naitonale de France* (*BNF*) as [Ms fr. 6220 (1292)](https://gallica.bnf.fr/ark:/12148/btv1b107205344) and [Ms fr. 6736 (1313)](https://gallica.bnf.fr/ark:/12148/btv1b9063202d), and have been fully digitized. The rolls for 1296-1300 are available in Paris at the *Archives nationales de France* as microfilm under shelf mark KK 283. The rolls for 1293-1295 are no longer extant.

Some of the rolls have previously been edited and published:
* 1292 - H. Géraud, *Paris sous Philippe-le-Bel* (1887) [reprinted w/index by C. Bourlet and L. Fossier (1991)]
* 1296 - K. Michaëlsson, *Le Livre de la taille de Paris l'an 1296* (1958)
* 1297 - K. Michaëlsson, *Le Livre de la taille de Paris l'an 1297* (1962)
* 1313 - J.A. Buchon, *Chronique métrique de Godefroy de Paris, suivie de la taille de Paris, en 1313* (1827)
* 1313 - K. Michaëlsson, *Le Livre de la taille de Paris l'an de grace 1313* (1951)

### Digital Edition & TEI Markup
The goal of the Tax Rolls of Medieval Paris is to create a digital edition that presents a faithful transcription of the text while also extracting historical data that can be structured, normalized, and disambiguated.  Consequently, it takes inspiration from Georg Vogeler's "assertive editions," which he describes as "scholarly representations of historical documents in which the information on facts asserted by the transcription is in the focus of editorial work" (2019). While the ultimate goal of interoperability within the semantic web remains in the future, this edition nevertheless works to identify historical data, while preserving the original text.

To this end, the focus of the markup of the tax rolls falls on named entities (people, places, organizations/institutions) and the relationships between them. But it also attempts to pay attention to codicology and palaeography, marking folios and columns, noting (and expanding) abbreviations, indicating erasures, additions, and corrections, and transcribing marginalia.

The basic TEI Markup of the individual tax payments in the rolls currently includes the following:

#### People
Named persons are tagged with the following:
* `<persName>` - with a `@ref` attribute to the XML ID of the person, and any relevant child elements:
  * `<forename>`
  * `<nameLink>`
  * `<surname>`
  * `<placeName>`
  * `<roleName>`
  * `<addName>`

Unnamed persons are tagged with the `<rs>` element, with attributes and relevant child elements as above.

#### Occupations
Occupations tied to individual people are noted by the `<roleName>` tag with the following attributes:
* `@ref` - Referring to the XML ID of the related person
* `@role` - A normalized rendering/spelling of the occupation
* `@type` - `occupation`

An occupational surname that does not appear to indicate occupation (e.g. `ferpier` (*fripier*) in `Phelippe le ferpier tavernier`) is placed within a `<roleName>` tag without the additional attributes.

#### Tax Payments
Tax payments are tagged with `<measure>` or `<measureGrp>` (with multiple `<measure>` elements, if containing multiple units) and the following attributes:
* `@commodity` - `currency`
* `@unit` - Either `livres`, `sous`, or `deniers`
* `@quantity` - The numbered amount of the unit

#### Transactions
Markup for transactions is based on the [Bookkeeping Ontology](http://gams.uni-graz.at/o:depcha.bookkeeping) developed by the Digital Edition Publishing Cooperative for Historical Accounts (DEPCHA) led by Kathryn Tomasak (Wheaton College) and Georg Vogeler (University of Graz). This project uses the following `bookkeeping` tags within the  `@ana` attribute of relevant elements:
* `bk:entry`
* `bk:date`
* `bk:from`
* `bk:to`
* `bk:money`
* `bk:status`

#### Relationships
The TEI does not allow for encoding relationships within the body of a text, instead holding it in external `<listRelation>` elements. Both personal and professional relationships expressed within the tax rolls are encoded in a separate `relationships.xml` file, expressed through a simple relationship taxonomy (e.g. `#hasParent`, `#hasEmployer`).

#### GeoData
Geographic locations are currently given placeholder XML IDs; ultimately these will connect to GeoNames or a similar Linked Open Data authority file. GeoData for the streets of Paris is available from the [ALPAGE Project](https://alpage.huma-num.fr), and has been converted to geoJSON for mapping. At the moment, however, there is not yet interoperability between this data and the edited rolls.

### Sample Markup
The markup for a typical entry, e.g.:

`Bertaut de compiegne poullaillier ii.s. vi.d p.`

is rendered as:
```
<item ana="#bk:entry">
  <persName ref="#BC01" ana="#bk:from">
    <forename>Bertaut</forename>
    <nameLink>de</nameLink>
    <surname>compiegne</surname>
  </persName>
  <roleName ref="#BC01" role="poulailler" type="occupation">poullaillier</roleName>.
  <measureGrp ana="bk:money">
    <measure quantity="2" unit="sous">ii.s.</measure>
    <measure quantity="6" unit="deniers">vi.d</measure>
  </measureGrp>
  <seg ana="bk:status">p.</seg>
</item>
```
NB: Additional markup for rendering the digital edition (including `<seg>` elements and `@type` attributes) is not included here. Some of the bookkeeping markup is also added later via XSLT.
