 if (Test-Path ./tmp/GITHUB_ENV.txt) {
  Remove-Item ./tmp/GITHUB_ENV.txt
}
 docker run --rm -v ${PWD}:/data -w /data -e GITHUB_ENV=/data/tmp/GITHUB_ENV.txt alpine sh before-build.sh