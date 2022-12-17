test_that(
  desc = "normal functioning, 3 authors",
  code = {
    local_edition(3)
    
    yml_header <- '
      ---
title: "Authors-block Example"

authors:
  - name: John Doe
    affiliations:
      - ref: jdct
    corresponding: true
    email: john.doe@jdct.edu
    orcid: 0000-1111-2222-3333
    equal-contributor: true
  - name: John Roe
    affiliations:
      - ref: jdct
    orcid: 0000-3333-2222-1111
  - name: Jane Roe
    affiliations:
      - ref: jdct
      - ref: iot
    orcid: 0000-2222-1111-3333
    equal-contributor: true

affiliations:
  - id: jdct
    name: John Doe Center for Technology, John Doe University, Doetown, Germany.
  - id: iot
    name: Institute of Technology, John Doe University, Doetown, Germany.

filters:
  - authors-block

format:
  #native: default
  docx: default
  pdf: default
---
    '
    fn_in <- file.path(tempdir(), "test.qmd")
    fn_out <- file.path(tempdir(), "test.native")
    writeLines(text = yml_header, con = fn)
    quarto::quarto_render(
      input = fn_in,
      output_format = "native"
    )
    expect_snapshot_file(fn_out)
  }
)