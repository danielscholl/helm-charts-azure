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
	appsv1 "k8s.io/api/apps/v1"
)

//const kubeVersion = "1.24"

func TestOsduIstioRendered(t *testing.T) {
	t.Parallel()
	chartPaths := []string{
		"../../../osdu-istio",
	}

	// To test if the msosdu it is present in the above files by default
	for _, cp := range chartPaths {
		t.Run(fmt.Sprintf("TestChart_%s", filepath.Base(cp)), func(t *testing.T) {
			// arrange
			chartPath, err := filepath.Abs(cp)
			releaseName := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))
			namespace := fmt.Sprintf("test-%s", strings.ToLower(random.UniqueId()))

			require.NoError(t, err)

			options := &helm.Options{
				KubectlOptions: k8s.NewKubectlOptions("", "", namespace),
			}

			// act
			t.Log(fmt.Sprintf("Helm chart path: %s", chartPath))

			// https://github.com/gruntwork-io/terratest/blob/master/test/helm_basic_example_template_test.go
			//
			output := helm.RenderTemplate(t, options, chartPath, releaseName, []string{}, "--kube-version", kubeVersion)

			var deployment appsv1.Deployment
			helm.UnmarshalK8SYaml(t, output, &deployment)

			// assert Contains namespace in the output string
			require.Contains(t, output, namespace)
			// Assert that it is using by default the msosdu ACR for istio images
			assert.Contains(t, output, "msosdu.azurecr.io")
		})
	}
}
