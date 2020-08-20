function outputrho=vp2rho(inputvp);
outputrho=1.6612*inputvp - 0.4721*inputvp^2 + 0.0671*inputvp^3 - 0.0043*inputvp^4 + 0.000106*inputvp^5;