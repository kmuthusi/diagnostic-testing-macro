# `%diag_test`: A Generic SAS Macro for Evaluating Diagnostic Accuracy Measures for Multiple Diagnostic Tests
This repository was created for use by CDC programs to collaborate on public health surveillance related projects in support of the CDC Surveillance Strategy.  Github is not hosted by the CDC, but is used by CDC and its partners to share information and collaborate on software.

## Macro description
`%diag_test` is a SAS macro for evaluating diagnostic accuracy measures from multiple diagnostic and screening tests. It uses patient-level data and generates a 2x2 contingency table and confusion matrix as part of the output. It also creates an additional output of overlayed ROC curves with corresponding AUCs for comparison.

The macro computes a point estimate for each measure of diagnostic accuracy using formulae provided in Table 2 and corresponding Wilson score binomial confidence limits (unless specified otherwise). It consists of one sub-macro which computes estimates for each diagnostic tests then combines analysis for all of them into one output table. The output is then processed using the TEMPLATE, PROC REPORT procedures and the output delivery system (ODS) to create a publication- quality table. The macro has been developed to run on windows platform and might require appropriate adjustments to run on other operating systems platforms.

In summary, the macro has been design to provide the user with the following benefits:

- Automated to shorten analysis time and eliminate error that arise during copy-pasting of analysis output.
- Promote principles of reproducible research i.e., transparency, reproducibility, reusability.
- Easy to use since user just needs to specify the dataset, truth and test variables and corresponding cut-offs.
- Generic to use data from different settings e.g., in lab to evaluate multiple diagnostic tests or in machine learning to evaluate performance of classification algorithms.
- Flexible to allow user to specify desired significance level and precision of point estimates
- Provide options for dealing with missing data e.g., include in output or suppress.
- Produce outputs with natural display of results useful in epidemiological and biomedical publications.

## How to use the Macro
The user should specify input parameters described in the table below unless the description is prefixed by (optional). The user, however, does not interact with the sub-macros. To achieve full potential of the SAS macro, the user must ensure that the analysis dataset is clean, analysis variables are well labelled, and values of variables have been converted into appropriate SAS formats before they can be input to the macro call.

|Parameter|Description|
|---------|-----------|
|data		|name of input dataset|
|truthvar	|name of reference/truth variable e.g., abbott_plasma_vl|
|truthcutvalue	|cutoff value to use to categorize values of test variable as having disease or not e.g., 1,000 so that if value ≥ 1,000 then presence of disease, otherwise absence of disease|
|testvarlist	|list of diagnostic test variable(s) separated by space e.g., vdbs_vl mdbs_vl ddbs_vl|
|testcutvalue	|cutoff value to use to categorize values of test variable as having disease or not e.g., 1,000 so that if value ≥ 1,000 then presence of disease, otherwise absence of disease|
|domain		|(optional) domain variable for sub-population analysis|
|domainvalue	|(optional) value of domain/sub-population of interest (should be numeric). Required if domain is specified|
|condition	|(optional) any conditional statements to create and or fine-tune the final analysis dataset specified using one IF statement|
|outputdir	|path for directory/folder where output is saved|
|tablename	|short name of output table|
|tabletitle	|title of output table|
|surveyname	|abbreviation for survey/study to be included in the output|
|decimalpoints	|number of decimal places for each estimated measure|
|alpha		|(optional) desired level of significance (default=0.05, for 95% confidence intervals)|
|missvaluelabel	|(optional) value label for missing values. If missing data have a format, it should be provided, otherwise macro assumes the default format “.”|
|varmethod  |(optional) method for computing confidence intervals namely "Normal" (default) for normal distribution or "Wilson" (most desired) for Wilson score or "Exact" for exact binomial approximations|
|print	|variable for displaying/suppressing the output table on the output window which takes the values (NO=suppress output, YES=show output)|

A sample macro call program, `diag_test-analysis-file.sas`, is also provided as part of this repository.

