# Tax Rolls of Medieval Paris
Welcome to the Tax Rolls of Medieval Paris project.  

A prototype is available for a small portion of the 1313 Tax Roll. Please view the styled HTML version at: [https://nadaniels.github.io/taxrolls/TaxRoll_1313_HTML.html](https://nadaniels.github.io/taxrolls/TaxRoll_1313_HTML.html)

A full-featured website for the Tax Rolls that includes the available digitized manuscript images via IIIF is currently in deveopment.

### TEI Markup
The basic TEI Markup of the individual tax payments in the rolls currently includes the following:

#### People
Named persons are tagged with the following:
* `<PersName>` - with a `ref` attribute to the XML ID of the person 
  * `<forename>`
  * `<nameLink>`
  * `<surname>`
  * `<placeName>`
  * `<roleName>`
  * `<addName>`

#### Occupations
Occupations tied to individual people are noted by the `<rs>` tag with the following attributes:
* `ref` - Referring to the XML ID of the related person
* `role` - A normalized rendering of the occupation
* `type` - `occupation`

An occupational `<rs>` tag may be placed within a `<rollName>` tag to indicate occupational surnames.

#### Tax Payments
Tax payments are tagged with `<measure>` or `<measureGrp>` and the following attributes:
* `unit` - Either `livres`, `sous`, or `deniers`
* `quantity` - The numbered amount of the unit

### Sample Markup
The markup for a typical entry looks like this:
```
<item>
  <seg type="entry">
    <persName ref="#BC01">
      <forename>Bertaut</forename>
      <nameLink>de</nameLink>
      <surname>compiegne</surname>
    </persName>
    <rs ref="#BC01" role="poulailler" type="occupation">poullaillier</rs>.
  </seg>
  <measureGrp>
    <measure quantity="2" unit="sous">ii.s.</measure>
    <measure quantity="6" unit="deniers">vi.d p.</measure>
  </measureGrp>
</item>
```

### Notes
- There is currently no TEI markup for unnamed persons, including wives and children, e.g. `La fame feu Guillaume de biaufou`
- Places are currently given placeholder XML IDs; ultimately these should connect to GeoNames or similar Linked Open Data authority file
- The XSL transformation file does not currently render or hide marginal notes, which consequently appear randomly throughout the HTML version of the edition


### Files
The prototype currently consists of the following files:
* `TaxRoll_1313_TEI.xml` - The marked up TEI/XML file for a small portion of the 1313 Parisian Tax Roll
* `TaxRoll_1313_TEI.html` - A rendered HTML version of the marked up TEI file. A handful of analytics are found at the bottom of the file
* `TaxRoll_Transform.xsl` - An XSL Transformation file that converts the TEI/XML version of the Tax Roll into HTML
* `TaxRoll_Style.css` - A CSS file used to render the HTML

