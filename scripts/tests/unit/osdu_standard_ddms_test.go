package test

// https://www.phillipsj.net/posts/yes-you-can-unit-test-helm-charts/
import (
	"fmt"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/helm"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

//const kubeVersion = "1.24"

func TestOsduStandardDdmsRendered(t *testing.T) {
	t.Parallel()
	chartDdmsPath := "../../../osdu-ddms/standard-ddms"

	valuesFiles := []string{
		"../../../osdu-ddms/standard-ddms/seismic.osdu.values.yaml",
		"../../../osdu-ddms/standard-ddms/reservoir.osdu.values.yaml",
		"../../../osdu-ddms/standard-ddms/well-delivery.osdu.values.yaml",
		"../../../osdu-ddms/standard-ddms/wellbore.osdu.values.yaml",
	}

	// To test if the msosdu it is present in the above files by default
	for _, cp := range valuesFiles {
		t.Run(fmt.Sprintf("%s_%s", filepath.Base(chartDdmsPath), filepath.Base(cp)), func(t *testing.T) {
			// arrange
			chartPath, err := filepath.Abs(chartDdmsPath)
			valuePath, err := filepath.Abs(cp)
			releaseName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))
			namespace := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))
			acrTestValue := fmt.Sprintf("azure.acr=acr-test-%s", strings.ToLower(random.UniqueId()))

			require.NoError(t, err)

			options := &helm.Options{
				KubectlOptions: k8s.NewKubectlOptions("", "", namespace),
			}

			// act
			t.Log(fmt.Sprintf("Helm chart path: %s", chartPath))

			// https://github.com/gruntwork-io/terratest/blob/master/test/helm_basic_example_template_test.go
			//
			output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{}, "--kube-version", kubeVersion, "-f", valuePath, "--set", acrTestValue)

			// var deployment appsv1.Deployment
			// assert Contains namespace in the output string
			assert.Contains(t, output, namespace)
			// Assert that it is usint the default acr repository
			// assert.Contains(t, output, acrTestValue)
		})
	}
}
