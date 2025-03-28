#' Reprex
#' 
#' Reprex of issues arising when recording graphical examples with `pdf(NULL)`
#'
#' @examples
#' heart_glyph <- "\u2665"
#' # Ideally this example would run in {pkgdown}
#' if (require("grid", quietly = TRUE) &&
#'     pkgdown.pdf.null.reprex:::device_supports_unicode()) {
#'   grid.newpage()
#'   gp = gpar(fontsize = 72, fontfamily = "sans")
#'   grid.text(heart_glyph, gp = gp)
#' }
#' if (require("grid") &&
#'     (pkgdown.pdf.null.reprex:::device_supports_unicode() ||
#'      pkgdown::in_pkgdown())) {
#'   grid.newpage()
#'   gp = gpar(fontsize = 72, fontfamily = "sans")
#'   grid.text(heart_glyph, gp = gp)
#' }
#' rook_glyph <- "\u2656"
#' font <- "Dejavu Sans"
#' if (require("grid") && 
#'     pkgdown.pdf.null.reprex:::has_font(font) &&
#'     (pkgdown.pdf.null.reprex:::device_supports_unicode() ||
#'      pkgdown::in_pkgdown())) {
#'   grid.newpage()
#'   gp = gpar(fontsize = 72, fontfamily = font)
#'   grid.text(rook_glyph, gp = gp)
#' }
#' @return Returns `NULL` invisibly.
#' @export
do_nothing <- function() {
    invisible(NULL)
}


has_font <- function(font) {
    stopifnot(length(font) == 1)
    font_file <- basename(systemfonts::match_fonts(family = font)$path)
    grepl(simplify_font(font), simplify_font(font_file))
}

simplify_font <- function(font) {
    tolower(gsub(" ", "", font))
}

# Make sure not to run examples in `pdf()` to avoid MBCS conversion warnings
# In R CMD checks.
device_supports_unicode <- function() {
    device <- names(grDevices::dev.cur())
    unicode_devices <- c("agg_capture", "agg_jpeg", "agg_ppm", "agg_png", "agg_record", "agg_tiff", # {ragg}
                         "devSVG", "devSVG_vdiffr", # {svglite} / {vdiffr}
                         "quartz", "quartz_off_screen", # Quartz
                         "cairo_pdf", "cairo_ps", "svg", "X11cairo") # Cairo
    if (any(vapply(unicode_devices, function(x) grepl(paste0("^", x), device),
                   FUN.VALUE = logical(1L)))) {
        TRUE
    } else if (device %in% c("bmp", "jpeg", "png", "tiff")) {
        # on unix non-"cairo" type have different device names from "cairo" type
        # but on Windows can't distinguish between `type = "windows"` or `type = "cairo"`
        # Windows device doesn't support new patterns feature
        if (getRversion() >= "4.2.0") {
            "LinearGradient" %in% grDevices::dev.capabilities()$patterns
        } else {
            .Platform$OS.type == "unix"
        }
    } else {
        FALSE
    }
}
