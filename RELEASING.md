Releasing
=========

1. Update the version number in Segment-Branch.podspec.
2. Update the version number add notes to CHANGELOG.md.
3. Update the version number in update-segment.
4. Run the script `update-segment` to update the pod, push to git, and release the version.

The script `update-segment` automates:

 1. Update the version in `Segment-Branch.podspec` to the next version.
 2. Update the `CHANGELOG.md` for the impending release.
 3. `git commit -am "Prepare for release X.Y.Z."` (where X.Y.Z is the new version)
 4. `git tag -a X.Y.Z -m "Version X.Y.Z"` (where X.Y.Z is the new version)
 5. `git push && git push --tags`
 6. `pod trunk push Segment-Branch.podspec --allow-warnings`
