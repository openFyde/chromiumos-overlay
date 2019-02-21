# Instructions on test DLC

## Steps to generate test DLC

```sh
mkdir -p ${TEMP}
mkdir -p ${DLC_ARTIFACT_DIR}
mkdir -p ${DLC_ARTIFACT_DIR}/dir
truncate -s 12K ${DLC_ARTIFACT_DIR}/file1.bin
truncate -s 24K ${DLC_ARTIFACT_DIR}/dir/file2.bin
chromite/bin/build_dlc --src-dir="${DLC_ARTIFACT_DIR}" \
  --install-root-dir="${TEMP}" --fs-type="squashfs" \
  --pre-allocated-blocks="3" --version="1.0.0" --id=test-dlc --name="test-dlc"
delta_generator --new_partitions=${TEMP}/build/rootfs/dlc/test-dlc/dlc.img \
  --partition_names="dlc_test-dlc" --major_version=2 \
  --out_file=${TEMP}/dlcservice_test-dlc.payload
```

## Locations of generated files
* ${TEMP}/opt/google/dlc/test-dlc/table
* ${TEMP}/opt/google/dlc/test-dlc/imageloader.json
* ${TEMP}/dlcservice_test-dlc.payload

## Extra notes:
* dlcservice_test-dlc.payload is used by tast test platform.DLCService and is unlikely updated unless we see a test regression.
* When a test regression happens and we decide updating a new payload is the right cure, then platform.DLCService needs to be updated to point to the new payload location (if changed) or payload DLC ID (if changed).
