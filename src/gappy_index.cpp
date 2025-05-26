/* vim: set expandtab shiftwidth=2 softtabstop=2 tw=70: */

#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericVector do_gappy_index(NumericVector starts, IntegerVector offset, IntegerVector length)
{
    long int nstarts = starts.size();
    long int n = nstarts * static_cast<long int>(length[0]);
    long int k = 0;
    NumericVector res(n);
    if (nstarts > 0) {
      long int minspan = 100 * nstarts * static_cast<long int>(length[0]); // start large
      for (long int i = 1; i < nstarts; i++) {
        long int span = static_cast<long int>(starts[i]) - static_cast<long int>(starts[i-1]);
        if (span < minspan)
          minspan = span;
      }
      if (static_cast<long int>(length[0]) > minspan)
        ::Rf_error("'length' %.0f exceeds minimum span between 'starts' elements (%ld)", length[0], minspan);
    }
    for (long int i = 0; i < nstarts; i++) {
      long int off = static_cast<long int>(offset[0]);
      for (long int j = 0; j < static_cast<long int>(length[0]); j++) {
        res[k++] = static_cast<double>(static_cast<int64_t>(starts[i]) + off);
        off++;
        if (k > n) {
          break;
        }
      }
    }
    return res;
}
