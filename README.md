# Tax Rolls of Medieval Paris
Welcome to the Tax Rolls of Medieval Paris Digital Edition project.  

A prototype is available for a small portion of the 1313 Tax Roll. Please view the styled HTML edition at: [https://nadaniels.github.io/taxrolls/html/roll_1313.html](https://nadaniels.github.io/taxrolls/html/roll_1313.html)

A full-featured website for the Tax Rolls that includes the available digitized manuscript images via IIIF is currently in development. The manuscript containing the 1313 Tax Roll can be found on Gallica at: [https://gallica.bnf.fr/ark:/12148/btv1b9063202d](https://gallica.bnf.fr/ark:/12148/btv1b9063202d)

Slides from the 2019 AHA DEPCHA Workshop are available in this repository at: [https://nadaniels.github.io/taxrolls/2019_01%20AHA%20DEPCHA/2019_01_03%20Daniels%20DEPCHA Slides.pptx](https://nadaniels.github.io/taxrolls/2019_01%20AHA%20DEPCHA/2019_01_03%20Daniels%20DEPCHA%20Slides.pptx)

### TEI Markup
The basic TEI Markup of the individual tax payments in the rolls currently includes the following:

#### People
Named persons are tagged with the following:
* `<persName>` - with a `ref` attribute to the XML ID of the person 
  * `<forename>`
  * `<nameLink>`
  * `<surname>`
  * `<placeName>`
  * `<roleName>`
  * `<addName>`

#### Occupations
Occupations tied to individual people are noted by the `<roleName>` tag with the following attributes:
* `ref` - Referring to the XML ID of the related person
* `role` - A normalized rendering/spelling of the occupation
* `type` - `occupation`

An occupational surname that does not appear to indicate occupation (e.g. `ferpier` in `Phelippe le ferpier tavernier`) is placed within a `<roleName>` tag without the additional attributes.

#### Tax Payments
Tax payments are tagged with `<measure>` or `<measureGrp>` (if containing multiple units) and the following attributes:
* `unit` - Either `livres`, `sous`, or `deniers`
* `quantity` - The numbered amount of the unit

### Sample Markup
The markup for a typical entry, e.g.:

`Bertaut de compiegne poullaillier ii.s. vi.d p.`

is rendered as:
```
<item>
  <persName ref="#BC01">
    <forename>Bertaut</forename>
    <nameLink>de</nameLink>
    <surname>compiegne</surname>
  </persName>
  <roleName ref="#BC01" role="poulailler" type="occupation">poullaillier</roleName>.
  <measureGrp>
    <measure quantity="2" unit="sous">ii.s.</measure>
    <measure quantity="6" unit="deniers">vi.d p.</measure>
  </measureGrp>
</item>
```

### Notes
- There is currently no TEI markup for unnamed persons, frequently wives and children, e.g. `La fame feu Guillaume de biaufou`.
- Geographic locations are currently given placeholder XML IDs; ultimately these should connect to GeoNames or a similar Linked Open Data authority file.
- The XSL transformation file does not currently render or hide marginal manuscript notes, which consequently appear randomly throughout the HTML version of the edition.


### Files
The prototype currently consists of the following files:
* `TaxRoll_1313_TEI.xml` - The marked up TEI/XML file for a small portion of the 1313 Parisian Tax Roll
* `TaxRoll_1313_HTML.html` - A rendered HTML edition of the marked up TEI file; a handful of test analytics are found at the bottom of the edition, dynamically created via XSL Transformation.
* `TaxRoll_Transform.xsl` - An XSL Transformation file that converts the TEI/XML version of the Tax Roll into HTML
* `TaxRoll_Style.css` - A CSS file used to render the HTML as a digital edition

