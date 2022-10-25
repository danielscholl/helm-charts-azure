# Helm go unit tests

Usage:

```shell
cd helm-charts-azure

for test_dir in $(find . -path "*/tests/unit/*.go" -type f -exec dirname {} \;); do
  echo "[INFO] Testing dir ${test_dir}"
  pushd ${test_dir}
  go mod tidy
  go test -v .
  popd
done
```

Useful links:

* [Article about terratest-helm](https://www.phillipsj.net/posts/yes-you-can-unit-test-helm-charts/)
* [GO - Terratest helm example](https://github.com/gruntwork-io/terratest-helm-testing-example)
