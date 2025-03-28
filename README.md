# pkgdown.pdf.null.reprex

Minimal reprex of `{pkgdown}` issues when example images are **recorded** using `pdf(NULL)` and then **plotted** by `ragg::agg_png()`.

## Notes

* I have some examples that make sure to not run if the active graphics device is `pdf()` in order to avoid triggering `_R_CHECK_MBCS_CONVERSION_FAILURE_` issues with CRAN's R CMD check.
* Previously these examples would show up in my `{pkgdown}` websites since it seems that previously `{pkgdown}` would **record** examples using `ragg::agg_png()`:

  + e.g. in this line of `highlight_examples()` the `device` option is hardcoded to `ragg::agg_png()` with the intention that this device will be used to **record** the examples: https://github.com/r-lib/pkgdown/blob/66477c0dbb4f4925ec872cf64d5eaa316cc70bac/R/highlight.R#L18

* However these examples no longer show up in my `{pkgdown}` websites since it seems that now examples are **de facto** now actually being **recorded** using `pdf(NULL)`:

  + Looking at the code it seems this is because upstream in `{evaluate}` they changed the code to no longer use the device set by the `device` option but to instead to always use `pdf(NULL)`:

   - https://github.com/r-lib/evaluate/blob/9b412235d0d8a804603637ccecff98e880003feb/R/watchout.R#L9
   - https://github.com/r-lib/evaluate/commit/c750df44483c76ac18b397ff27361aa7b38650b1
   - https://github.com/r-lib/evaluate/pull/132

* I'm also observing in some examples a new `Warning: font family 'Dejavu Sans' not found in PostScript font database` warnings.  This also seems to be a side effect of `pdf(NULL)` being used to record the examples.

* This issue is similar to https://github.com/r-lib/pkgdown/issues/2299 in that there is a "problem" because the graphics device being used to **record** the example is a different device from the one being used to **render** the example and there are cases where one may want to skip the recording graphics device but not skip the rendering graphics device.

* I did notice that the development version of {ragg} recently added the `agg_record()` graphics device which doesn't create any files and seems optimized for recording figure examples and (after release) I speculate it may be a better choice for recording examples than `pdf(NULL)`: https://github.com/r-lib/ragg/commit/de052f5ed62a1d270a0b598535ee6d9ecce93666