A `manuscript` describing more about the macro contents and usage is currently under peer review and a pre-print article is available online at [Research Square](https://www.researchsquare.com/article/rs-3344191/v1)

## Using SAS onDemand for Academics
Below representation demonstrates how to setup the files and run using [SAS® OnDemand for Academics](https://welcome.oda.sas.com/). 

![image](https://github.com/user-attachments/assets/69f8d070-3f20-495f-95cf-5d9bb353efbf)

![image](https://github.com/user-attachments/assets/627548bb-03e4-4343-a747-13c81991086f)

Specifically,
- 1 (a) and (b) shows how to setup folders on SAS® OnDemand for Academics.
- 2 Shows how to define directory/path on the macro call file.
- SAS® OnDemand for Academics provides an environment for learners and trainers to write and run SAS code with a Web-based SAS development environment. 

## Public Domain
This repository constitutes a work of the United States Government and is not
subject to domestic copyright protection under 17 USC § 105. This repository is in
the public domain within the United States, and copyright and related rights in
the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
All contributions to this repository will be released under the CC0 dedication. By
submitting a pull request you are agreeing to comply with this waiver of
copyright interest.

## License
The repository utilizes code licensed under the terms of the Apache Software
License and therefore is licensed under ASL v2 or later.

This source code in this repository is free: you can redistribute it and/or modify it under
the terms of the Apache Software License version 2, or (at your option) any
later version.

This source code in this repository is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the Apache Software License for more details.

You should have received a copy of the Apache Software License along with this
program. If not, see http://www.apache.org/licenses/LICENSE-2.0.html

The source code forked from other open source projects will inherit its license.

## Privacy
This repository contains only non-sensitive, publicly available data and
information. All material and community participation is covered by the
Surveillance Platform [Disclaimer](https://github.com/CDCgov/template/blob/master/DISCLAIMER.md)
and [Code of Conduct](https://github.com/CDCgov/template/blob/master/code-of-conduct.md).
For more information about CDC's privacy policy, please visit [http://www.cdc.gov/privacy.html](http://www.cdc.gov/privacy.html).

## Contributing
Anyone is encouraged to contribute to the repository by [forking](https://help.github.com/articles/fork-a-repo)
and submitting a pull request. (If you are new to GitHub, you might start with a
[basic tutorial](https://help.github.com/articles/set-up-git).) By contributing
to this project, you grant a world-wide, royalty-free, perpetual, irrevocable,
non-exclusive, transferable license to all users under the terms of the
[Apache Software License v2](http://www.apache.org/licenses/LICENSE-2.0.html) or
later.

All comments, messages, pull requests, and other submissions received through
CDC including this GitHub page are subject to the [Presidential Records Act](http://www.archives.gov/about/laws/presidential-records.html)
and may be archived. Learn more at [http://www.cdc.gov/other/privacy.html](http://www.cdc.gov/other/privacy.html).

## Records
This repository is not a source of government records, but is a copy to increase
collaboration and collaborative potential. All government records will be
published through the [CDC web site](http://www.cdc.gov).

## Notices
Please refer to [CDC's Template Repository](https://github.com/CDCgov/template)
for more information about [contributing to this repository](https://github.com/CDCgov/template/blob/master/CONTRIBUTING.md),
[public domain notices and disclaimers](https://github.com/CDCgov/template/blob/master/DISCLAIMER.md),
and [code of conduct](https://github.com/CDCgov/template/blob/master/code-of-conduct.md).

## ----- for use in template only -----
## Hat-tips
Thanks to [18F](https://18f.gsa.gov/)'s [open source policy](https://github.com/18F/open-source-policy)
and [code of conduct](https://github.com/CDCgov/code-of-conduct/blob/master/code-of-conduct.md)
that were very useful in setting up this GitHub organization. Thanks to CDC's
[Informatics Innovation Unit](https://www.phiresearchlab.org/index.php/code-of-conduct/)
that was helpful in modeling the code of conduct.

## ----- for use in template only -----
