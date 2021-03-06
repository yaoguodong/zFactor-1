#' Dranchuk-AbouKassem correlation
#'
#' @param pres.pr pseudo-reduced pressure
#' @param temp.pr pseudo-reduced temperature
#' @param tolerance controls the iteration accuracy
#' @param verbose print internal calclulations
#' @rdname Dranchuk-AbouKassem
#' @export
#' @examples
#' ## calculate z for one Tpr curve at a single Ppr
#' z.DranchukAbuKassem(pres.pr = 1.5, temp.pr = 2.0)
#' ## For vectors of Ppr and Tpr:
#' ppr <- c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5)
#' tpr <- c(1.3, 1.5, 1.7, 2)
#' z.DranchukAbuKassem(pres.pr = ppr, temp.pr = tpr)
#' ## create and print comparison tables with the z matrices
#' ppr <- c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5)
#' tpr <- c(1.05, 1.1, 1.7, 2)
#' z.calc <- z.DranchukAbuKassem(ppr, tpr)
#' z.chart <- getStandingKatzMatrix(ppr_vector = ppr, tpr_vector = tpr)
#' ape <- abs((z.calc - z.chart) / z.chart) * 100
#' cat("z.correlation \n"); print(z.calc)
#' cat("\n z.chart \n"); print(z.chart)
#' cat("\n APE \n"); print(ape)
z.DranchukAbuKassem <- function(pres.pr, temp.pr, tolerance = 1E-13,
                                verbose = FALSE) {
    # calls the core function and converts results to a matrix
    co <- sapply(pres.pr, function(x)
        sapply(temp.pr, function(y)
            .z.DranchukAbuKassem(pres.pr = x, temp.pr = y,
                                 tolerance = tolerance, verbose = verbose)))

    if (length(pres.pr) > 1 || length(temp.pr) > 1) {
        co <- matrix(co, nrow = length(temp.pr), ncol = length(pres.pr))
        rownames(co) <- temp.pr
        colnames(co) <- pres.pr
    }
    return(co)
}



.z.DranchukAbuKassem <- function(pres.pr, temp.pr, tolerance = 1E-13,
                                verbose = FALSE) {
    # core function
    F <- function(rhor)
    {
        R1 * rhor - R2 / rhor + R3 * rhor^2 - R4 * rhor^5 +     # equation 3-41
            R5  * rhor^2 * (1 +  A11 * rhor^2) * exp(-A11 * rhor^2) + 1
    }

    Fprime <- function(rhor) {
        # derivative of the DAK function
        R1 + R2 / rhor^2 + 2 * R3 * rhor - 5 * R4 * rhor^4 +
            2 * R5 * rhor * exp(-A11 * rhor^2) *
            ((1 +  2 * A11 * rhor^3) - A11 * rhor^2 * (1 +  A11 * rhor^2))
    }
    # the constants
    A1  <- 0.3265; A2 <- -1.0700; A3 <- -0.5339; A4 <- 0.01569; A5 <- -0.05165
    A6  <- 0.5475; A7 <- -0.7361; A8 <-  0.1844; A9 <- 0.1056; A10 <- 0.6134;
    A11 <- 0.7210
    # use R1 thru R5 for the function and its derivative
    R1 <-  A1 + A2 / temp.pr + A3 / temp.pr^3 + A4 / temp.pr^4 + A5 / temp.pr^5
    R2 <- 0.27 * pres.pr / temp.pr
    R3 <- A6 + A7 / temp.pr + A8 / temp.pr^2
    R4 <- A9 * (A7 / temp.pr + A8 / temp.pr^2)
    R5 <- A10 / temp.pr^3

    # step 1: find first guess
    rhork0 <- 0.27 * pres.pr / temp.pr           # use part of the equation
    rhork <- rhork0
    i <- 1
    while (TRUE) {
        # step 2: if it is lower than tolerance, exit and calc z
        #         otherwise, calculate a better rho with the derivative
        if (abs(F(rhork)) < tolerance)  break
        rhork1 <- rhork - F(rhork) / Fprime(rhork)
        delta <- abs(rhork - rhork1)
        if (delta < tolerance) break       # exit the loop if ideal delta found
        if (verbose)
            cat(sprintf("%3d %11f %11f %11f \n", i, rhork, rhork1, delta))
        rhork <- rhork1
        i <- i + 1
    }
    z <- 0.27 * pres.pr / (rhork * temp.pr)
    return(z)
}
